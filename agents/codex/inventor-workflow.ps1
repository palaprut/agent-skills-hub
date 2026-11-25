[CmdletBinding(DefaultParameterSetName = 'Start')]
param(
    [Parameter(Mandatory, ParameterSetName = 'Start')]
    [switch] $Start,

    [Parameter(Mandatory, ParameterSetName = 'Verify')]
    [switch] $Verify,

    [Parameter(Mandatory)]
    [string] $StatePath,

    [Parameter(Mandatory, ParameterSetName = 'Start')]
    [string] $Destination,

    [Parameter(Mandatory, ParameterSetName = 'Start')]
    [string[]] $ExpectedFiles,

    [Parameter(ParameterSetName = 'Start')]
    [string] $Prompt,

    [Parameter(ParameterSetName = 'Start')]
    [string] $DirectReason,

    [Parameter(ParameterSetName = 'Verify')]
    [string] $FallbackReason
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-OutputSnapshot([string] $Folder) {
    Get-ChildItem -LiteralPath $Folder -File -Force | ForEach-Object {
        [pscustomobject]@{
            Name = $_.Name
            Length = $_.Length
            ModifiedUtc = $_.LastWriteTimeUtc.Ticks
        }
    }
}

if ($Start) {
    if ([bool]$Prompt -eq [bool]$DirectReason) {
        throw 'Provide a Copilot prompt or an explicit user instruction to work directly.'
    }
    if (Test-Path -LiteralPath $StatePath) {
        throw 'Use a fresh state path for each attempt.'
    }
    $folder = Get-Item -LiteralPath $Destination
    if (-not $folder.PSIsContainer) {
        throw 'Destination must be an existing output directory.'
    }
    if (@($ExpectedFiles | Where-Object { $_ -ne [IO.Path]::GetFileName($_) -or $_ -in '.', '..', '' }).Count) {
        throw 'ExpectedFiles must be filenames in the destination directory.'
    }
    $stateFile = [IO.Path]::GetFullPath($StatePath)
    $outputLog = "$stateFile.copilot.log"
    $inOutputFolder = [IO.Path]::GetRelativePath($folder.FullName, $stateFile)
    if ($inOutputFolder -ne '..' -and -not $inOutputFolder.StartsWith('..\') -and
        -not [IO.Path]::IsPathRooted($inOutputFolder)) {
        throw 'Keep the state and Copilot transcript outside the destination.'
    }

    $before = @(Get-OutputSnapshot $folder.FullName)
    $route = 'DirectRequested'
    $code = $null
    if ($Prompt) {
        $command = Get-Command copilot -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        $route = 'CopilotUnavailable'
        if ($command) {
            # Copilot returns proposed code. The Inventor agent is the sole CAD writer.
            $route = 'CopilotFailed'
            $promptText = "Return the proposed code and verification steps in your response. Do not use tools or modify any files. $Prompt"
            try {
                $output = & $command.Source --no-auto-update --no-custom-instructions --silent --available-tools=none --prompt $promptText 2>&1
                $code = $LASTEXITCODE
                $output | Out-String | Set-Content -LiteralPath $outputLog -Encoding utf8
                if ($code -eq 0 -and -not [string]::IsNullOrWhiteSpace(($output | Out-String))) {
                    $route = 'CopilotResponded'
                }
            } catch {
                $_.Exception.Message | Set-Content -LiteralPath $outputLog -Encoding utf8
            }
        } else {
            'GitHub Copilot CLI executable was not found on PATH.' | Set-Content -LiteralPath $outputLog
        }
    }

    [pscustomobject]@{
        Destination = $folder.FullName
        ExpectedFiles = @($ExpectedFiles)
        Before = @($before)
        Route = $route
        CopilotExitCode = $code
        CopilotLog = if ($Prompt) { $outputLog } else { $null }
        DirectReason = $DirectReason
    } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $stateFile -Encoding utf8
    Get-Content -LiteralPath $stateFile -Raw | ConvertFrom-Json |
        Select-Object Route, CopilotExitCode, CopilotLog
    return
}

$state = Get-Content -LiteralPath $StatePath -Raw | ConvertFrom-Json
switch ($state.Route) {
    'DirectRequested' {
        if ([string]::IsNullOrWhiteSpace($state.DirectReason)) { throw 'Missing direct-work instruction.' }
    }
    'CopilotResponded' {
        if (-not (Test-Path -LiteralPath $state.CopilotLog -PathType Leaf)) { throw 'Missing Copilot transcript.' }
    }
    { $_ -in 'CopilotFailed', 'CopilotUnavailable' } {
        if (-not (Test-Path -LiteralPath $state.CopilotLog -PathType Leaf)) { throw 'Missing Copilot blocker log.' }
        if ([string]::IsNullOrWhiteSpace($FallbackReason)) { throw 'Record the specific Copilot blocker with -FallbackReason.' }
    }
    default { throw "Unknown implementation route: $($state.Route)" }
}

$beforeByName = @{}
foreach ($file in $state.Before) { $beforeByName[$file.Name] = $file }
$after = @(Get-OutputSnapshot $state.Destination)
$missing = @($state.ExpectedFiles | Where-Object { $_ -notin @($after | Where-Object Length -gt 0 | ForEach-Object Name) })
$unexpected = @($after | Where-Object {
    $_.Name -notin $state.ExpectedFiles -and
        (-not $beforeByName.ContainsKey($_.Name) -or
        $_.Length -ne $beforeByName[$_.Name].Length -or
        $_.ModifiedUtc -ne $beforeByName[$_.Name].ModifiedUtc)
} | ForEach-Object Name)

if ($missing.Count -or $unexpected.Count) {
    throw "Output check failed. Missing or empty: $($missing -join ', '). Unexpected additions or changes: $($unexpected -join ', ')."
}
[pscustomobject]@{ Route = $state.Route; Files = $state.ExpectedFiles -join ', '; FallbackReason = $FallbackReason }
