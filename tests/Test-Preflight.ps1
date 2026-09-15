param(
    [Parameter(Mandatory = $true)]
    [string]$OpenMontagePath
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$scriptPath = Join-Path $repoRoot 'scripts\preflight.ps1'

if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) {
    throw "Missing preflight script: $scriptPath"
}

$json = & $scriptPath -OpenMontagePath $OpenMontagePath -Json
if ($LASTEXITCODE -ne 0) {
    throw "Preflight exited with code $LASTEXITCODE"
}

$result = $json | ConvertFrom-Json
if (-not $result.can_start) {
    throw "Expected current installed environment to be runnable. Status: $($result.status)"
}
if ($result.status -notin @('ready', 'ready_with_limits')) {
    throw "Unexpected status: $($result.status)"
}
if (-not $result.composition_runtimes.ffmpeg) {
    throw 'Expected FFmpeg composition runtime to be available.'
}
if (-not $result.checks.openmontage.found) {
    throw 'Expected OpenMontage to be found.'
}
if (-not $result.runtime_notes.hyperframes) {
    throw 'Expected an interpretation note for the optional HyperFrames runtime.'
}
$ttsCapability = $result.capabilities | Where-Object { $_.capability -eq 'tts' } | Select-Object -First 1
if ($null -eq $ttsCapability.available_providers) {
    throw 'Expected capability output to name available providers without exposing credentials.'
}

Write-Output "PASS: preflight status=$($result.status), can_start=$($result.can_start)"
