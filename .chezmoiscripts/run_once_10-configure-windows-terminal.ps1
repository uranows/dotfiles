# Requires PowerShell 5.1 or higher
# This script configures Windows Terminal settings
# It only runs on Windows systems

# Ensure we're running on Windows
if (-not [Environment]::OSVersion.Platform.ToString().StartsWith("Win")) {
    Write-Error "This script is intended to run only on Windows systems."
    exit 0  # Exit gracefully on non-Windows
}

# Help documentation
<#
.SYNOPSIS
Copies the Windows Terminal settings.json from the chezmoi source directory
to the correct location under %LOCALAPPDATA%.
#>

param()

Write-Verbose "Running Windows Terminal configuration script..."

$SourceRepoPath = "{{ .chezmoi.sourceDir }}"
$SettingsSourceFile = Join-Path $SourceRepoPath "apps/windows_terminal/windows-terminal-settings.json"

# Find the Windows Terminal package directory
$PackagesDir = Join-Path $env:LOCALAPPDATA "Packages"
$TerminalPackageDir = Get-ChildItem -Path $PackagesDir -Filter "Microsoft.WindowsTerminal_*" -Directory | Select-Object -First 1

if (-not $TerminalPackageDir) {
    Write-Error "Windows Terminal package directory not found under $PackagesDir. Cannot configure settings."
    exit 1
}

$SettingsTargetDir = Join-Path $TerminalPackageDir.FullName "LocalState"
$SettingsTargetFile = Join-Path $SettingsTargetDir "settings.json"

Write-Verbose "Source: $SettingsSourceFile"
Write-Verbose "Target: $SettingsTargetFile"

# Ensure source file exists
if (-not (Test-Path $SettingsSourceFile)) {
    Write-Error "Source settings file not found: $SettingsSourceFile"
    exit 1
}

# Ensure target directory exists
if (-not (Test-Path $SettingsTargetDir)) {
    Write-Verbose "Creating target directory: $SettingsTargetDir"
    New-Item -ItemType Directory -Path $SettingsTargetDir -Force | Out-Null
}

# Backup existing file if it exists
if (Test-Path $SettingsTargetFile) {
    $BackupFile = "$($SettingsTargetFile).bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Write-Warning "Existing settings file found at $SettingsTargetFile. Backing up to $BackupFile"
    Move-Item -Path $SettingsTargetFile -Destination $BackupFile -Force
}

# Copy the new settings file
Write-Host "Copying Windows Terminal settings to $SettingsTargetFile"
try {
    Copy-Item -Path $SettingsSourceFile -Destination $SettingsTargetFile -Force -ErrorAction Stop
    Write-Host "Windows Terminal settings configured successfully."
} catch {
    Write-Error "Failed to copy settings file. Error: $_"
    # Optionally attempt to restore backup if copy failed
    if (Test-Path $BackupFile) {
        Write-Warning "Attempting to restore backup file $BackupFile"
        Move-Item -Path $BackupFile -Destination $SettingsTargetFile -Force
    }
    exit 1
}

Write-Verbose "Windows Terminal configuration script finished." 