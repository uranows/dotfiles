#!/usr/bin/env bash
# This script installs packages on generic Linux systems
# It uses the packages list from the packages directory
# CHEZMOI_SOURCE_DIR is set by chezmoi

# Only proceed on Linux
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Skipping generic Linux package installation on non-Linux host"
    exit 0
fi

set -euo pipefail

echo "Generic Linux system detected. Please install packages manually:"
echo "- zsh, starship, git, curl, eza, fzf, bat, ripgrep, fd, tldr"
echo "- build tools: build-essential/base-devel, cmake, openssl"

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

echo "Generic Linux package installation complete."
