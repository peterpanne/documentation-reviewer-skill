param(
    [ValidateSet("project", "user")]
    [string]$Scope = "project",
    [string]$Ref = "",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Repository = "peterpanne/documentation-reviewer-skill"
$SkillName = "reviewing-developer-documentation"
$MinimumGhVersion = [version]"2.99.0"
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

$GhVersionLine = (& gh version | Select-Object -First 1)
if ($GhVersionLine -notmatch '^gh version ([0-9]+\.[0-9]+\.[0-9]+)') {
    throw "Could not determine the installed GitHub CLI version. Run 'gh version' and ensure GitHub CLI $MinimumGhVersion or newer is installed."
}

$GhVersion = [version]$Matches[1]
if ($GhVersion -lt $MinimumGhVersion) {
    throw "GitHub CLI $MinimumGhVersion or newer is required for 'gh skill list'. Found: $GhVersion. Upgrade GitHub CLI and retry."
}

$Entry = & gh skill list `
    --agent claude-code `
    --scope $Scope `
    --json skillName,path,version,sourceURL `
    --jq ".[] | select(.skillName == `"$SkillName`") | [.path, .version, .sourceURL] | @tsv" |
    Select-Object -First 1

if (-not $Entry) {
    throw "Could not find '$SkillName' in Claude Code $Scope scope. Install it first with: gh skill install $Repository $SkillName --agent claude-code --scope $Scope"
}

$Fields = $Entry -split "`t", 3
$SkillDir = $Fields[0]
$ListedVersion = if ($Fields.Count -gt 1) { $Fields[1] } else { "" }
$SourceUrl = if ($Fields.Count -gt 2) { $Fields[2] } else { "" }

if (-not $SkillDir -or $SkillDir -eq "null") {
    throw "gh skill list did not return an installed path for '$SkillName'."
}

$SkillDir = (Resolve-Path $SkillDir).Path
$SkillsRoot = Split-Path -Parent $SkillDir
$ClaudeRoot = Split-Path -Parent $SkillsRoot
$TargetDir = Join-Path $ClaudeRoot "agents"

if (-not $Ref) {
    $Ref = $ListedVersion
}
if (-not $Ref -or $Ref -eq "null") {
    throw "gh skill list did not report a version. Pass -Ref <tag-or-commit>."
}

if ($SourceUrl -and $SourceUrl -ne "null" -and $SourceUrl.StartsWith("https://github.com/")) {
    $SourceRepo = $SourceUrl.Substring("https://github.com/".Length).TrimEnd("/")
    if ($SourceRepo.EndsWith(".git")) {
        $SourceRepo = $SourceRepo.Substring(0, $SourceRepo.Length - 4)
    }
    if ($SourceRepo -match "^[^/]+/[^/]+$") {
        $Repository = $SourceRepo
    }
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
Write-Host "Resolved by gh skill list:"
Write-Host "  skill:  $SkillDir"
Write-Host "  scope:  $Scope"
Write-Host "  source: $Repository@$Ref"
Write-Host "  gh:     $GhVersion"
Write-Host ""
Write-Host "Agents:"
$Agents | ForEach-Object { Write-Host "  - $_" }
Write-Host ""
Write-Host "Restart Claude Code or open /agents if the new agents are not visible immediately."
