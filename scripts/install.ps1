<#
.SYNOPSIS
    Downloads and installs the Dokfx template to a specified or latest version from GitHub.
.DESCRIPTION
    This script queries the GitHub API for releases of KryKomDev/Dokfx,
    downloads the 'dokfx-template.zip' asset (or falls back to the source zipball),
    creates a backup of the existing template directory, clears it, and extracts the new files.
.PARAMETER Dir
    The destination path where the Dokfx template files will be installed. Default is "./Docs/templates/dokfx".
.PARAMETER Tag
    The specific release tag to download (e.g., "v1.0.0"). Default is "latest".
.PARAMETER SkipBackup
    If specified, the backup step of the existing template directory will be skipped.
.PARAMETER Force
    Overwrites files without prompting if conflicts occur.
.EXAMPLE
    .\install.ps1 -Tag "v1.1.0" -Dir "C:\MyDocs\templates\dokfx"
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [string]$Dir = "./docs/templates/dokfx",

    [Parameter()]
    [string]$Tag = "latest",

    [Parameter()]
    [switch]$SkipBackup,

    [Parameter()]
    [switch]$Force,

    [Parameter()]
    [Alias('h')]
    [switch]$Help
)

function Install-Dokfx {
    <#
    .SYNOPSIS
        Downloads and installs the Dokfx template to a specified or latest version from GitHub.
    .DESCRIPTION
        This function queries the GitHub API for releases of KryKomDev/Dokfx,
        downloads the 'dokfx-template.zip' asset (or falls back to the source zipball),
        creates a backup of the existing template directory, clears it, and extracts the new files.
    .PARAMETER Dir
        The destination path where the Dokfx template files will be installed. Default is "./docs/templates/dokfx".
    .PARAMETER Tag
        The specific release tag to download (e.g., "v1.0.0"). Default is "latest".
    .PARAMETER SkipBackup
        If specified, the backup step of the existing template directory will be skipped.
    .PARAMETER Force
        Overwrites files without prompting if conflicts occur.
    .EXAMPLE
        Install-Dokfx -Tag "v1.1.0" -Dir "C:\MyDocs\templates\dokfx"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$Dir = "./docs/templates/dokfx",

        [Parameter()]
        [string]$Tag = "latest",

        [Parameter()]
        [switch]$SkipBackup,

        [Parameter()]
        [switch]$Force,

        [Parameter()]
        [Alias('h')]
        [switch]$Help
    )

    $ErrorActionPreference = "Stop"

    $Repository = "KryKomDev/Dokfx"

    if ($Help) {
        Write-Host "Usage:"
        Write-Host "  Install-Dokfx [[-Dir] <String>] [-Tag <String>] [-SkipBackup] [-Force] [-Help]"
        Write-Host ""
        Write-Host "Options:"
        Write-Host "  -Dir         The destination path where template files will be installed."
        Write-Host "               Default: './docs/templates/dokfx'"
        Write-Host "  -Tag         A specific release tag to download (e.g. 'v1.1.0')."
        Write-Host "               Default: 'latest'"
        Write-Host "  -SkipBackup  If specified, skips creating a backup of existing template files."
        Write-Host "  -Force       Overwrites target files without prompt warnings."
        Write-Host "  -Help        Shows this help message."
        Write-Host ""
        return
    }

    # Force TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Resolve target template directory absolutely
    if ([System.IO.Path]::IsPathRooted($Dir)) {
        $TargetDir = $Dir
    } else {
        $RootPath = if ([string]::IsNullOrEmpty($PSScriptRoot)) { $PWD.Path } else { $PSScriptRoot }
        $TargetDir = [System.IO.Path]::GetFullPath((Join-Path $RootPath $Dir))
    }

    # Determine API URL based on latest vs specific tag
    if ($Tag -eq "latest") {
        $ApiUrl = "https://api.github.com/repos/$Repository/releases/latest"
    } else {
        $ApiUrl = "https://api.github.com/repos/$Repository/releases/tags/$Tag"
    }

    try {
        $Release = Invoke-RestMethod -Uri $ApiUrl -Headers @{ "User-Agent" = "PowerShell" }
    } catch {
        throw "Failed to fetch release info from GitHub API: $_"
    }

    $TagName = $Release.tag_name
    if (-not $TagName) {
        throw "Release tag could not be resolved from API response."
    }

    # Find the dokfx-template.zip asset
    $Asset = $Release.assets | Where-Object { $_.name -eq "dokfx-template.zip" } | Select-Object -First 1

    if ($Asset) {
        $DownloadUrl = $Asset.browser_download_url
    } else {
        Write-Warning "Could not find 'dokfx-template.zip' in release assets. Falling back to source code zipball..."
        $DownloadUrl = $Release.zipball_url
    }

    # Create backup of old files before deleting if requested and directory exists
    if (Test-Path $TargetDir) {
        $HasFiles = (Get-ChildItem -Path $TargetDir -File -Recurse -ErrorAction SilentlyContinue) -ne $null
        if ($HasFiles -and -not $SkipBackup) {
            $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
            $BackupFile = "dokfx-backup-$Timestamp.zip"
            $BackupParent = Split-Path $TargetDir
            $BackupPath = Join-Path $BackupParent $BackupFile

            try {
                Compress-Archive -Path "$TargetDir\*" -DestinationPath $BackupPath -Force
            } catch {
                Write-Warning "Backup compression failed: $_. Proceeding with update anyway..."
            }
        }
    }

    # Download to a temporary location
    $TempZip = Join-Path ([System.IO.Path]::GetTempPath()) ("dokfx-template-" + [Guid]::NewGuid().ToString() + ".zip")

    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempZip -UseBasicParsing
    } catch {
        throw "Failed to download template: $_"
    }

    # Ensure destination directory exists and is empty
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    } else {
        Remove-Item -Path "$TargetDir\*" -Recurse -Force
    }

    # Temporary extraction directory
    $TempExtractDir = Join-Path ([System.IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $TempExtractDir -Force | Out-Null

    try {
        Expand-Archive -Path $TempZip -DestinationPath $TempExtractDir -Force

        # Handle wrapper folder structure (e.g., in source code zipballs)
        $RootItems = Get-ChildItem -Path $TempExtractDir
        $SourceDir = $TempExtractDir

        if ($RootItems.Count -eq 1 -and $RootItems[0].PSIsContainer -and $RootItems[0].Name -notIn "partials", "public") {
            $SourceDir = $RootItems[0].FullName
        }

        # Copy extracted template files to the target templates directory
        Get-ChildItem -Path "$SourceDir\*" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $TargetDir -Recurse -Force
        }

        Write-Host "Success! Dokfx template updated to version $TagName!"
    } catch {
        throw "Failed to extract or install template files: $_"
    } finally {
        # Clean up temp files
        if (Test-Path $TempZip) {
            Remove-Item -Path $TempZip -Force
        }
        if (Test-Path $TempExtractDir) {
            Remove-Item -Path $TempExtractDir -Recurse -Force
        }
    }
}

if ($MyInvocation.InvocationName -ne '.' -and $MyInvocation.InvocationName -ne '') {
    try {
        Install-Dokfx @PSBoundParameters
    } catch {
        Write-Error $_
        exit 1
    }
}
