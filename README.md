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

## Initial Setup

1.  **Initialize chezmoi:**
    ```bash
    chezmoi init https://github.com/uranows/dotfiles.git
    ```
    *(Alternatively, use `chezmoi init /path/to/local/clone` if you cloned manually).*\
    *(**Troubleshooting:** If `init` or subsequent commands fail unexpectedly, try clearing the chezmoi state and re-running `init`: `rm -rf ~/.config/chezmoi ~/.local/share/chezmoi`)*

2.  **First Apply:**
    ```bash
    chezmoi apply -v
    ```
    *   Installs packages via `apt`/`cargo` (Linux/WSL) or `winget` (Windows).
    *   **Windows:** May require running from PowerShell **as Administrator**.

3.  **Configure Mappings (Important!):**
    *   The first `apply` creates `~/.config/chezmoi/chezmoi.toml`.
    *   Edit this file (`chezmoi edit ~/.config/chezmoi/chezmoi.toml`) to ensure paths for `apps/` directory files (Windows Terminal, PowerShell profile) are correct, especially on Windows. The template includes examples.
    *   Rerun `chezmoi apply -v` if mappings were adjusted.

## Common Commands

*   `chezmoi apply -v`: Apply changes from source to target.
*   `chezmoi update -v`: Pull latest changes from Git remote and apply.
*   `chezmoi edit <target_file>`: Edit a managed file (e.g., `chezmoi edit ~/.zshrc`).
*   `chezmoi add <target_file>`: Add a new file to be managed.

## Repository Structure Overview

*   **`home/`**: Maps directly to user's home (`~`). Uses `dot_` prefix for hidden files.
*   **`apps/`**: Configs needing explicit path mapping in `chezmoi.toml` (e.g., Windows Terminal, PowerShell profile).
*   **`packages/`**: Package lists for `apt`, `winget`, `cargo`.
*   **`run_*.tmpl.executable_*`**: OS-specific installation scripts run by `apply`.
*   **`.chezmoiignore`**: Files/patterns ignored by chezmoi.
*   **`README.md`**: This file. 