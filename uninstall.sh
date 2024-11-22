#!/bin/bash

set -e

# Determine the installation directory
INSTALL_DIR="$HOME/.local/share/texvide"

# Check if the installation directory exists
if [ ! -d "$INSTALL_DIR" ]; then
    echo "TexVIDE is not installed in $INSTALL_DIR"
    exit 1
fi

# Remove the installation directory
echo "Removing $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"

# Remove the .desktop file (for Linux)
if [ -f "$HOME/.local/share/applications/texvide.desktop" ]; then
    echo "Removing .desktop file..."
    rm "$HOME/.local/share/applications/texvide.desktop"
fi

# Remove the application bundle (for macOS)
APP_DIR="$HOME/Applications/TexVIDE.app"
if [ -d "$APP_DIR" ]; then
    echo "Removing application bundle..."
    rm -rf "$APP_DIR"
fi

# Remove texvide from PATH
echo "Removing texvide from PATH..."

# Determine the user's shell
user_shell=$(basename "$SHELL")

remove_path() {
    case "$user_shell" in
        bash)
            shell_config="$HOME/.bashrc"
            ;;
        zsh)
            shell_config="$HOME/.zshrc"
            ;;
        fish)
            shell_config="$HOME/.config/fish/config.fish"
            ;;
        *)
            echo "Unsupported shell. Please remove the TexVIDE path from your shell configuration file manually."
            return
            ;;
    esac

    if grep -q "$INSTALL_DIR/bin" "$shell_config"; then
        sed -i.bak "/export PATH=\"\$INSTALL_DIR\/bin:\$PATH\"/d" "$shell_config"
        echo "Removed $INSTALL_DIR/bin from PATH in $shell_config"
        echo "Please restart your terminal or run 'source $shell_config' for the changes to take effect."
    else
        echo "$INSTALL_DIR/bin was not found in your PATH."
    fi
}

remove_path

echo "TexVIDE has been uninstalled."
