[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$GrantReference,[Parameter(Mandatory=$true)][string]$PlanPath)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Root = 'C:/Users/darius.jones/worktrees/dwarf-harness/140-final-ack'
$Evidence = 'C:/Users/darius.jones/worktrees/dwarf-harness/t140-s5-reader-evidence'
$Go = 'C:/Program Files/Go/bin/go.exe'
$Gofmt = 'C:/Program Files/Go/bin/gofmt.exe'
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$CommonEnvironment = [ordered]@{ GOTOOLCHAIN='local'; GOFLAGS=''; GOROOT='C:/Program Files/Go'; GOOS='windows'; GOARCH='amd64'; CGO_ENABLED='0' }
$Plan = [IO.File]::ReadAllText($PlanPath) | ConvertFrom-Json
$Run = Join-Path $Evidence ($Plan.stage + '-' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ') + '-' + $PID)
[void][IO.Directory]::CreateDirectory($Run)
$CommandRecords = New-Object 'System.Collections.Generic.List[object]'
$Owned = @('contract/ledger/reader.go','contract/ledger/scan.go','contract/ledger/doc.go','contract/ledger/reader_test.go','contract/ledger/fuzz_test.go')
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

function Source-Manifest {
    $m = [ordered]@{}
    foreach ($p in $script:Owned) { $full = Join-Path $script:Root $p; $m[$p] = [ordered]@{ sha256=(File-Hash $full); bytes=(Get-Item -LiteralPath $full).Length } }
    return $m
}
$runnerExit=1
$summary=[ordered]@{status='started';grantReference=$GrantReference;stage=$Plan.stage;plan=$PlanPath;planSHA256=(File-Hash $PlanPath);cwd=$Root;sourceBase='84d0ced9446168777c7b7bfa3382974977bf27ed';ownerAuthority='D156/b63d618c76b864ec08855bd78eadcf3e27cf7588';startedUTC=[DateTime]::UtcNow.ToString('o');finishedUTC=$null;exitCode=$null;error=$null;sourceBefore=(Source-Manifest);sourceAfter=$null;expectedExitsObserved=$false;semanticMutationJudgment='Parentreadsactualnamedassertion;expectednonzeroaloneisNOTsemanticred';C3Released=$false}
Write-Json (Join-Path $Run 'source-before.json') $summary.sourceBefore
Write-Json (Join-Path $Run 'plan.json') $Plan
Write-Json (Join-Path $Evidence 'latest-run.json') ([ordered]@{run=$Run;stage=$Plan.stage;grantReference=$GrantReference})
try {
    foreach ($step in $Plan.commands) {
        switch ($step.executable) { 'go' {$exe=$Go} 'gofmt' {$exe=$Gofmt} default {throw 'Unknown executable; no arbitrary shell command allowed'} }
        $result=$null
        try { $result=Run-Command $step.name $exe @($step.argv | ForEach-Object {[string]$_}) ([int]$step.timeoutSeconds) }
        catch {
            if ([int]$step.expectedExit -eq 0 -or $CommandRecords.Count -eq 0) { throw }
            $last=$CommandRecords[$CommandRecords.Count-1]
            if ($last.name -cne $step.name -or $last.exitCode -ne [int]$step.expectedExit -or $last.timedOut -or -not $last.reaped -or -not $last.streamsComplete) { throw }
            $result=$last
        }
        if ($result.exitCode -ne [int]$step.expectedExit) { throw "Unexpected exit for $($step.name): $($result.exitCode), expected $($step.expectedExit); no automatic retry" }
        if ([bool]$step.requireEmptyOutput) { Require-EmptyOutput $result }
    }
    $summary.expectedExitsObserved=$true
    $summary.status='complete-expected-exits-observed'
    $runnerExit=0
} catch { $summary.status='stopped';$summary.error=$_.Exception.ToString();Write-Host $summary.error }
finally { $summary.sourceAfter=Source-Manifest;Write-Json (Join-Path $Run 'source-after.json') $summary.sourceAfter;$summary.finishedUTC=[DateTime]::UtcNow.ToString('o');$summary.exitCode=$runnerExit;Write-Json (Join-Path $Run 'summary.json') $summary;Write-Host ('T140_C1_EVIDENCE_RUN=' + $Run);Write-Host ('T140_C1_RUNNER_EXIT=' + $runnerExit) }
exit $runnerExit
