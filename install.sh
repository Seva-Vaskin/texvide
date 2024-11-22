#!/bin/bash

set -e

PROJECT_DIR="$(dirname "$0")"
INSTALL_DIR="$HOME/.local/share/texvide"

# Run the base installation script
"$PROJECT_DIR/install_scripts/install_base.sh" "$PROJECT_DIR" "$INSTALL_DIR"

# Detect the host OS
case "$(uname -s)" in
    Linux*)
        echo "Running Linux specific installation..."
        "$PROJECT_DIR/install_scripts/install_linux.sh" "$PROJECT_DIR" "$INSTALL_DIR"
        ;;
    Darwin*)
        echo "Running macOS specific installation..."
        "$PROJECT_DIR/install_scripts/install_osx.sh" "$PROJECT_DIR" "$INSTALL_DIR"
        ;;
    *)
        echo "Unsupported operating system. TexVIDE supports Linux and macOS only."
        exit 1
        ;;
esac

echo "Installation complete!"
