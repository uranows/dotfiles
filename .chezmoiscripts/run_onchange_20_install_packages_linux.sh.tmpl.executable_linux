#!/bin/bash
# This script installs packages on Linux systems
# It uses the packages list from the packages directory

# Ensure we're running on a Linux/Unix system
if [[ "$(uname)" != "Linux" && "$(uname)" != "Darwin" ]]; then
    echo "This script is intended to run only on Linux/Unix systems."
    exit 0  # Exit gracefully on non-Linux
fi

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.
set -o pipefail # Causes pipelines to fail on the first command error.

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages using apt
install_apt_packages() {
    local packages_file="{{ .chezmoi.sourceDir }}/packages/apt-packages-linux.txt"
    if [ ! -f "$packages_file" ]; then
        echo "Error: APT package list file not found: $packages_file" >&2
        return 1
    fi

    echo "Updating apt package lists..."
    sudo apt-get update

    echo "Installing packages from $packages_file..."
    # Read packages, filter comments/empty lines, pass to apt-get
    grep -vE "^#|^$" "$packages_file" | xargs sudo apt-get install -y
}

# Function to install packages using cargo
install_cargo_packages() {
    local cargo_packages=("zoxide --locked" "gitui" "du-dust")

    if ! command_exists cargo; then
        echo "Cargo not found. Installing Rust and Cargo..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        # Source cargo environment *explicitly* for this script's execution context
        if [ -f "$HOME/.cargo/env" ]; then
             source "$HOME/.cargo/env"
             echo "Sourced $HOME/.cargo/env"
        else
             echo "Warning: Could not source cargo environment ($HOME/.cargo/env). Cargo install might fail." >&2
             # Attempt common default install path if env file missing
             if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
                export PATH="$HOME/.cargo/bin:$PATH"
                echo "Added $HOME/.cargo/bin to PATH for this script."
             fi
        fi
         # Double check cargo is now in PATH
        if ! command_exists cargo; then
            echo "Error: cargo command still not found after attempting install and PATH setup." >&2
            return 1
        fi
    fi

    echo "Installing/Updating Cargo packages: ${cargo_packages[*]}..."
    for pkg in "${cargo_packages[@]}"; do
        # Use install --force to update if already installed
        echo "Running: cargo install $pkg"
        cargo install $pkg || echo "Warning: Failed to install/update cargo package '$pkg'"
    done
}

# Function to fix bat -> batcat symlink
fix_bat_symlink() {
    if command_exists batcat && ! command_exists bat; then
        echo "Attempting to create symlink for bat -> batcat..."
        local bin_dir=""
        # Prefer user's local bin if it exists and is in PATH
        if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
             bin_dir="$HOME/.local/bin"
        # Fallback to /usr/local/bin if writable
        elif [ -d /usr/local/bin ] && [ -w /usr/local/bin ]; then
             bin_dir="/usr/local/bin"
        else
             echo "Could not find a suitable writable bin directory ($HOME/.local/bin in PATH or writable /usr/local/bin)." >&2
             echo "Skipping bat symlink creation. Please create it manually if desired." >&2
             return
        fi

        local bat_link_target="$bin_dir/bat"
        local batcat_path=$(command -v batcat)

        if [ ! -e "$bat_link_target" ]; then
             echo "Creating symlink: $bat_link_target -> $batcat_path"
             # Use sudo only if necessary (e.g., for /usr/local/bin)
             if [[ "$bin_dir" == "/usr/local/bin" ]]; then
                 sudo ln -s "$batcat_path" "$bat_link_target"
             else
                 ln -s "$batcat_path" "$bat_link_target"
             fi
             echo "Symlink created."
        elif [ -L "$bat_link_target" ] && [ "$(readlink "$bat_link_target")" == "$batcat_path" ]; then
             echo "bat symlink already exists and is correct."
        else
             echo "A file/link already exists at $bat_link_target but is not the correct symlink. Skipping."
        fi
    fi
}

# --- Main Script Execution ---

echo "Running Linux package installation script..."

# Install apt packages
if command_exists apt-get; then
    install_apt_packages
else
    echo "apt-get not found. Skipping apt package installation."
fi

# Install cargo packages
install_cargo_packages

# Fix bat symlink
fix_bat_symlink

echo "Linux package installation script finished." 