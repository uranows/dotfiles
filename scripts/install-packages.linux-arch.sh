#!/usr/bin/env bash
# This script installs packages on Arch Linux systems
# It uses the packages list from the packages directory
# CHEZMOI_SOURCE_DIR is set by chezmoi

# Only proceed on Linux
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Skipping Arch package installation on non-Linux host"
    exit 0
fi

# Check if this is an Arch-based system
if ! command -v pacman >/dev/null 2>&1; then
    echo "This script is for Arch-based systems only (pacman not found)"
    exit 0
fi

set -euo pipefail

# Path to pacman packages list
packages_file="$CHEZMOI_SOURCE_DIR/packages/pacman-packages.linux-arch.txt"
if [[ ! -f "$packages_file" ]]; then
    echo "Pacman package list not found: $packages_file"
    exit 1
fi

echo "Installing packages from $packages_file..."
grep -Ev '^(#|$)' "$packages_file" | xargs sudo pacman -S --noconfirm

# Install Rust if not present
if ! command -v cargo >/dev/null 2>&1; then
    echo "Installing Rust and Cargo via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env" || true
fi

# Install Cargo packages
cargo_packages=("zoxide --locked" "gitui" "du-dust")
echo "Installing Cargo packages: ${cargo_packages[*]}"
for pkg in "${cargo_packages[@]}"; do
    cargo install $pkg || echo "Warning: Failed to install cargo package '$pkg'"
done

echo "Arch Linux package installation complete."
