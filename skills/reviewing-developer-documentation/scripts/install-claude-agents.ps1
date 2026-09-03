param(
    [ValidateSet("project", "user")]
    [string]$Scope = "project",

    [string]$Ref = "",

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Repository = "peterpanne/documentation-reviewer-skill"
$SkillName = "reviewing-developer-documentation"
$Agents = @(
    "technical-truth-reviewer.md",
    "developer-journey-reviewer.md",
    "docs-system-reviewer.md",
    "cognitive-load-reviewer.md",
    "risk-maintainability-reviewer.md"
)

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) is required."
}

if ($Scope -eq "project") {
    $ProjectRoot = (& git rev-parse --show-toplevel 2>$null)
    if (-not $ProjectRoot) {
        throw "Project scope requires running inside a Git repository."
    }
    $TargetDir = Join-Path $ProjectRoot ".claude/agents"
} else {
    $ClaudeHome = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME ".claude" }
    $TargetDir = Join-Path $ClaudeHome "agents"
}

if (-not $Ref) {
    $Ref = (& gh skill list `
        --agent claude-code `
        --scope $Scope `
        --json skillName,version `
        --jq ".[] | select(.skillName == `"$SkillName`") | .version" `
        | Select-Object -First 1)
}

if (-not $Ref -or $Ref -eq "null") {
    $Ref = "main"
    Write-Warning "Could not determine the installed skill version; using ref '$Ref'."
}

foreach ($Agent in $Agents) {
    $Destination = Join-Path $TargetDir $Agent
    if ((Test-Path $Destination) -and -not $Force) {
        throw "Refusing to overwrite existing agent '$Destination'. Re-run with -Force to update helper-installed agents."
    }
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("documentation-reviewer-agents-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

try {
    foreach ($Agent in $Agents) {
        $TempFile = Join-Path $TempDir $Agent
        $Content = & gh api `
            --method GET `
            "repos/$Repository/contents/agents/$Agent" `
            -f "ref=$Ref" `
            -H "Accept: application/vnd.github.raw+json"

        if ($LASTEXITCODE -ne 0) {
            throw "Failed to download agent '$Agent'."
        }

        $Text = ($Content -join "`n")
        if ($Text -notmatch "(?m)^name:") {
            throw "Downloaded agent '$Agent' does not look valid."
        }

        [System.IO.File]::WriteAllText($TempFile, $Text + "`n")
    }

    foreach ($Agent in $Agents) {
        Move-Item -Force (Join-Path $TempDir $Agent) (Join-Path $TargetDir $Agent)
    }
} finally {
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir
    }
}

Write-Host "Installed $($Agents.Count) Claude Code agents into:"
Write-Host "  $TargetDir"
Write-Host ""
Write-Host "Source:"
Write-Host "  $Repository@$Ref"
Write-Host ""
Write-Host "Agents:"
$Agents | ForEach-Object { Write-Host "  - $_" }
Write-Host ""
Write-Host "Restart Claude Code or open /agents if the new agents are not visible immediately."
