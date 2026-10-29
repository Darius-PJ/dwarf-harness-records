[CmdletBinding()]
param([Parameter(Mandatory = $true)][string]$GrantReference)

# Remaining checks only after the PM grants this exact revised source and sequence.
# Completed risks and real-Service smoke are retained, never repeated here.
# Invoke the parent tool with timeout=0; each child below has a finite deadline.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Root = 'C:/Users/darius.jones/worktrees/dwarf-harness/139-acceptance'
$Evidence = 'C:/Users/darius.jones/worktrees/dwarf-harness/t139-s3-evidence'
$Go = 'C:/Program Files/Go/bin/go.exe'
$Gofmt = 'C:/Program Files/Go/bin/gofmt.exe'
$S2Frozen = 'C:/Users/darius.jones/worktrees/dwarf-harness/t139-s2-evidence/run-20261029T023939070Z-19044/module-and-f3-after.json'
$Owned = @(
    "$Root/internal/core/agents/registration_crash_test.go",
    "$Root/internal/core/agents/registration_recovery_test.go"
)
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$CommonEnvironment = [ordered]@{
    GOTOOLCHAIN = 'local'; GOFLAGS = ''; GOROOT = 'C:/Program Files/Go'
    GOOS = 'windows'; GOARCH = 'amd64'; CGO_ENABLED = '0'
}
$Run = Join-Path $Evidence ('remaining-' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ') + '-' + $PID)
[void][IO.Directory]::CreateDirectory($Run)
$CommandRecords = New-Object 'System.Collections.Generic.List[object]'

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
    # Same Windows CRT quoting as the accepted S2 evidence runner.
    $escaped = [regex]::Replace($Value, '(\\*)"', '$1$1\"')
    $escaped = [regex]::Replace($escaped, '(\\+)$', '$1$1')
    return '"' + $escaped + '"'
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
    $reaped = $false
    try {
        if (-not $stop.Start()) { throw 'taskkill did not start' }
        if (-not $stop.WaitForExit(10000)) {
            $stop.Kill()
            if (-not $stop.WaitForExit(10000)) { throw 'taskkill itself was not reaped' }
        }
        $reaped = $Process.WaitForExit(30000)
        Write-Json (Join-Path $script:Run ($Name + '.tree-stop.json')) ([ordered]@{
            executable = $psi.FileName; argv = @('/PID', [string]$Process.Id, '/T', '/F')
            exitCode = $stop.ExitCode; requestedProcessReaped = $reaped
        })
        if (-not $reaped) { throw 'Process tree did not exit after taskkill; do not release the compute slot' }
    } finally {
        $stop.Dispose()
    }
}
function Run-Command {
    param([string]$Name, [string]$Executable, [string[]]$Arguments, [int]$TimeoutSeconds)
    $stdoutPath = Join-Path $script:Run ($Name + '.stdout.log')
    $stderrPath = Join-Path $script:Run ($Name + '.stderr.log')
    $metadataPath = Join-Path $script:Run ($Name + '.json')
    $record = [ordered]@{
        name = $Name; executable = $Executable; argv = $Arguments; cwd = $script:Root
        environmentOverrides = $script:CommonEnvironment; timeoutSeconds = $TimeoutSeconds
        startedUTC = [DateTime]::UtcNow.ToString('o'); finishedUTC = $null
        elapsedSeconds = $null; exitCode = $null; timedOut = $false; reaped = $false
        streamsComplete = $false; error = $null
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
            Write-Text $stdoutPath $stdout
            Write-Text $stderrPath $stderr
            Write-Json $metadataPath $record
            $script:CommandRecords.Add([pscustomobject]$record)
            Write-Json (Join-Path $script:Run 'commands.json') @($script:CommandRecords.ToArray())
            $process.Dispose()
        }
    }
    Write-Host ("{0}: exit={1} timeout={2} seconds={3:N3}" -f $Name, $record.exitCode, $record.timedOut, $record.elapsedSeconds)
    if ($record.exitCode -ne 0 -or $record.timedOut -or -not $record.reaped -or -not $record.streamsComplete) {
        throw "Command failed; no automatic retry: $Name (see $metadataPath)"
    }
    return [pscustomobject]$record
}
function Require-EmptyOutput($Record) {
    if ([IO.File]::ReadAllText($Record.stdout).Trim().Length -ne 0 -or [IO.File]::ReadAllText($Record.stderr).Trim().Length -ne 0) {
        throw "Expected no output: $($Record.name); raw streams retained"
    }
}

$runnerExit = 1
$summary = [ordered]@{
    status = 'started'; grantReference = $GrantReference; cwd = $Root
    sourceBase = '8a17ec1ed2617ca2a4e5203479f75f363b359970'
    prefixBindingManifest = [ordered]@{
        path = 'C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-s3-remaining-prefix-binding.json'
        sha256 = '4fa8f267c37f41fb01cb15b67fcabd95b25530900e0655c6962c45626033d12f'
        sourcePathCount = 84
    }
    reusedEvidence = [ordered]@{
        risks = 'C:/Users/darius.jones/worktrees/dwarf-harness/t139-s3-evidence/risk-20261029T171230684Z-18452'
        smokeAndPartialFocus = 'C:/Users/darius.jones/worktrees/dwarf-harness/t139-s3-evidence/run-20261029T171317887Z-19436'
        bridge = 'Receipt omitempty changes only absent/zero-length test-private receipt; nonempty committed wire and strict parent checks are unchanged'
    }
    startedUTC = [DateTime]::UtcNow.ToString('o'); finishedUTC = $null; exitCode = $null
    error = $null; finalHashes = $null; finalUnchangedBindings = $null
    race = 'not run: tests-only source; no shared-state/locking production change'
    fuzz = 'ordinary seeds in the one unrun verbose package; no standalone passed seed rerun or timed campaign'
    mutants = 'already genuinely killed/exactly restored/green in retained slot3; never installed by this runner'
}
try {
    $manifestPath = $summary.prefixBindingManifest.path
    if ((File-Hash $manifestPath) -cne $summary.prefixBindingManifest.sha256) { throw 'Remaining binding manifest differs from the authorized source version' }
    $bindingManifest = [IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json
    [void](Run-Command '02-gofmt-write' $Gofmt @('-w', $Owned[0]) 120)
    $format = Run-Command '03-gofmt-list' $Gofmt @('-l', $Owned[0]) 120
    Require-EmptyOutput $format
    $focusedPattern = '^TestRegistrationInjectedCrashRecovery$'
    [void](Run-Command '04-crash-boundaries' $Go @('test', '-count=1', '-v', '-timeout=19m', './internal/core/agents', '-run', $focusedPattern) 1200)
    [void](Run-Command '05-agents-plain' $Go @('test', '-count=1', '-v', '-timeout=19m', './internal/core/agents') 1200)
    [void](Run-Command '06-host-vet' $Go @('vet', './internal/core/agents') 600)
    [void](Run-Command '07-host-staticcheck' $Go @('tool', 'staticcheck', './internal/core/agents') 600)
    [void](Run-Command '08-production-imports' $Go @('list', '-f', '{{join .Imports "\n"}}', './internal/core/agents') 300)
    [void](Run-Command '09-test-imports' $Go @('list', '-f', '{{join .TestImports "\n"}}', './internal/core/agents') 300)
    $tidy = Run-Command '10-module-tidy-diff' $Go @('mod', 'tidy', '-diff') 600
    Require-EmptyOutput $tidy
    [void](Run-Command '11-module-verify' $Go @('mod', 'verify') 600)

    # Compare final files to supplied S2 evidence, not a repeated S2 baseline run.
    $expectedFrozen = [IO.File]::ReadAllText($S2Frozen) | ConvertFrom-Json
    $frozenPaths = @("$Root/go.mod", "$Root/go.sum")
    $frozenPaths += @(Get-ChildItem -LiteralPath "$Root/contract/ledger/testdata/f3" -File -Recurse | Sort-Object FullName | ForEach-Object { $_.FullName })
    $actualFrozen = @($frozenPaths | ForEach-Object {
        [pscustomobject][ordered]@{ path = $_.Substring($Root.Length + 1).Replace('\', '/'); sha256 = File-Hash $_ }
    })
    $expectedFrozenText = $expectedFrozen | ConvertTo-Json -Depth 20 -Compress
    $actualFrozenText = $actualFrozen | ConvertTo-Json -Depth 20 -Compress
    $unchanged = $expectedFrozenText -ceq $actualFrozenText
    Write-Json (Join-Path $Run 'final-module-and-f3.json') $actualFrozen
    Write-Json (Join-Path $Run 'module-and-f3-comparison.json') ([ordered]@{
        suppliedS2Evidence = $S2Frozen; unchanged = $unchanged
        rule = 'Same complete module/F3 path-and-hash set; no rewrite or restoration of unrelated files'
    })
    if (-not $unchanged) { throw 'Module/F3 set differs from supplied S2 proof; report, do not restore unrelated files' }
    $bindingHashes = @($bindingManifest.finalUnchangedHelpersAndMutationTarget.PSObject.Properties | Sort-Object Name | ForEach-Object {
        $actualHash = File-Hash (Join-Path $Root $_.Name)
        [pscustomobject][ordered]@{ path = $_.Name; expectedSHA256 = $_.Value; sha256 = $actualHash; matches = $actualHash -ceq $_.Value }
    })
    $summary.finalUnchangedBindings = Join-Path $Run 'final-unchanged-binding-hashes.json'
    Write-Json $summary.finalUnchangedBindings $bindingHashes
    if (@($bindingHashes | Where-Object { -not $_.matches }).Count -ne 0) { throw 'Adopted helper or restored mutation-target binding drifted; report, do not restore unrelated source' }
    $hashes = @($Owned | ForEach-Object { [pscustomobject][ordered]@{ path = $_; sha256 = File-Hash $_ } })
    $summary.finalHashes = Join-Path $Run 'final-hashes.json'
    Write-Json $summary.finalHashes $hashes
    $summary.status = 'remaining-checks-complete'
    $runnerExit = 0
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
