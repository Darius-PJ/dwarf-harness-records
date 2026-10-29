[CmdletBinding()]
param([Parameter(Mandatory = $true)][string]$GrantReference)

# Source only until the PM grants the exact subject and serial sequence. This
# runner never installs mutants. Run approved red/restored-green proof first.
# Invoke the parent tool with timeout=0; each child below has a finite deadline.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Root = 'C:/Users/darius.jones/worktrees/dwarf-harness/139-acceptance'
$Evidence = 'C:/Users/darius.jones/worktrees/dwarf-harness/t139-s3-evidence'
$Go = 'C:/Program Files/Go/bin/go.exe'
$Gofmt = 'C:/Program Files/Go/bin/gofmt.exe'
$S2Frozen = 'C:/Users/darius.jones/worktrees/dwarf-harness/t139-s2-evidence/run-20261029T023939070Z-19044/module-and-f3-after.json'
$Smoke = "$Root/_t139_smoke/main.go"
$Owned = @(
    "$Root/internal/core/agents/registration_crash_test.go",
    "$Root/internal/core/agents/registration_recovery_test.go"
)
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$CommonEnvironment = [ordered]@{
    GOTOOLCHAIN = 'local'; GOFLAGS = ''; GOROOT = 'C:/Program Files/Go'
    GOOS = 'windows'; GOARCH = 'amd64'; CGO_ENABLED = '0'
}
$Run = Join-Path $Evidence ('run-' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ') + '-' + $PID)
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
    sourceBase = '67d9636d6c70ba8cab2810bcec81c31a6c5df914'
    startedUTC = [DateTime]::UtcNow.ToString('o'); finishedUTC = $null; exitCode = $null
    error = $null; finalHashes = $null; smoke = $null
    race = 'not run: tests-only source; no shared-state/locking production change'
    fuzz = 'ordinary seeds only; no changed production fuzzed path or timed campaign grant'
    mutants = 'not installed by this runner; PM-reviewed named red/restored-green proof is a prerequisite'
}
try {
    $smokeArchive = Join-Path $Run 'smoke-main.go'
    [IO.File]::WriteAllBytes($smokeArchive, [IO.File]::ReadAllBytes($Smoke))
    $smokeHash = File-Hash $Smoke
    if ((File-Hash $smokeArchive) -cne $smokeHash) { throw 'Smoke archive differs from its source' }
    $smokeCommand = Run-Command '01-public-service-smoke' $Go @('run', './_t139_smoke') 600
    $smokeOutput = [IO.File]::ReadAllText($smokeCommand.stdout) | ConvertFrom-Json
    if ($smokeOutput.Status -cne 'passed') { throw 'Smoke did not emit its completed public-API result' }
    [IO.File]::Delete($Smoke)
    if ([IO.File]::Exists($Smoke)) { throw 'Own throwaway smoke source was not removed' }
    $smokeDirectory = [IO.Path]::GetDirectoryName($Smoke)
    if ([IO.Directory]::GetFileSystemEntries($smokeDirectory).Length -eq 0) { [IO.Directory]::Delete($smokeDirectory) }
    $summary.smoke = [ordered]@{
        source = $Smoke; retainedSource = $smokeArchive; sha256 = $smokeHash
        command = $smokeCommand.metadata; removedAfterSuccessfulRun = $true
    }
    Write-Json (Join-Path $Run 'smoke-source-and-removal.json') $summary.smoke

    [void](Run-Command '02-gofmt-write' $Gofmt (@('-w') + $Owned) 120)
    $format = Run-Command '03-gofmt-list' $Gofmt (@('-l') + $Owned) 120
    Require-EmptyOutput $format
    $focusedPattern = '^(TestRegistrationInjectedCrashRecovery|TestRegistrationReviewHistoryRecovery|TestRegistrationPaidHistoryRecovery|FuzzRegistrationGroupReplay)$'
    [void](Run-Command '04-focused-and-seeds' $Go @('test', '-count=1', '-v', '-timeout=19m', './internal/core/agents', '-run', $focusedPattern) 1200)
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
    $hashes = @($Owned | ForEach-Object { [pscustomobject][ordered]@{ path = $_; sha256 = File-Hash $_ } })
    $summary.finalHashes = Join-Path $Run 'final-hashes.json'
    Write-Json $summary.finalHashes $hashes
    $summary.status = 'serial-checks-complete'
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
