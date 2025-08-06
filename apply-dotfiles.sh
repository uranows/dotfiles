#!/bin/bash
# apply-dotfiles.sh - Apply dotfiles with automatic OS detection

set -euo pipefail

echo "Applying dotfiles with automatic OS detection..."
echo "Detected OS: $(uname -s)"
if [[ -f /etc/arch-release ]]; then
    echo "Detected distribution: Arch Linux"
elif [[ -f /etc/debian_version ]]; then
    echo "Detected distribution: Debian-based"
else
    echo "Detected distribution: Generic Linux"
fi
echo ""

chezmoi apply -v

echo ""
echo "Dotfiles applied successfully!"
