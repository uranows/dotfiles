# My Dotfiles

Personal environment configurations (Linux & Windows) managed by [chezmoi](https://chezmoi.io/).

## Prerequisites

*   **Git:** Required.
*   **chezmoi:** Must be installed on the target machine.
    *   **Windows (PowerShell):**
        ```powershell
        winget install chezmoi
        ```
    *   **Linux (Debian/Ubuntu/WSL):**
        ```bash
        sudo apt update && sudo apt install chezmoi -y
        ```
    *   **Linux (Arch):**
        ```bash
        yay -S chezmoi-bin
        # or
        sudo pacman -S chezmoi
        ```

## Initial Setup

1.  **Initialize chezmoi:**
    ```bash
    chezmoi init https://github.com/uranows/dotfiles.git
    ```
    *(Alternatively, use `chezmoi init /path/to/local/clone` if you cloned manually).*\
    *(**Troubleshooting:** If `init` or subsequent commands fail unexpectedly, try clearing the chezmoi state and re-running `init`: `rm -rf ~/.config/chezmoi ~/.local/share/chezmoi`)*

2.  **First Apply:**
    ```bash
    # Automatic OS detection (recommended)
    ./apply-dotfiles.sh
    
    # Or directly with chezmoi
    chezmoi apply -v
    ```
    *   Installs packages via appropriate package manager (`apt`, `pacman`, `winget`).
    *   **Windows:** May require running from PowerShell **as Administrator**.

3.  **Configure Mappings (Important!):**
    *   The first `apply` creates `~/.config/chezmoi/chezmoi.toml`.
    *   Edit this file (`chezmoi edit ~/.config/chezmoi/chezmoi.toml`) to ensure paths for `apps/` directory files (Windows Terminal, PowerShell profile) are correct, especially on Windows. The template includes examples.
    *   Rerun `./apply-dotfiles.sh` if mappings were adjusted.

## Common Commands

*   `./apply-dotfiles.sh`: Apply with automatic OS detection and helpful output.
*   `chezmoi apply -v`: Apply changes from source to target.
*   `chezmoi update -v`: Pull latest changes from Git remote and apply.
*   `chezmoi edit <target_file>`: Edit a managed file (e.g., `chezmoi edit ~/.zshrc`).
*   `chezmoi add <target_file>`: Add a new file to be managed.

## OS-Specific Configuration

This repository supports multiple operating systems with automatic detection:

### Supported OS
- **Windows**: PowerShell, Windows Terminal, winget packages
- **Generic Linux**: Debian, Ubuntu, Mint, Pop!_OS, and other apt-based distributions (fallback)
- **Arch Linux**: pacman packages, specific Arch optimizations

### File Structure
```
scripts/
├── install-packages.windows.ps1      # Windows package installation
├── install-packages.linux-generic.sh # Generic Linux (Debian/Ubuntu/etc)
└── install-packages.linux-arch.sh    # Arch Linux package installation

packages/
├── winget-packages.windows.txt       # Windows package list
├── apt-packages.linux-generic.txt    # Generic Linux package list
└── pacman-packages.linux-arch.txt    # Arch Linux package list
```

### OS Detection Logic
Chezmoi automatically detects your system and selects the appropriate configuration:

1. **Windows**: Uses PowerShell and winget
2. **Arch Linux**: Detects `/etc/arch-release` and uses pacman
3. **Generic Linux**: Everything else uses apt-based package management (Debian, Ubuntu, Mint, etc.)

### Manual Override (Advanced)
If you need to override the OS detection for testing or debugging:

```bash
# Force specific OS configuration
CHEZMOI_OS=windows chezmoi apply -v
CHEZMOI_OS=linux chezmoi apply -v
```

## Repository Structure Overview

*   **`home/`**: Maps directly to user's home (`~`). Uses `dot_` prefix for hidden files.
*   **`apps/`**: Configs needing explicit path mapping in `chezmoi.toml` (e.g., Windows Terminal, PowerShell profile).
*   **`packages/`**: OS-specific package lists for different package managers.
*   **`scripts/`**: OS-specific installation scripts run by `apply`.
*   **`apply-dotfiles.sh`**: Convenient wrapper script with OS detection info.
*   **`.chezmoiignore`**: Files/patterns ignored by chezmoi.
*   **`README.md`**: This file.
