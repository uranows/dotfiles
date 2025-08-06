#!/usr/bin/env bash
# This script installs packages on Debian-based Linux systems (Ubuntu, Debian, etc.)
# It uses the packages list from the packages directory
# CHEZMOI_SOURCE_DIR is set by chezmoi

# Only proceed on Linux
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Skipping Debian package installation on non-Linux host"
    exit 0
fi

# Check if this is a Debian-based system
if ! command -v apt-get >/dev/null 2>&1; then
    echo "This script is for Debian-based systems only (apt-get not found)"
    exit 0
fi

set -euo pipefail

# Path to APT packages list
packages_file="$CHEZMOI_SOURCE_DIR/packages/apt-packages-debian-linux.txt"
if [[ ! -f "$packages_file" ]]; then
    echo "APT package list not found: $packages_file"
    exit 1
fi

echo "Updating apt package lists..."
sudo apt-get update

echo "Installing apt packages from $packages_file..."
grep -Ev '^(#|$)' "$packages_file" | xargs sudo apt-get install -y

# Cargo packages
cargo_packages=("zoxide --locked" "gitui" "du-dust")
if ! command -v cargo >/dev/null 2>&1; then
    echo "Installing Rust and Cargo via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env" || true
fi

echo "Installing/Updating Cargo packages: ${cargo_packages[*]}"
for pkg in "${cargo_packages[@]}"; do
    cargo install $pkg || echo "Warning: Failed to install/update cargo package '$pkg'"
done

# Fix bat -> batcat symlink if needed
echo "Ensuring batcat is available as bat..."
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

echo "Debian-based Linux package installation complete." 