# Requires PowerShell 5.1 or higher
# Requires elevated privileges
# This script installs packages on Windows systems using winget

# Help documentation
<#
.SYNOPSIS
Installs packages listed in winget-packages-windows.txt using winget.
#>

# Ensure we're running on Windows
if (-not [Environment]::OSVersion.Platform.ToString().StartsWith("Win")) {
    Write-Error "This script is intended to run only on Windows systems."
    exit 0  # Exit gracefully on non-Windows
}

# No parameters needed for this script
# param() can be problematic in some PowerShell environments when empty

Write-Verbose "Running Windows package installation script..."

# Get the directory of the chezmoi source state
$SourceDir = "{{ .chezmoi.sourceDir }}"
$WingetPackagesFile = Join-Path $SourceDir "packages/winget-packages-windows.txt"

# Check if winget command exists
$wingetPath = Get-Command winget -ErrorAction SilentlyContinue
if (-not $wingetPath) {
    Write-Error "winget command not found. Please install App Installer from the Microsoft Store."
    exit 1 # Indicate failure
}

# Install packages from winget-packages.txt
if (Test-Path $WingetPackagesFile) {
    Write-Host "Installing/Updating packages using winget from $WingetPackagesFile..."
    Get-Content $WingetPackagesFile | ForEach-Object {
        $PackageId = $_.Trim()
        if ($PackageId -and $PackageId -notmatch '^#') { # Also ignore lines starting with #
            Write-Host "Processing package: $PackageId..."
            # Check if package is installed
            $installedPackage = winget list --id $PackageId --accept-source-agreements -n 1 | Select-String -Pattern $PackageId

            if ($installedPackage) {
                Write-Host "Package '$PackageId' is already installed. Attempting upgrade..."
                winget upgrade --id $PackageId --accept-package-agreements --accept-source-agreements --silent
                if ($LASTEXITCODE -ne 0) {
                    Write-Warning "Failed to upgrade $PackageId (Exit code: $LASTEXITCODE). It might be up-to-date or an error occurred."
                }
            } else {
                Write-Host "Installing $PackageId..."
                winget install --id $PackageId --accept-package-agreements --accept-source-agreements --silent
                if ($LASTEXITCODE -ne 0) {
                    Write-Error "Failed to install $PackageId (Exit code: $LASTEXITCODE)"
                    # Optionally, decide if you want to stop the script on failure
                    # exit 1
                }
            }
        }
    }
} else {
    Write-Warning "Winget package list not found at $WingetPackagesFile. Skipping package installation."
}

Write-Host "Windows package installation script finished." 