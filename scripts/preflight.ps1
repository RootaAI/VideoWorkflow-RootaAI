[CmdletBinding()]
param(
    [string]$OpenMontagePath,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

function Get-CommandCheck {
    param([Parameter(Mandatory = $true)][string]$Name)

    $command = Get-Command $Name -ErrorAction SilentlyContinue | Select-Object -First 1
    [ordered]@{
        found = $null -ne $command
        path = if ($command) { $command.Source } else { $null }
    }
}

function Find-OpenMontageRoot {
    param([string]$RequestedPath)

    $candidates = @(
        $RequestedPath,
        $env:OPENMONTAGE_HOME,
        (Join-Path (Split-Path -Parent $PSScriptRoot) 'OpenMontage'),
        (Join-Path $env:USERPROFILE 'OpenMontage'),
        (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'OpenMontage'),
        'C:\OpenMontage'
    ) | Where-Object { $_ } | Select-Object -Unique

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath (Join-Path $candidate 'AGENT_GUIDE.md') -PathType Leaf) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }
    return $null
}

$checks = [ordered]@{
    powershell = [ordered]@{ found = $true; version = $PSVersionTable.PSVersion.ToString() }
    git = Get-CommandCheck 'git'
    python = Get-CommandCheck 'python'
    node = Get-CommandCheck 'node'
    npm = Get-CommandCheck 'npm'
    ffmpeg = Get-CommandCheck 'ffmpeg'
    ffprobe = Get-CommandCheck 'ffprobe'
}

$root = Find-OpenMontageRoot $OpenMontagePath
$venvPython = if ($root) { Join-Path $root '.venv\Scripts\python.exe' } else { $null }
$checks.openmontage = [ordered]@{
    found = $null -ne $root
    path = $root
    agent_guide = if ($root) { Test-Path -LiteralPath (Join-Path $root 'AGENT_GUIDE.md') -PathType Leaf } else { $false }
    pipeline_defs = if ($root) { Test-Path -LiteralPath (Join-Path $root 'pipeline_defs') -PathType Container } else { $false }
    venv_python = if ($venvPython) { Test-Path -LiteralPath $venvPython -PathType Leaf } else { $false }
}

$summary = $null
$registryError = $null
if ($checks.openmontage.found -and $checks.openmontage.venv_python) {
    $previousUtf8 = $env:PYTHONUTF8
    $env:PYTHONUTF8 = '1'
    $pythonCode = "from tools.tool_registry import registry; import json; registry.discover(); print(json.dumps(registry.provider_menu_summary(), ensure_ascii=False))"
    Push-Location -LiteralPath $root
    try {
        $rawLines = @(& $venvPython -c $pythonCode 2>&1 | ForEach-Object { $_.ToString() })
        $pythonExit = $LASTEXITCODE
        $rawText = $rawLines -join "`n"
        $jsonStart = $rawText.IndexOf('{')
        if ($pythonExit -ne 0 -or $jsonStart -lt 0) {
            throw "OpenMontage registry returned exit code $pythonExit. $rawText"
        }
        $summary = $rawText.Substring($jsonStart) | ConvertFrom-Json
    }
    catch {
        $registryError = $_.Exception.Message
    }
    finally {
        Pop-Location
        $env:PYTHONUTF8 = $previousUtf8
    }
}

$runtimes = [ordered]@{ ffmpeg = $false; remotion = $false; hyperframes = $false }
$capabilities = @()
$warnings = @()
if ($summary) {
    foreach ($name in @('ffmpeg', 'remotion', 'hyperframes')) {
        $runtimes[$name] = [bool]$summary.composition_runtimes.$name
    }
    $capabilities = @($summary.capabilities | ForEach-Object {
        [ordered]@{
            capability = $_.capability
            configured = [int]$_.configured
            total = [int]$_.total
            available_providers = @($_.available_providers)
        }
    })
    $warnings = @($summary.runtime_warnings)
}
if ($registryError) {
    $warnings += "OpenMontage registry check failed: $registryError"
}

$coreReady = $checks.openmontage.found -and $checks.openmontage.agent_guide -and
    $checks.openmontage.pipeline_defs -and $checks.openmontage.venv_python -and $null -ne $summary
$hasComposer = $runtimes.ffmpeg -or $runtimes.remotion -or $runtimes.hyperframes
$canStart = $coreReady -and $hasComposer
$allRuntimesReady = $runtimes.ffmpeg -and $runtimes.remotion -and $runtimes.hyperframes
$runtimeNotes = [ordered]@{}
foreach ($name in @('ffmpeg', 'remotion', 'hyperframes')) {
    if ($runtimes[$name]) {
        $runtimeNotes[$name] = 'Available according to the OpenMontage registry.'
        continue
    }
    $matchingWarning = $warnings | Where-Object { $_ -match "^${name}:" } | Select-Object -First 1
    $runtimeNotes[$name] = if ($matchingWarning) {
        "Not confirmed available. The registry check may reflect installation, package resolution, or network state: $matchingWarning"
    } else {
        'Not reported available by the OpenMontage registry.'
    }
}

$status = if (-not $canStart) {
    'blocked'
} elseif ($allRuntimesReady -and $warnings.Count -eq 0) {
    'ready'
} else {
    'ready_with_limits'
}

$result = [ordered]@{
    schema_version = 1
    checked_at = (Get-Date).ToString('o')
    status = $status
    can_start = $canStart
    checks = $checks
    composition_runtimes = $runtimes
    runtime_notes = $runtimeNotes
    capabilities = $capabilities
    warnings = $warnings
    next_action = if ($canStart) {
        'Ask the user what video they want to make and begin the guided brief.'
    } else {
        'Explain only the blocking checks and ask before installing or changing anything.'
    }
}

if ($Json) {
    $result | ConvertTo-Json -Depth 8
} else {
    Write-Output "状态：$status"
    if ($canStart) {
        Write-Output '核心环境已就绪，可以直接开始视频工作流。'
    } else {
        Write-Output '核心环境尚未就绪，请先处理阻塞项。'
    }
    Write-Output "合成能力：FFmpeg=$($runtimes.ffmpeg)，Remotion=$($runtimes.remotion)，HyperFrames=$($runtimes.hyperframes)"
    foreach ($warning in $warnings) { Write-Warning $warning }
}

if (-not $canStart) { exit 2 }
