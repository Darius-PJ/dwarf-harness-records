[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$GrantReference,
    [Parameter(Mandatory = $true)][ValidatePattern('^[0-9a-f]{40}$')][string]$ExpectedSubject
)

# SOURCE ONLY until primary approves this exact subject, both temporary product
# permissions and the serial compute slot. A reference records a real grant; it
# does not issue one. Retargeting requires refreshed bindings and PM review.
# Use parent tool timeout=0. Do not terminate this process while a mutant is
# installed: handled failures restore in finally; external termination cannot.
# Adapted narrowly from S2's Run-Command/Run-RuleBreak, with finite reap/stream
# deadlines and evidence classification for these two specific public failures.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($GrantReference)) { throw 'An actual grant reference is required' }
$Root = 'C:/Users/darius.jones/worktrees/dwarf-harness/139-acceptance'
$Evidence = 'C:/Users/darius.jones/worktrees/dwarf-harness/t139-s3-evidence'
$Go = 'C:/Program Files/Go/bin/go.exe'
# Provisional CODE_READY bindings, NOT the promised execution subject. Before
# launch, PM rebinds ReviewedSubject, PlanHash and SourceHashes to primary's
# actual FINAL CUMULATIVE prefix, adding the final helper/codec source hashes
# and refreshing both original hashes/unique anchors in the reviewed proposal.
# The mandatory ExpectedSubject comes from that separate primary ruling.
$ReviewedSubject = '67d9636d6c70ba8cab2810bcec81c31a6c5df914'
$PlanPath = Join-Path $Evidence 'final-commands.json'
$PlanHash = 'be68c1fe94648f1a76c92cc2d976cf39e5eecd316594577efab98d721974daff'
$SourceHashes = [ordered]@{
    'internal/core/agents/registration_state.go' = '5fd211ee66aef9b73e985f4fa4fd8ff461dab8725ed3ea1c240785fd787287fa'
    'internal/core/agents/scoped_state.go' = '9ce8f61064c9673ba3374fb6b3a4ccafa44cc88a59a1c229d2e0c4440d27f3d1'
    'internal/core/agents/registration_crash_test.go' = 'f937f77b81699adabd7d80001e3dd0f6a58d0b692690e0ff8b3090261e3d8241'
    'internal/core/agents/registration_recovery_test.go' = 'd5cfdc0e42b4e718a85a18f3ef3b9f3f89088236ab04f19d031c6baf38abb479'
    '_t139_smoke/main.go' = '80463d040929445e6f53811f3fb2b3d98876dee9cb0b64b1228bbc0dc66a3036'
}
if ($ExpectedSubject -cne $ReviewedSubject) {
    throw 'Expected final cumulative subject is not this reviewed binding; rebind and obtain PM review before launch'
}
$CommonEnvironment = [ordered]@{
    GOTOOLCHAIN = 'local'; GOFLAGS = ''; GOROOT = 'C:/Program Files/Go'
    GOOS = 'windows'; GOARCH = 'amd64'; CGO_ENABLED = '0'
}
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$Run = Join-Path $Evidence ('risk-' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ') + '-' + $PID)
[void][IO.Directory]::CreateDirectory($Run)
$CommandRecords = New-Object 'System.Collections.Generic.List[object]'
$RuleBreakRecords = New-Object 'System.Collections.Generic.List[object]'

function Write-Text([string]$Path, [string]$Text) {
    [IO.File]::WriteAllText($Path, $Text, $script:Utf8)
}
function Write-Json([string]$Path, $Value) {
    Write-Text $Path (($Value | ConvertTo-Json -Depth 24) + "`n")
}
function File-Hash([string]$Path) {
    return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}
function Native-Argument([string]$Value) {
    $escaped = [regex]::Replace($Value, '(\\*)"', '$1$1\"')
    $escaped = [regex]::Replace($escaped, '(\\+)$', '$1$1')
    return '"' + $escaped + '"'
}
function Assert-ReviewedSources([string]$Phase) {
    $rows = @($script:SourceHashes.Keys | ForEach-Object {
        $path = Join-Path $script:Root $_
        $actual = File-Hash $path
        [pscustomobject][ordered]@{
            path = $path; expectedSHA256 = $script:SourceHashes[$_]
            actualSHA256 = $actual; matches = $actual -ceq $script:SourceHashes[$_]
        }
    })
    Write-Json (Join-Path $script:Run ($Phase + '.source-hashes.json')) $rows
    if (@($rows | Where-Object { -not $_.matches }).Count -ne 0) {
        throw 'Reviewed source differs; stop for a new subject/hash ruling without changing it'
    }
}
function Stop-Tree([Diagnostics.Process]$Process, [string]$Name) {
    $stop = New-Object Diagnostics.Process
    $psi = New-Object Diagnostics.ProcessStartInfo
    $psi.FileName = "$env:SystemRoot/System32/taskkill.exe"
    $psi.Arguments = "/PID $($Process.Id) /T /F"
    $psi.WorkingDirectory = $script:Root
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $stop.StartInfo = $psi
    $stopRecord = [ordered]@{
        executable = $psi.FileName; argv = @('/PID', [string]$Process.Id, '/T', '/F')
        startedUTC = [DateTime]::UtcNow.ToString('o'); finishedUTC = $null
        exitCode = $null; timedOut = $false; requestedProcessReaped = $false; error = $null
    }
    try {
        if (-not $stop.Start()) { throw 'taskkill did not start' }
        if (-not $stop.WaitForExit(10000)) {
            $stopRecord.timedOut = $true
            $stop.Kill()
            if (-not $stop.WaitForExit(10000)) { throw 'taskkill itself was not reaped' }
        }
        $stopRecord.exitCode = $stop.ExitCode
        $stopRecord.requestedProcessReaped = $Process.WaitForExit(30000)
        if (-not $stopRecord.requestedProcessReaped) {
            throw 'Process tree not reaped; stop and do not release the compute slot'
        }
    } catch {
        $stopRecord.error = $_.Exception.ToString()
        throw
    } finally {
        $stopRecord.finishedUTC = [DateTime]::UtcNow.ToString('o')
        Write-Json (Join-Path $script:Run ($Name + '.tree-stop.json')) $stopRecord
        $stop.Dispose()
    }
}
function Run-Command {
    param([string]$Name, [string]$Executable, [string[]]$Arguments, [int]$TimeoutSeconds, [switch]$AllowFailure)
    $record = [ordered]@{
        name = $Name; executable = $Executable; argv = $Arguments; cwd = $script:Root
        environmentOverrides = $script:CommonEnvironment; timeoutSeconds = $TimeoutSeconds
        startedUTC = [DateTime]::UtcNow.ToString('o'); finishedUTC = $null; elapsedSeconds = $null
        exitCode = $null; timedOut = $false; reaped = $false; streamsComplete = $false; error = $null
        stdout = (Join-Path $script:Run ($Name + '.stdout.log'))
        stderr = (Join-Path $script:Run ($Name + '.stderr.log'))
        metadata = (Join-Path $script:Run ($Name + '.json'))
    }
    Write-Json $record.metadata $record
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
    foreach ($key in $script:CommonEnvironment.Keys) { $psi.EnvironmentVariables[$key] = $script:CommonEnvironment[$key] }
    $process.StartInfo = $psi
    $stdout = ''; $stderr = ''; $started = $false; $outTask = $null; $errTask = $null
    try {
        $started = $process.Start()
        if (-not $started) { throw 'Process.Start returned false' }
        $outTask = $process.StandardOutput.ReadToEndAsync()
        $errTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
            $record.timedOut = $true
            Stop-Tree $process $Name
        }
        $record.reaped = $process.HasExited
        $record.exitCode = $process.ExitCode
        if (-not $outTask.Wait(30000) -or -not $errTask.Wait(30000)) {
            throw 'Raw stream collection exceeded its finite deadline'
        }
        $record.streamsComplete = $true
    } catch {
        $record.error = $_.Exception.ToString()
        throw
    } finally {
        try {
            if ($started -and -not $process.HasExited) { Stop-Tree $process ($Name + '-abort') }
        } finally {
            if ($started -and $process.HasExited) {
                $record.reaped = $true
                $record.exitCode = $process.ExitCode
            }
            if ($null -ne $outTask -and $outTask.Status -eq [Threading.Tasks.TaskStatus]::RanToCompletion) { $stdout = $outTask.Result }
            if ($null -ne $errTask -and $errTask.Status -eq [Threading.Tasks.TaskStatus]::RanToCompletion) { $stderr = $errTask.Result }
            $watch.Stop()
            $record.finishedUTC = [DateTime]::UtcNow.ToString('o')
            $record.elapsedSeconds = $watch.Elapsed.TotalSeconds
            Write-Text $record.stdout $stdout
            Write-Text $record.stderr $stderr
            Write-Json $record.metadata $record
            $script:CommandRecords.Add([pscustomobject]$record)
            Write-Json (Join-Path $script:Run 'commands.json') @($script:CommandRecords.ToArray())
            $process.Dispose()
        }
    }
    Write-Host ("{0}: exit={1} timeout={2} seconds={3:N3}" -f $Name, $record.exitCode, $record.timedOut, $record.elapsedSeconds)
    if (-not $AllowFailure -and ($record.exitCode -ne 0 -or $record.timedOut -or -not $record.reaped -or -not $record.streamsComplete)) {
        throw "Command failed; no automatic retry: $Name"
    }
    return [pscustomobject]$record
}
function Run-RuleBreak {
    param($Plan, [string]$ExpectedPASS)
    $name = [string]$Plan.id
    $path = Join-Path $script:Root $Plan.path
    Assert-ReviewedSources ($name + '-before')
    $original = [IO.File]::ReadAllBytes($path)
    $originalPath = Join-Path $script:Run ($name + '.original.go')
    [IO.File]::WriteAllBytes($originalPath, $original)
    $originalHash = File-Hash $originalPath
    if ($originalHash -cne $Plan.originalSourceSHA256 -or (File-Hash $path) -cne $originalHash) {
        throw 'Original bytes differ from reviewed source; no mutation installed'
    }
    $text = $script:Utf8.GetString($original)
    $before = [string]$Plan.original
    $after = [string]$Plan.replacement
    if ([regex]::Matches($text, [regex]::Escape($before)).Count -ne 1) {
        throw "Mutation anchor is not unique: $name; no mutation installed"
    }
    $index = $text.IndexOf($before, [StringComparison]::Ordinal)
    $line = ($text.Substring(0, $index).Split([char]10)).Length
    $beforeLines = @($before.TrimEnd([char]10).Split([char]10))
    $afterLines = @($after.TrimEnd([char]10).Split([char]10))
    $diff = @("--- a/$($Plan.path)", "+++ b/$($Plan.path)", ("@@ -{0},{1} +{0},{2} @@" -f $line, $beforeLines.Count, $afterLines.Count))
    $diff += @($beforeLines | ForEach-Object { '-' + $_ })
    $diff += @($afterLines | ForEach-Object { '+' + $_ })
    $diffPath = Join-Path $script:Run ($name + '.patch')
    Write-Text $diffPath (($diff -join "`n") + "`n")
    $mutantPath = Join-Path $script:Run ($name + '.mutant.go')
    $mutant = $script:Utf8.GetBytes($text.Replace($before, $after))
    [IO.File]::WriteAllBytes($mutantPath, $mutant)
    $proof = [ordered]@{
        name = $name; path = $path; target = $Plan.namedRegression
        expectedFailure = $Plan.expectedConsumerFailure; diff = $diffPath
        originalSource = $originalPath; originalSHA256 = $originalHash
        mutantSource = $mutantPath; mutantSHA256 = (File-Hash $mutantPath)
        restoredSHA256 = $null; byteIdenticalRestoration = $false
        red = (Join-Path $script:Run ($name + '-red.json')); green = $null
        classification = 'not-run'; observedBoundary = $null; evidence = @()
        classifierError = $null; driverError = $null; restorationError = $null
        greenClassification = 'not-run'; requiresPMRuling = $true
    }
    $proofPath = Join-Path $script:Run ($name + '.proof.json')
    Write-Json $proofPath $proof
    $script:RuleBreakRecords.Add($proof)
    try {
        [IO.File]::WriteAllBytes($path, $mutant)
        if ((File-Hash $path) -cne $proof.mutantSHA256) { throw 'Installed mutant differs from archived exact mutant' }
        $red = Run-Command -Name ($name + '-red') -Executable $script:Go -Arguments ([string[]]$Plan.redThenIdenticalRestoredGreen.argv) -TimeoutSeconds 1200 -AllowFailure
        $stdout = [IO.File]::ReadAllText($red.stdout)
        $raw = $stdout + "`n" + [IO.File]::ReadAllText($red.stderr)
        if ($red.timedOut -or $raw -match 'panic: test timed out after') {
            $proof.classification = 'unproven-timeout'
        } elseif ($raw -match '\[build failed\]') {
            $proof.classification = 'unproven-build-or-compile-failure'
        } elseif ($red.exitCode -eq 0) {
            if ($stdout -match $ExpectedPASS) { $proof.classification = 'survived-or-masked' }
            else { $proof.classification = 'unproven-target-not-run' }
        } else {
            $proof.classification = 'unproven-unrelated-failure'
            if ($red.exitCode -eq 1 -and $red.reaped -and $red.streamsComplete) {
                try {
                    if ($name -ceq 'withdrawal-install-omitted') {
                        $wait = [regex]::Match($stdout, '(?m)^.*child wait: reaped=true state=exit status 73 error=exit status 73 output=(\{[^\r\n]+\})\r?$')
                        $opened = $stdout.IndexOf('agents.Open: durable=53 ledger_unchanged=true', [StringComparison]::Ordinal)
                        $failure = [regex]::Match($stdout, '(?m)^.*partial or missing declaration recovery: [^\r\n]+')
                        if ($wait.Success -and $failure.Success -and $opened -gt $wait.Index -and $failure.Index -gt $opened) {
                            $signal = $wait.Groups[1].Value | ConvertFrom-Json
                            $separator = $failure.Value.IndexOf(' want ', [StringComparison]::Ordinal)
                            if ($separator -gt 0) {
                                $actual = $failure.Value.Substring(0, $separator)
                                $wanted = $failure.Value.Substring($separator + 6)
                                $correctBoundary = $signal.Boundary -ceq 'durable_before_install' -and $signal.Before -eq 50 -and $signal.EffectSequence -eq 52 -and $signal.Sequence -eq 53 -and $signal.Receipt.version -eq 3 -and $signal.Receipt.submission.arguments.expected_version -eq 2 -and @($signal.Receipt.submission.arguments.consumers).Count -eq 0
                                $activeToEmpty = $actual -match '(?:\s|\{)Version:2(?:\s|\})' -and $actual.Contains('Kind:context') -and $actual.Contains('Kind:task') -and $wanted -match '(?:\s|\{)Version:3(?:\s|\})' -and $wanted.Contains('Consumers:[]') -and $wanted.Contains('ReceiptSequence:53')
                                if ($correctBoundary -and $activeToEmpty -and $stdout -match '(?m)^\s*--- FAIL: TestRegistrationInjectedCrashRecovery/durable_before_install \(') {
                                    $proof.classification = 'killed-by-expected-regression'
                                    $proof.observedBoundary = 'public-recovered-declaration-after-durable-child-boundary'
                                    $proof.evidence = @($wait.Value, 'agents.Open: durable=53 ledger_unchanged=true', $failure.Value)
                                }
                            }
                        }
                    } elseif ($name -ceq 'external-grant-needs-registration') {
                        # The bound source calls openPaidFixture at line 176;
                        # frozen seqs 27-29 issue the first opaque external grant.
                        # Its helper marks t.Helper and prints the actual Open error.
                        $openFailure = [regex]::Match($stdout, '(?m)^.*registration_recovery_test\.go:176: agents: inconsistent record at sequence 27: invalid scoped transition: agents: unavailable\s*$')
                        $delegationFailure = [regex]::Match($stdout, '(?m)^.*registration_recovery_test\.go:198: existing grant permission depends on registration: agents: unavailable\s*$')
                        if ($stdout -match '(?m)^--- FAIL: TestRegistrationPaidHistoryRecovery \(') {
                            if ($openFailure.Success) {
                                $proof.classification = 'killed-by-expected-regression'
                                $proof.observedBoundary = 'public-Service-Open-before-delegation'
                                $proof.evidence = @($openFailure.Value)
                            } elseif ($delegationFailure.Success) {
                                $proof.classification = 'killed-by-expected-regression'
                                $proof.observedBoundary = 'public-existing-grant-delegation-before-registration'
                                $proof.evidence = @($delegationFailure.Value)
                            }
                        }
                    }
                } catch {
                    $proof.classifierError = $_.Exception.ToString()
                    $proof.classification = 'unproven-evidence-shape'
                }
            }
        }
    } catch {
        $proof.driverError = $_.Exception.ToString()
        $proof.classification = 'unproven-runner-error'
        throw
    } finally {
        try {
            # Restore exact original bytes on every handled path, including an
            # interrupted/partial mutant write. Never run green before equality.
            [IO.File]::WriteAllBytes($path, $original)
            $restored = [IO.File]::ReadAllBytes($path)
            $proof.restoredSHA256 = File-Hash $path
            $proof.byteIdenticalRestoration = [Convert]::ToBase64String($restored) -ceq [Convert]::ToBase64String($original)
            if (-not $proof.byteIdenticalRestoration -or $proof.restoredSHA256 -cne $originalHash) {
                throw 'Exact source restoration failed; stop immediately'
            }
        } catch {
            $proof.restorationError = $_.Exception.ToString()
            throw
        } finally {
            Write-Json $proofPath $proof
            Write-Json (Join-Path $script:Run 'rule-breaks.json') @($script:RuleBreakRecords.ToArray())
        }
    }
    if ($proof.classification -cne 'killed-by-expected-regression') {
        throw "Unproved red outcome restored; PM ruling required before further Go work: $name"
    }
    Assert-ReviewedSources ($name + '-restored-before-green')
    $proof.green = Join-Path $script:Run ($name + '-restored-green.json')
    try {
        $green = Run-Command -Name ($name + '-restored-green') -Executable $script:Go -Arguments ([string[]]$Plan.redThenIdenticalRestoredGreen.argv) -TimeoutSeconds 1200 -AllowFailure
        $greenRaw = [IO.File]::ReadAllText($green.stdout) + "`n" + [IO.File]::ReadAllText($green.stderr)
        if ($green.timedOut -or $greenRaw -match 'panic: test timed out after') {
            $proof.greenClassification = 'unproven-timeout'
        } elseif ($greenRaw -match '\[build failed\]') {
            $proof.greenClassification = 'unproven-build-or-compile-failure'
        } elseif ($green.exitCode -eq 0 -and $green.reaped -and $green.streamsComplete -and $greenRaw -match $ExpectedPASS) {
            $proof.greenClassification = 'restored-green'
            Assert-ReviewedSources ($name + '-after-green')
            $proof.requiresPMRuling = $false
        } else {
            $proof.greenClassification = 'unproven-restored-target-failure-or-not-run'
        }
    } catch {
        $proof.driverError = $_.Exception.ToString()
        $proof.greenClassification = 'unproven-runner-or-source-error'
        throw
    } finally {
        Write-Json $proofPath $proof
        Write-Json (Join-Path $script:Run 'rule-breaks.json') @($script:RuleBreakRecords.ToArray())
    }
    if ($proof.greenClassification -cne 'restored-green') {
        throw "Restored green unproved; PM ruling required before further Go work: $name"
    }
}

$runnerExit = 1
$summary = [ordered]@{
    status = 'started'; grantReference = $GrantReference; root = $Root
    expectedSubject = $ExpectedSubject; reviewedSubject = $ReviewedSubject; observedSubject = $null
    startedUTC = [DateTime]::UtcNow.ToString('o'); finishedUTC = $null; exitCode = $null; error = $null
    commands = (Join-Path $Run 'commands.json'); ruleBreaks = (Join-Path $Run 'rule-breaks.json')
    scope = 'Exactly two independent mutants and their same-target restored greens; at most four targeted Go test commands, no baseline/full-package/format/smoke/fuzz/race/check'
    restoration = 'Each attempted mutant restored in finally; equality required before green; external process termination cannot run finally'
    failurePolicy = 'Stop after restoration on compile/timeout/unrelated/survived/evidence-shape failures; no second mutant, extra weakening, retries or unproved green'
}
Write-Json (Join-Path $Run 'summary.json') $summary
try {
    [IO.File]::WriteAllBytes((Join-Path $Run 'run-risk.ps1'), [IO.File]::ReadAllBytes($PSCommandPath))
    [IO.File]::WriteAllBytes((Join-Path $Run 'final-commands.json'), [IO.File]::ReadAllBytes($PlanPath))
    if ((File-Hash $PlanPath) -cne $PlanHash -or (File-Hash (Join-Path $Run 'final-commands.json')) -cne $PlanHash) {
        throw 'Reviewed exact command/diff proposal changed; stop for PM review'
    }
    $proposal = [IO.File]::ReadAllText((Join-Path $Run 'final-commands.json')) | ConvertFrom-Json
    if ($proposal.sourceBase -cne $ReviewedSubject -or $proposal.cwd -cne $Root -or $proposal.mutationPlans.Count -ne 2 -or $proposal.mutationPlans[0].id -cne 'withdrawal-install-omitted' -or $proposal.mutationPlans[1].id -cne 'external-grant-needs-registration') {
        throw 'Proposal is not the exact two-mutant reviewed subject'
    }
    Assert-ReviewedSources 'initial'
    $git = (Get-Command git.exe -CommandType Application -ErrorAction Stop).Source
    $head = Run-Command '00-reviewed-head' $git @('rev-parse', '--verify', 'HEAD') 30
    $summary.observedSubject = [IO.File]::ReadAllText($head.stdout).Trim()
    if ($summary.observedSubject -cne $ReviewedSubject) {
        throw 'Worktree HEAD changed; explicit retarget and refreshed source proof required before mutants'
    }
    Write-Json (Join-Path $Run 'runner-input.json') ([ordered]@{
        runner = $PSCommandPath; runnerSHA256 = File-Hash $PSCommandPath
        retainedRunnerSHA256 = File-Hash (Join-Path $Run 'run-risk.ps1')
        grantReference = $GrantReference; expectedSubject = $ExpectedSubject; reviewedSubject = $ReviewedSubject; observedSubject = $summary.observedSubject
        proposalSHA256 = $PlanHash; sourceHashes = $SourceHashes; environmentOverrides = $CommonEnvironment
        inheritedEnvironmentNamesOnly = @(Get-ChildItem Env: | ForEach-Object { $_.Name } | Sort-Object)
        toolchainVersionRequired = 'go1.27.3'; toolchainSetupOrVersionCommands = 'none'
        requiredTemporaryPermissions = @('internal/core/agents/registration_state.go', 'internal/core/agents/scoped_state.go')
        testDeadline = '19m'; commandDeadlineSeconds = 1200; parentToolTimeoutSeconds = 0
        timeoutHandling = 'taskkill 10s plus at most 10s to reap itself; target reap 30s; stream reads at most 30s each; no automatic retry'
    })
    Run-RuleBreak $proposal.mutationPlans[0] '(?m)^\s*--- PASS: TestRegistrationInjectedCrashRecovery/durable_before_install \('
    Run-RuleBreak $proposal.mutationPlans[1] '(?m)^--- PASS: TestRegistrationPaidHistoryRecovery \('
    $summary.status = 'two-named-reds-and-restored-greens-complete'
    $runnerExit = 0
} catch {
    $summary.status = 'stopped-for-PM-ruling'
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
