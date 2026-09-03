param(
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

& gh skill list --help *> $null
if ($LASTEXITCODE -ne 0) {
    throw "This helper requires a GitHub CLI version with 'gh skill list' support. Upgrade GitHub CLI and retry."
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillDir = (Resolve-Path (Join-Path $ScriptDir "..")).Path
$SkillsRoot = Split-Path -Parent $SkillDir

$Entry = & gh skill list `
    --dir $SkillsRoot `
    --json skillName,path,version,sourceURL `
    --jq ".[] | select(.skillName == `"$SkillName`") | [.path, .version, .sourceURL] | @tsv" |
    Select-Object -First 1

if (-not $Entry) {
    throw "Could not find '$SkillName' with gh skill list under '$SkillsRoot'. Run this helper from the copy installed by gh skill."
}

$Fields = $Entry -split "`t", 3
$ListedPath = $Fields[0]
$ListedVersion = if ($Fields.Count -gt 1) { $Fields[1] } else { "" }
$SourceUrl = if ($Fields.Count -gt 2) { $Fields[2] } else { "" }

if (-not $ListedPath -or $ListedPath -eq "null") {
    throw "gh skill list did not return an installed path for '$SkillName'."
}

$ListedPath = (Resolve-Path $ListedPath).Path
if ($ListedPath -ne $SkillDir) {
    throw "The running helper does not match the skill entry returned by gh skill list. Helper skill: '$SkillDir'. Listed skill: '$ListedPath'."
}

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
Write-Host "  skill:  $ListedPath"
Write-Host "  source: $Repository@$Ref"
Write-Host ""
Write-Host "Agents:"
$Agents | ForEach-Object { Write-Host "  - $_" }
Write-Host ""
Write-Host "Restart Claude Code or open /agents if the new agents are not visible immediately."
