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
# Source-bound to primary's cumulative 8a17 prefix, including final helpers
# and the repaired BodyRefs codec. Source readiness is NOT a native grant:
# PM review, both temporary product permissions and a fresh primary slot
# remain prerequisites. ExpectedSubject must match; no automatic retarget.
$ReviewedSubject = '8a17ec1ed2617ca2a4e5203479f75f363b359970'
$PlanPath = Join-Path $Evidence 'final-commands.json'
$PlanHash = '55d09cbb87e3804f318b0508445551760de6daf0bdbb463b422f7b26a94788d4'
$SourceHashes = [ordered]@{
    'go.mod' = '817ae18bd8be5c150e0a71bb18bc577f4ab4bab6a3e0be0befe1c45091aa3bc6'
    'go.sum' = '8f5c60cb264ddc6838335d517678723a6c1af0e97568d7c1bd6510971500b18b'
    'contract/ledger/testdata/f3/10/log/00000000000000000001.jsonl' = '9622b72877ed546a18fcbfd28a19807e0bab237909e23ffe76e7c3da1c260ecd'
    'contract/ledger/testdata/f3/11/bodies/3b916c5875daabd31fe60ddb30be34acada65bf680bdd173183d56c204eb8f00' = '3b916c5875daabd31fe60ddb30be34acada65bf680bdd173183d56c204eb8f00'
    'contract/ledger/testdata/f3/11/bodies/3c6956d1a5353c50842e3a9bf22dfefeb6d7afe49e4f606f92aa58a85556a2cf' = '3c6956d1a5353c50842e3a9bf22dfefeb6d7afe49e4f606f92aa58a85556a2cf'
    'contract/ledger/testdata/f3/11/bodies/8ed03435e57f91ee4ee0ea15e9cdd96b6750e173159fd970cdcd9fff228608a0' = '8ed03435e57f91ee4ee0ea15e9cdd96b6750e173159fd970cdcd9fff228608a0'
    'contract/ledger/testdata/f3/11/log/00000000000000000001.jsonl' = '145bb11c2b1c58e9e8530a98e6972b35329e4adb9dfb945a9f15381ae221bba6'
    'contract/ledger/testdata/f3/11/objects/7bc39933cb0f99ee55f646057761d8203a8903c53ed90f9c1660fed4111a7d89' = '7bc39933cb0f99ee55f646057761d8203a8903c53ed90f9c1660fed4111a7d89'
    'contract/ledger/testdata/f3/11/objects/a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b' = 'a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b'
    'contract/ledger/testdata/f3/11/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    'contract/ledger/testdata/f3/12/bodies/0e24c0c870c696ccf688d9ddcf681510516ef6afb760621853af04d173291854' = '0e24c0c870c696ccf688d9ddcf681510516ef6afb760621853af04d173291854'
    'contract/ledger/testdata/f3/12/bodies/121fdcbb8286cec13a55d621ec0dda07e721079eef0cf727c49903b45dd6b2fe' = '121fdcbb8286cec13a55d621ec0dda07e721079eef0cf727c49903b45dd6b2fe'
    'contract/ledger/testdata/f3/12/bodies/dbfa7ba648c8fb9a7c5b6c3ea37563d66196d431666dddc0e390d5daa080c444' = 'dbfa7ba648c8fb9a7c5b6c3ea37563d66196d431666dddc0e390d5daa080c444'
    'contract/ledger/testdata/f3/12/log/00000000000000000001.jsonl' = '6586720b28a19f997dd0890a6dbc71d27ffdf395fd000e68b6aedbbbe0ce79f8'
    'contract/ledger/testdata/f3/12/objects/398455cfb72d36d78b6b1819bb59708371d25d2503bba258181712a2cf36ce6e' = '398455cfb72d36d78b6b1819bb59708371d25d2503bba258181712a2cf36ce6e'
    'contract/ledger/testdata/f3/12/objects/d832c9deb9d8ee1a562f9b5dda200818a05f91cc4b2802e80ce81c735ffa064e' = 'd832c9deb9d8ee1a562f9b5dda200818a05f91cc4b2802e80ce81c735ffa064e'
    'contract/ledger/testdata/f3/12/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    'contract/ledger/testdata/f3/13/bodies/91bcc3dba39a97a337829a4150acae0f0918e67eb64396aee01d1afdc951a269' = '91bcc3dba39a97a337829a4150acae0f0918e67eb64396aee01d1afdc951a269'
    'contract/ledger/testdata/f3/13/log/00000000000000000001.jsonl' = '50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff'
    'contract/ledger/testdata/f3/13/objects/a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b' = 'a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d1/core/objects/312ee20080d1e7610b94b7dbc89ceb0f42a8250738b7e572a8f297c7751a8736' = '312ee20080d1e7610b94b7dbc89ceb0f42a8250738b7e572a8f297c7751a8736'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d1/core/objects/4f3a2d40ae3df0268204f8619d566e378961bebcea0a3daaabf738b7d0001ec7' = '4f3a2d40ae3df0268204f8619d566e378961bebcea0a3daaabf738b7d0001ec7'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d1/core/objects/55706821e9f1197621c6cc08234c7ecde67ae4c8a92815f26d905cabed079cdb' = '55706821e9f1197621c6cc08234c7ecde67ae4c8a92815f26d905cabed079cdb'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d1/core/objects/a6666404b2692b6634e550aeca21a17cdb60c744bc24206d203b34db6f9ae5c8' = 'a6666404b2692b6634e550aeca21a17cdb60c744bc24206d203b34db6f9ae5c8'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d1/core/objects/abbbac539288497fbe1465c534a0287fb67dfea4085ddd33d8cdac1daa902376' = 'abbbac539288497fbe1465c534a0287fb67dfea4085ddd33d8cdac1daa902376'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/1f417fb8c14eb0ca1aa3184119a375448be6196b288966519f74f7139364fc8b' = '1f417fb8c14eb0ca1aa3184119a375448be6196b288966519f74f7139364fc8b'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/354d73188334fc9282beb07b702e2d9660fe63a4585ada9640e3fa047f05dd4f' = '354d73188334fc9282beb07b702e2d9660fe63a4585ada9640e3fa047f05dd4f'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/359a718394436350faf2b14993295f0905c2524ba00319d58777613ce7cf1bcc' = '359a718394436350faf2b14993295f0905c2524ba00319d58777613ce7cf1bcc'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/4f3a2d40ae3df0268204f8619d566e378961bebcea0a3daaabf738b7d0001ec7' = '4f3a2d40ae3df0268204f8619d566e378961bebcea0a3daaabf738b7d0001ec7'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/54ee1d1e3f68412171037aa615bacae4f862d803f4ac2004f65d07356e320e3f' = '54ee1d1e3f68412171037aa615bacae4f862d803f4ac2004f65d07356e320e3f'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/66e417355a1b4f1ddb7c6d9ce1f7bf06fec4b3a008cad59f201f0ce4cebd2e38' = '66e417355a1b4f1ddb7c6d9ce1f7bf06fec4b3a008cad59f201f0ce4cebd2e38'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/79119b5437fcaf9b9e501cd1a20aa1a269a7a276ac09b2d694f264ce85f0c885' = '79119b5437fcaf9b9e501cd1a20aa1a269a7a276ac09b2d694f264ce85f0c885'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/8cf1f92e41921d777b8cd4c541a15d7749c12131c78f9cef887a16d8e2b88bee' = '8cf1f92e41921d777b8cd4c541a15d7749c12131c78f9cef887a16d8e2b88bee'
    'contract/ledger/testdata/f3/13/objects/agents/Ada-a1/contexts/0199c000-0000-7000-8000-0000000000d2/core/objects/e9bd1e74693c754a7e368f52990882d4f82de6bd499dd8f712ae8c7df9bb8d62' = 'e9bd1e74693c754a7e368f52990882d4f82de6bd499dd8f712ae8c7df9bb8d62'
    'contract/ledger/testdata/f3/13/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    'contract/ledger/testdata/f3/139/bodies/e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5' = 'e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5'
    'contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl' = 'db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134'
    'contract/ledger/testdata/f3/139/objects/a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b' = 'a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b'
    'contract/ledger/testdata/f3/139/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    'contract/ledger/catalogue.go' = 'a2ef53d73961e882d56d59fa6a5988af56b744a3e0a35028dcba89647f697537'
    'contract/ledger/catalogue_test.go' = '8c042f0265260fed837ca1ab532113ddda4eab033c36ec0d995286ac555d939f'
    'contract/ledger/doc.go' = 'd6bf607f06e11d7c27850bc757da529d2c7d5fae64b6f907785c63ca076afb69'
    'contract/ledger/paid_compatibility_test.go' = '3e236cb3bbd2006ffae0582215c476c26e8ac492e354fd85e3f87daba812e8f7'
    'contract/ledger/registration.go' = 'e0ca1f86f681b4489f07ae75b107d0981f54bfdb1a0c50f138fd98d882db09ee'
    'contract/ledger/registration_fuzz_test.go' = '56693358dc9bad9cd1990bba6d75dcb2ac9b91acf7c7d4fd8e2343414ba6d10f'
    'contract/ledger/registration_golden_test.go' = 'f4d9b5778d2936b4ccada58e549a746dd25f6a27289624c0cd4c898f5fca8c37'
    'contract/ledger/registration_submission.go' = '3b7d3b5d03bd4b0bccf85691d2ce70979dbdf1b1dd9e21355a71559425a09f6f'
    'contract/ledger/registration_test.go' = '42185f48ec0e51721742527706a138ed5144bed8f20f2c1572835d2c66f5a48b'
    'docs/CONTRACTS.md' = 'd394ba48c0d41e25a8e8d748b8743753cb3bfd4a3cdd51a5d8b1bef18aa4bf8f'
    'docs/DESIGN-CORE-AND-LAUNCHERS.md' = '900f18b1ba75185f4b0b23fc4923f22f0994aff629950c68446821212e91db2b'
    'internal/core/agents/registration_types.go' = 'cce6073307a2b60ab6161041db52d65f4c71b7ee104d05f5e62484059ea547d3'
    'internal/core/agents/registration_commands.go' = '8845fee25ccedadf6cd68c15df29e834b2099e1229e76c992a1f906045335a7d'
    'internal/core/agents/registration_replay.go' = 'af7337423f654b621ce6a461fef78819a7a2e561ec627d6843e832b21ee0cb45'
    'internal/core/agents/registration_state.go' = '5fd211ee66aef9b73e985f4fa4fd8ff461dab8725ed3ea1c240785fd787287fa'
    'internal/core/agents/registration_query.go' = '73fdd84660648ae808182bdde4dc77de6c59aa6fd6a13a7e5789174278c324a1'
    'internal/core/agents/registration_service_test.go' = '853e2e17c113659094d02814fb9be826cd8515db39d22be2761d4e671c1c3ae4'
    'internal/core/agents/registration_replay_test.go' = 'b88f7477c1a29fda5714e00bdaf5ed281e37dcfb5730780d63c045f91e856ec7'
    'internal/core/agents/registration_fuzz_test.go' = '6108e6a47701cf8b5572222b4543702f8cec70935b274b8ac733e1ac369c9a8d'
    'internal/core/agents/service.go' = '3a9e0838135f9344ddcf083f7884b9289697a74cf0d9c56c38d3b7f102e69bec'
    'internal/core/agents/types.go' = 'b9c449c480b6c05264a966386cfdb1a23cd21702ad618d2018ae199e8dafd0b8'
    'internal/core/agents/scoped_replay.go' = '4e7b0e0f92da725d07443bf88044432de673d1e5b220d6a98d824bec67159570'
    'internal/core/agents/replay.go' = '3b81a839ad03597271b78e0eff057c2e59926036f89dc2dc7cad6579b68eae2d'
    'internal/core/agents/doc.go' = '56f58f4332cc20bfa0ccb2b7d42656599bca9e83e5dbfec88df5680c94ad810e'
    'internal/core/agents/scoped_golden_test.go' = 'f9984f743a7f5a9c9c6f9dd105447bc41e9b8227c48c3807781c30dd3bb0b82f'
    'internal/core/agents/integrity.go' = '04dec8cedf618605134256b7aa2a973c5f78f1220a397c47d7beb2c5a8906560'
    'internal/core/agents/paid_fixture_test.go' = '6479e89ecc069fa3c87fb4a30dfadd8d823f165431920855f5de5136516317e8'
    'internal/core/agents/paid_fuzz_test.go' = '6aed09c53695dc3605c61888ae7877f0998f61a68ea89eeb84b1c807585508f8'
    'internal/core/agents/paid_live.go' = 'f23effce5c73095784b1a43087a6b1ac4212e582edf4750d119dab282dc9f444'
    'internal/core/agents/paid_read.go' = '23cedad1a2838e69738d46929d25038ea29ceb27e5093bc35f80216b08b1c903'
    'internal/core/agents/paid_settlement.go' = '4a87639a07f80dc37cecf3beb5576f7e471107c613fafd42a2b92f6cbc7f1ee1'
    'internal/core/agents/paid_state.go' = '9cbdb65b4703c02cf9bf0ab7f9004641ebc5052dce2e180360c0605e0c4486a6'
    'internal/core/agents/review_execute.go' = '156e2e55f8ad84ff37eada10fd55e653fa190478dfc5aeea2cd972003c81896e'
    'internal/core/agents/review_fuzz_test.go' = 'a31d51556102f4f9ce2c76af54409a5e6abb63eaa59c12b33daed03d058769ac'
    'internal/core/agents/review_replay_test.go' = 'c95510f94cbe9c7881d441c31fdf73f4a9af52e947dccda8fad438cc1b2a2752'
    'internal/core/agents/review_state.go' = 'ed34c8b43e24aeb1f02a15f90a5cc57998e2c14021f084dffe25e9cf39b8bb10'
    'internal/core/agents/scoped_submit.go' = '4639d4f4ff6a535c955dfd40478548cfec489ed3c2254996c002bb6657b90ee0'
    'internal/core/agents/history_index.go' = '69c23b9faf4590931d2fde8ecb2385bb2a08967dfe1ace1fb8b0efff5975a73a'
    'internal/core/agents/scoped_state.go' = '2c232bb2af3f6ba6dc90d47ba503c71dad585ef8d4bdaf5c2592cc1490bb0e9e'
    'internal/core/agents/scoped_execute.go' = 'c23fb945fbe9c2a5e1535fe8a22a1954f2006b80ce492e581b03017b6a7ce86c'
    'internal/core/agents/history_index_test.go' = '375391888662220403614dda65cce81d32a7b6727327c938453da671d7633fb5'
    'internal/core/agents/scoped_receipt_test.go' = '315354fc745c3f90d904a379c60c7b9991b0ba32d9bfe67c9f8edb87817eed34'
    'internal/core/agents/recovery_test.go' = '57fb5b06fec677eb1f4c04aca4ff2e9337d5c4d3ceb20024d25eab24ca89db8c'
    'internal/core/agents/registration_crash_test.go' = 'f937f77b81699adabd7d80001e3dd0f6a58d0b692690e0ff8b3090261e3d8241'
    '_t139_smoke/main.go' = '80463d040929445e6f53811f3fb2b3d98876dee9cb0b64b1228bbc0dc66a3036'
    'internal/core/agents/registration_recovery_test.go' = 'd5cfdc0e42b4e718a85a18f3ef3b9f3f89088236ab04f19d031c6baf38abb479'
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
