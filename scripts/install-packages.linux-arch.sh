#!/usr/bin/env bash
# Install pacman packages on Arch. Uses packages/pacman.txt.
# CHEZMOI_SOURCE_DIR is set by chezmoi. Run as run_once on first apply.

[[ "$(uname -s)" != "Linux" ]] && exit 0
command -v pacman >/dev/null 2>&1 || exit 0

set -euo pipefail

packages_file="${CHEZMOI_SOURCE_DIR}/packages/pacman.txt"
[[ ! -f "$packages_file" ]] && { echo "Missing $packages_file"; exit 1; }

while fuser /var/lib/pacman/db.lck >/dev/null 2>&1; do sleep 2; done

list=$(grep -Ev '^(#|$)' "$packages_file")
[[ -z "$list" ]] && { echo "No packages in pacman.txt"; exit 0; }
echo "Installing packages from pacman.txt..."
echo "$list" | sudo pacman -Syu --needed --noconfirm -

echo "Arch package installation complete."
