#!/bin/bash
# apply-dotfiles.sh - Apply dotfiles with optional OS specification

set -euo pipefail

OS=${1:-auto}

echo "Applying dotfiles for OS: $OS"

case $OS in
    "windows")
        echo "Forcing Windows configuration..."
        CHEZMOI_OS=windows chezmoi apply -v
        ;;
    "debian")
        echo "Forcing Debian Linux configuration..."
        CHEZMOI_OS=linux chezmoi apply -v
        ;;
    "arch")
        echo "Forcing Arch Linux configuration..."
        CHEZMOI_OS=linux chezmoi apply -v
        ;;
    "auto")
        echo "Using automatic OS detection..."
        chezmoi apply -v
        ;;
    *)
        echo "Usage: $0 [windows|debian|arch|auto]"
        echo ""
        echo "Examples:"
        echo "  $0 auto      # Auto-detect OS (default)"
        echo "  $0 windows   # Force Windows configuration"
        echo "  $0 debian    # Force Debian Linux configuration"
        echo "  $0 arch      # Force Arch Linux configuration"
        exit 1
        ;;
esac

echo "Dotfiles applied successfully!"
