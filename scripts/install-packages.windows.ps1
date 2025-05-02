# Requires -Version 5.1
<#
.SYNOPSIS
Installs or upgrades packages listed in winget-packages-windows.txt using winget.
#>

# Only proceed on Windows
if (-not $IsWindows) {
    Write-Verbose "Skipping Windows package installation on non-Windows host"
    exit 0
}

$SourceDir = $Env:CHEZMOI_SOURCE_DIR
$PackagesFile = Join-Path $SourceDir "packages/winget-packages-windows.txt"

if (-not (Test-Path $PackagesFile)) {
    Write-Verbose "Winget packages list not found at $PackagesFile, skipping."
    exit 0
}

# Ensure winget is available
$wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
if (-not $wingetCmd) {
    Write-Error "winget command not found."
    exit 1
}

Write-Host "Installing/upgrading Windows packages via winget from $PackagesFile"
Get-Content $PackagesFile | ForEach-Object {
    $pkg = $_.Trim()
    if ($pkg -and -not $pkg.StartsWith('#')) {
        Write-Host "Processing package: $pkg"
        $installed = winget list --id $pkg --accept-source-agreements -n 1 | Select-String -Pattern $pkg
        if ($installed) {
            Write-Host "Upgrading $pkg"
            winget upgrade --id $pkg --accept-package-agreements --accept-source-agreements --silent
        } else {
            Write-Host "Installing $pkg"
            winget install --id $pkg --accept-package-agreements --accept-source-agreements --silent
        }
    }
}
Write-Host "Windows package installation complete." 