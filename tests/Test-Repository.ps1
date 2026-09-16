$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

$required = @(
    'AGENTS.md',
    '.agents\skills\ai-video-workflow\SKILL.md',
    '.agents\skills\ai-video-workflow\references\video-types.md',
    '.agents\skills\ai-video-workflow\references\script-and-storyboard.md',
    '.agents\skills\ai-video-workflow\references\assets-and-licensing.md',
    '.agents\skills\ai-video-workflow\references\audio-format-and-qa.md',
    'README.md',
    'README.en.md',
    'CONTRIBUTING.md',
    'CODE_OF_CONDUCT.md',
    'SECURITY.md',
    'CHANGELOG.md',
    'RELEASE.md',
    'LICENSE',
    'THIRD_PARTY_NOTICES.md',
    'templates\video-project\brief.md',
    'templates\video-project\asset-license-log.csv',
    'templates\video-project\qa-checklist.md'
)

$missing = @($required | Where-Object { -not (Test-Path -LiteralPath (Join-Path $repoRoot $_) -PathType Leaf) })
if ($missing.Count -gt 0) {
    throw "Missing required files: $($missing -join ', ')"
}

$textFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -File |
    Where-Object {
        $_.Extension -in @('.md', '.ps1', '.json', '.csv', '.txt', '.yaml', '.yml') -and
        -not $_.FullName.StartsWith($PSScriptRoot, [System.StringComparison]::OrdinalIgnoreCase) -and
        -not ($_.FullName -match '\\(projects|output|\.cache|node_modules|__pycache__)\\')
    }
$forbidden = @('Roota Local Model Project', 'D:\AI Video\OpenMontage', 'James', 'DOUBAO_SPEECH_APP_ID', 'DOUBAO_SPEECH_ACCESS_TOKEN')
foreach ($file in $textFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    foreach ($term in $forbidden) {
        if ($content -match [regex]::Escape($term)) {
            throw "Private or branded term '$term' found in $($file.FullName)"
        }
    }
}

$skill = Get-Content -LiteralPath (Join-Path $repoRoot '.agents\skills\ai-video-workflow\SKILL.md') -Raw
foreach ($requiredPhrase in @('preflight.ps1', 'ready_with_limits', 'OpenMontage', 'explicit approval')) {
    if ($skill -notmatch [regex]::Escape($requiredPhrase)) {
        throw "Workflow skill is missing required contract: $requiredPhrase"
    }
}

$readme = Get-Content -LiteralPath (Join-Path $repoRoot 'README.md') -Raw
foreach ($requiredPhrase in @('RootaAI', '不是 OpenMontage 安装教程', '自行准备', '和 Codex 对话')) {
    if ($readme -notmatch [regex]::Escape($requiredPhrase)) {
        throw "Public README is missing required positioning phrase: $requiredPhrase"
    }
}

Write-Output "PASS: repository structure and neutral-content checks passed ($($textFiles.Count) text files scanned)"
