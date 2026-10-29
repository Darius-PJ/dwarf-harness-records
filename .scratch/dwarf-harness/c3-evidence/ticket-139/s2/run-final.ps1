[CmdletBinding()]
param()

# Run only after the PM explicitly releases this runner. Its parent tool must
# use timeout=0: the serial child deadlines intentionally exceed one tool cap.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Root = 'C:/Users/darius.jones/worktrees/dwarf-harness/139-registration'
$Evidence = 'C:/Users/darius.jones/worktrees/dwarf-harness/t139-s2-evidence'
$Go = 'C:/Program Files/Go/bin/go.exe'
$Gofmt = 'C:/Program Files/Go/bin/gofmt.exe'
$RaceCC = 'C:/Users/darius.jones/AppData/Local/Programs/llvm-mingw-20260922-ucrt-x86_64/bin/x86_64-w64-mingw32-clang.exe'
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$OwnedNames = @(
    'registration_types.go', 'registration_commands.go', 'registration_replay.go',
    'registration_state.go', 'registration_query.go', 'registration_service_test.go',
    'registration_replay_test.go', 'registration_fuzz_test.go', 'service.go', 'types.go',
    'scoped_replay.go', 'replay.go', 'doc.go', 'scoped_golden_test.go', 'integrity.go',
    'paid_fixture_test.go', 'paid_fuzz_test.go', 'paid_live.go', 'paid_read.go',
    'paid_settlement.go', 'paid_state.go', 'review_execute.go', 'review_fuzz_test.go',
    'review_replay_test.go', 'review_state.go', 'scoped_submit.go', 'history_index.go'
)
$Owned = @($OwnedNames | ForEach-Object { "$Root/internal/core/agents/$_" })
$CommonEnvironment = [ordered]@{
    GOTOOLCHAIN = 'local'; GOFLAGS = ''; GOROOT = 'C:/Program Files/Go'
    GOOS = 'windows'; GOARCH = 'amd64'; CGO_ENABLED = '0'
}
$Run = Join-Path $Evidence ('run-' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ') + '-' + $PID)
[void][IO.Directory]::CreateDirectory($Run)
$CommandRecords = New-Object 'System.Collections.Generic.List[object]'
$RuleBreakRecords = New-Object 'System.Collections.Generic.List[object]'
$ProofIncomplete = $false

function Write-Text([string]$Path, [string]$Text) {
    [IO.File]::WriteAllText($Path, $Text, $script:Utf8)
}
function Write-Json([string]$Path, $Value) {
    Write-Text $Path (($Value | ConvertTo-Json -Depth 20) + "`n")
}
function File-Hash([string]$Path) {
    return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}
function Native-Argument([string]$Value) {
    # Windows CRT argv quoting, including embedded quotes and trailing slashes.
    $escaped = [regex]::Replace($Value, '(\\*)"', '$1$1\"')
    $escaped = [regex]::Replace($escaped, '(\\+)$', '$1$1')
    return '"' + $escaped + '"'
}
function Run-Command {
    param(
        [string]$Name, [string]$Executable, [string[]]$Arguments,
        [int]$TimeoutSeconds, [switch]$Race, [switch]$AllowFailure
    )
    $environment = [ordered]@{}
    foreach ($key in $script:CommonEnvironment.Keys) { $environment[$key] = $script:CommonEnvironment[$key] }
    if ($Race) { $environment.CGO_ENABLED = '1'; $environment.CC = $script:RaceCC }
    $stdoutPath = Join-Path $script:Run ($Name + '.stdout.log')
    $stderrPath = Join-Path $script:Run ($Name + '.stderr.log')
    $metadataPath = Join-Path $script:Run ($Name + '.json')
    $record = [ordered]@{
        name = $Name; executable = $Executable; argv = $Arguments; cwd = $script:Root
        environmentOverrides = $environment; timeoutSeconds = $TimeoutSeconds
        startedUTC = [DateTime]::UtcNow.ToString('o'); finishedUTC = $null
        elapsedSeconds = $null; exitCode = $null; timedOut = $false; error = $null
        stdout = $stdoutPath; stderr = $stderrPath; metadata = $metadataPath
    }
    Write-Json $metadataPath $record
    $watch = [Diagnostics.Stopwatch]::StartNew()
    $process = New-Object Diagnostics.Process
    $psi = New-Object Diagnostics.ProcessStartInfo
    $psi.FileName = $Executable
    $psi.Arguments = (($Arguments | ForEach-Object { Native-Argument $_ }) -join ' ')
    $psi.WorkingDirectory = $script:Root
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    foreach ($key in $environment.Keys) { $psi.EnvironmentVariables[$key] = $environment[$key] }
    $process.StartInfo = $psi
    $stdout = ''; $stderr = ''; $started = $false
    try {
        $started = $process.Start()
        if (-not $started) { throw 'Process.Start returned false' }
        $outTask = $process.StandardOutput.ReadToEndAsync()
        $errTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
            $record.timedOut = $true
            $killOutput = & "$env:SystemRoot/System32/taskkill.exe" /PID $process.Id /T /F 2>&1
            Write-Text (Join-Path $script:Run ($Name + '.timeout-kill.log')) (($killOutput | Out-String) + "exit=$LASTEXITCODE`n")
            if (-not $process.WaitForExit(30000)) { throw 'Timed-out process tree did not exit after taskkill' }
        }
        $stdout = $outTask.GetAwaiter().GetResult()
        $stderr = $errTask.GetAwaiter().GetResult()
        $record.exitCode = $process.ExitCode
    } catch {
        $record.error = $_.Exception.ToString()
        throw
    } finally {
        if ($started -and -not $process.HasExited) {
            $killOutput = & "$env:SystemRoot/System32/taskkill.exe" /PID $process.Id /T /F 2>&1
            Write-Text (Join-Path $script:Run ($Name + '.abort-kill.log')) (($killOutput | Out-String) + "exit=$LASTEXITCODE`n")
            [void]$process.WaitForExit(30000)
        }
        if ($started -and $process.HasExited) {
            # Preserve both raw streams separately; do not fabricate interleaving.
            $stdout = $outTask.GetAwaiter().GetResult()
            $stderr = $errTask.GetAwaiter().GetResult()
            $record.exitCode = $process.ExitCode
        }
        $watch.Stop()
        $record.finishedUTC = [DateTime]::UtcNow.ToString('o')
        $record.elapsedSeconds = $watch.Elapsed.TotalSeconds
        Write-Text $stdoutPath $stdout
        Write-Text $stderrPath $stderr
        Write-Json $metadataPath $record
        $script:CommandRecords.Add([pscustomobject]$record)
        Write-Json (Join-Path $script:Run 'commands.json') @($script:CommandRecords.ToArray())
        $process.Dispose()
    }
    Write-Host ("{0}: exit={1} timeout={2} seconds={3:N3}" -f $Name, $record.exitCode, $record.timedOut, $record.elapsedSeconds)
    if (-not $AllowFailure -and ($record.exitCode -ne 0 -or $record.timedOut)) {
        throw "Command failed; no automatic retry: $Name (see $metadataPath)"
    }
    return [pscustomobject]$record
}
function Require-EmptyOutput($Record) {
    if ([IO.File]::ReadAllText($Record.stdout).Trim().Length -ne 0 -or [IO.File]::ReadAllText($Record.stderr).Trim().Length -ne 0) {
        throw "Expected no output: $($Record.name); raw streams retained"
    }
}
function Capture-Baseline([string]$Name) {
    $started = [DateTime]::UtcNow
    $paths = @("$script:Root/go.mod", "$script:Root/go.sum")
    $fixtureRoot = "$script:Root/contract/ledger/testdata/f3"
    $paths += @(Get-ChildItem -LiteralPath $fixtureRoot -File -Recurse | Sort-Object FullName | ForEach-Object { $_.FullName })
    $entries = @($paths | ForEach-Object {
        [pscustomobject][ordered]@{
            path = $_.Substring($script:Root.Length + 1).Replace('\', '/')
            sha256 = File-Hash $_
        }
    })
    $path = Join-Path $script:Run ($Name + '.json')
    Write-Json $path $entries
    Write-Json (Join-Path $script:Run ($Name + '.metadata.json')) ([ordered]@{
        operation = 'Get-FileHash SHA256: go.mod, go.sum, every existing F3 fixture file'
        cwd = $script:Root; startedUTC = $started.ToString('o')
        finishedUTC = [DateTime]::UtcNow.ToString('o'); exitCode = 0
        includesFrozen139 = $true; result = $path
    })
    return $path
}
function Run-RuleBreak {
    param([string]$Name, [string]$RelativePath, [string]$Before, [string]$After, [string]$Target, [string]$ExpectedFailure)
    $path = Join-Path $script:Root $RelativePath
    $original = [IO.File]::ReadAllBytes($path)
    $originalHash = File-Hash $path
    $text = $script:Utf8.GetString($original)
    if ([regex]::Matches($text, [regex]::Escape($Before)).Count -ne 1) {
        throw "Mutation anchor is not unique: $Name; no source change performed"
    }
    $index = $text.IndexOf($Before, [StringComparison]::Ordinal)
    $line = ($text.Substring(0, $index).Split([char]10)).Length
    $beforeLines = @($Before.TrimEnd([char]10).Split([char]10))
    $afterLines = @()
    if ($After.Length -ne 0) { $afterLines = @($After.TrimEnd([char]10).Split([char]10)) }
    $diff = @("--- a/$RelativePath", "+++ b/$RelativePath", ("@@ -{0},{1} +{0},{2} @@" -f $line, $beforeLines.Count, $afterLines.Count))
    $diff += @($beforeLines | ForEach-Object { '-' + $_ })
    $diff += @($afterLines | ForEach-Object { '+' + $_ })
    $diffPath = Join-Path $script:Run ($Name + '.patch')
    Write-Text $diffPath (($diff -join "`n") + "`n")
    [IO.File]::WriteAllBytes((Join-Path $script:Run ($Name + '.original.go')), $original)
    $mutated = $text.Replace($Before, $After)
    $proof = [ordered]@{
        name = $Name; path = $path; target = $Target; expectedFailure = $ExpectedFailure
        originalSHA256 = $originalHash; mutantSHA256 = $null; restoredSHA256 = $null
        byteIdenticalRestoration = $false; diff = $diffPath
        red = $null; green = $null; classification = 'not-run'
    }
    $proofPath = Join-Path $script:Run ($Name + '.proof.json')
    $args = @('test', '-v', '-count=1', '-timeout=19m', '-run', $Target, './internal/core/agents')
    try {
        [IO.File]::WriteAllBytes($path, $script:Utf8.GetBytes($mutated))
        $proof.mutantSHA256 = File-Hash $path
        [IO.File]::WriteAllBytes((Join-Path $script:Run ($Name + '.mutant.go')), [IO.File]::ReadAllBytes($path))
        Write-Json $proofPath $proof
        $red = Run-Command -Name ($Name + '-red') -Executable $script:Go -Arguments $args -TimeoutSeconds 1200 -AllowFailure
        $proof.red = $red.metadata
        $raw = [IO.File]::ReadAllText($red.stdout) + "`n" + [IO.File]::ReadAllText($red.stderr)
        if ($red.exitCode -eq 0 -and -not $red.timedOut) {
            $proof.classification = 'survived-or-masked'
        } elseif (-not $red.timedOut -and $red.exitCode -eq 1 -and $raw.Contains($ExpectedFailure) -and $raw.Contains('--- FAIL:')) {
            $proof.classification = 'killed-by-expected-regression'
        } else {
            $proof.classification = 'unproven-other-failure'
        }
    } finally {
        [IO.File]::WriteAllBytes($path, $original)
        $restored = [IO.File]::ReadAllBytes($path)
        $proof.restoredSHA256 = File-Hash $path
        $proof.byteIdenticalRestoration = [Convert]::ToBase64String($restored) -ceq [Convert]::ToBase64String($original)
        Write-Json $proofPath $proof
        if (-not $proof.byteIdenticalRestoration -or $proof.restoredSHA256 -ne $originalHash) {
            throw "Exact source restoration failed: $Name; stop immediately"
        }
    }
    $green = Run-Command -Name ($Name + '-restored-green') -Executable $script:Go -Arguments $args -TimeoutSeconds 1200
    $proof.green = $green.metadata
    Write-Json $proofPath $proof
    $script:RuleBreakRecords.Add([pscustomobject]$proof)
    Write-Json (Join-Path $script:Run 'rule-breaks.json') @($script:RuleBreakRecords.ToArray())
    if ($proof.classification -ne 'killed-by-expected-regression') { $script:ProofIncomplete = $true }
}

$summary = [ordered]@{
    status = 'running'; root = $Root; evidence = $Run
    startedUTC = [DateTime]::UtcNow.ToString('o'); finishedUTC = $null
    parentDeadline = 'disabled (tool timeout=0); every native child has its own deadline'
    error = $null; commands = (Join-Path $Run 'commands.json')
    ruleBreaks = (Join-Path $Run 'rule-breaks.json'); finalHashes = $null
    deletedOrRenamed = @([ordered]@{
        name = 'TestRegistrationInstalledBeforeAck'
        reason = 'New unexecuted test removed with PM approval: pins query/I/O behavior instead of observable contract'
        archive = (Join-Path $Evidence 'removed-TestRegistrationInstalledBeforeAck.txt')
    })
}
Write-Json (Join-Path $Run 'summary.json') $summary
Write-Json (Join-Path $Run 'runner-input.json') ([ordered]@{
    runner = $PSCommandPath; runnerSHA256 = File-Hash $PSCommandPath
    commandsDocumentSHA256 = File-Hash (Join-Path $Evidence 'final-commands.txt')
    approvedBaseSupplied = '34090c3b634b9854904671c336db91c350e6328c'
    branchSupplied = 'build/139-registration'; toolchainVersionSupplied = 'go1.27.3'
    ownedPaths = $Owned; environment = $CommonEnvironment
    raceEnvironment = [ordered]@{ CGO_ENABLED = '1'; CC = $RaceCC }
    inheritedEnvironmentNamesOnly = @(Get-ChildItem Env: | ForEach-Object { $_.Name } | Sort-Object)
})
$runnerExit = 1
try {
    $baselineBefore = Capture-Baseline 'module-and-f3-before'
    [void](Run-Command '01-gofmt-write' $Gofmt (@('-w') + $Owned) 120)
    $format = Run-Command '02-gofmt-list' $Gofmt (@('-l') + $Owned) 120
    Require-EmptyOutput $format
    $focusedPattern = '^(TestRegistration.*|FuzzRegistrationGroupReplay|FuzzScopedGroupReplay|FuzzReviewGroupReplay|FuzzPaidGroupReplay|FuzzPrivateGroupReplay)$'
    $focused = Run-Command '03-focused-and-seeds' $Go @('test', '-v', '-count=1', '-timeout=19m', '-run', $focusedPattern, './internal/core/agents') 1200
    $focusedText = [IO.File]::ReadAllText($focused.stdout)
    $accepted = @()
    foreach ($seed in @([pscustomobject]@{ id=0; kind='resource'; prefix=5 }, [pscustomobject]@{ id=8; kind='work_domain'; prefix=6 }, [pscustomobject]@{ id=16; kind='declaration'; prefix=13 })) {
        $pattern = '--- PASS: FuzzRegistrationGroupReplay/seed#' + $seed.id + '\s'
        $line = @($focusedText.Split([char]10) | Where-Object { $_ -match $pattern })
        if ($line.Count -eq 0) { throw "Accepted real-store replay seed evidence absent: seed#$($seed.id)" }
        $accepted += [pscustomobject][ordered]@{
            target = "FuzzRegistrationGroupReplay/seed#$($seed.id)"; kind = $seed.kind
            preparedPrefix = $seed.prefix; rawPASSLines = $line
            source = "$Root/internal/core/agents/registration_fuzz_test.go"
            sourceSHA256 = File-Hash "$Root/internal/core/agents/registration_fuzz_test.go"
            command = $focused.metadata; rawLog = $focused.stdout
            reachability = 'mode 0 requires acceptance; success then requires copied real store Submit, Open and typed snapshot/receipt assertions'
        }
    }
    Write-Json (Join-Path $Run 'accepted-registration-seeds.json') $accepted

    $ownerBefore = "`tif caller.actor != `"owner`" {`n`t`treturn RegistrationReceipt{}, ErrDenied`n`t}`n"
    Run-RuleBreak '04a-owner-entrance' 'internal/core/agents/registration_commands.go' $ownerBefore '' '^TestRegistrationAuthorityAndIdentity$' 'non-owner registration:'
    $bindingBefore = "`t" + 'if private != nil || scoped != nil || review != nil || paid != nil || g == nil || g.command.CommandID != input.id || g.command.SubmissionSHA256 != input.digest || !sameScopedValue(g.receipt.Submission, input.sub) {' + "`n"
    $bindingAfter = "`t" + 'if private != nil || scoped != nil || review != nil || paid != nil || g == nil {' + "`n"
    Run-RuleBreak '04b-original-binding' 'internal/core/agents/registration_replay.go' $bindingBefore $bindingAfter '^TestRegistrationOriginalRequestPreflight$' 'self-consistent mutation escaped original request:'
    $refreshBefore = "`t" + 'err = s.refreshLocked(context.Background(), max(s.p.through, committed.Last))' + "`n"
    $refreshAfter = "`t" + 'err = s.refreshLocked(ctx, max(s.p.through, committed.Last))' + "`n"
    Run-RuleBreak '04c-postcommit-cancellation' 'internal/core/agents/registration_commands.go' $refreshBefore $refreshAfter '^TestRegistrationCommitRetryAndClose$/^installed-lost-ack-and-cancel$' 'post-commit cancellation returned before acknowledgment hook:'

    [void](Run-Command '05-agents-plain' $Go @('test', '-v', '-count=1', '-timeout=19m', './internal/core/agents') 1200)
    [void](Run-Command '06-host-vet' $Go @('vet', './internal/core/agents') 600)
    [void](Run-Command '07-host-staticcheck' $Go @('tool', 'staticcheck', './internal/core/agents') 600)
    [void](Run-Command '08-agents-race' $Go @('test', '-race', '-v', '-count=1', '-timeout=29m', './internal/core/agents') 1800 -Race)
    $repeatPattern = '^(TestRegistrationVersionCAS|TestRegistrationCommitRetryAndClose)$/^(resource|work_domain|declaration|concurrent-retry|close-fence)$'
    [void](Run-Command '09-affected-race-x20' $Go @('test', '-race', '-v', '-count=20', '-timeout=45m', '-run', $repeatPattern, './internal/core/agents') 2800 -Race)
    [void](Run-Command '10-production-imports' $Go @('list', '-f', '{{join .Imports "\n"}}', './internal/core/agents') 300)
    [void](Run-Command '11-test-imports' $Go @('list', '-f', '{{join .TestImports "\n"}}', './internal/core/agents') 300)
    $tidy = Run-Command '12-module-tidy-diff' $Go @('mod', 'tidy', '-diff') 600
    Require-EmptyOutput $tidy
    [void](Run-Command '13-module-verify' $Go @('mod', 'verify') 600)
    $baselineAfter = Capture-Baseline 'module-and-f3-after'
    $baselineUnchanged = [IO.File]::ReadAllText($baselineBefore) -ceq [IO.File]::ReadAllText($baselineAfter)
    Write-Json (Join-Path $Run 'baseline-comparison.json') ([ordered]@{
        before = $baselineBefore; after = $baselineAfter; identical = $baselineUnchanged
        rule = 'Both module files and the entire frozen F3 fixture path/hash set remain unchanged'
    })
    if (-not $baselineUnchanged) { throw 'Module or frozen F3 fixture baseline changed; no restoration of unrelated files attempted' }
    $hashes = @($Owned | ForEach-Object { [pscustomobject][ordered]@{ path = $_; sha256 = File-Hash $_ } })
    $summary.finalHashes = Join-Path $Run 'final-hashes.json'
    Write-Json $summary.finalHashes $hashes
    if ($ProofIncomplete) { $summary.status = 'checks-complete-rule-break-proof-incomplete'; $runnerExit = 2 }
    else { $summary.status = 'complete'; $runnerExit = 0 }
} catch {
    $summary.status = 'stopped'
    $summary.error = $_.Exception.ToString()
    Write-Text (Join-Path $Run 'runner-error.log') ($_ | Out-String)
} finally {
    $summary.finishedUTC = [DateTime]::UtcNow.ToString('o')
    $summary.exitCode = $runnerExit
    Write-Json (Join-Path $Run 'summary.json') $summary
    Write-Host ("Evidence: " + $Run)
    Write-Host ("Status: " + $summary.status)
}
exit $runnerExit
