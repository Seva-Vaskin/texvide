#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <install_dir>"
    exit 1
fi

INSTALL_DIR="$1"

# Determine the user's shell
user_shell=$(basename "$SHELL")

case "$user_shell" in
    bash)
        shell_config="$HOME/.bashrc"
        ;;
    zsh)
        shell_config="$HOME/.zshrc"
        ;;
    fish)
        shell_config="fish config"
        ;;
    *)
        echo "Unsupported shell. Cannot automatically add texvide to the PATH."
        echo "Please add the following line to your shell configuration file manually:"
        echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\""
        exit 1
        ;;
esac

handle_bash_like_env() {
    if ! grep -q "$INSTALL_DIR/bin" "$shell_config"; then
        echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$shell_config"
        echo "Added $INSTALL_DIR/bin to PATH in $shell_config"
        echo "Please restart your terminal or run 'source $shell_config' for the changes to take effect."
    else
        echo "$INSTALL_DIR/bin is already in your PATH."
    fi
}

handle_fish_env() {
    fish -c "fish_add_path -a $INSTALL_DIR/bin"
}

if [ "$shell_config" = "fish config" ]; then
    handle_fish_env
else
    handle_bash_like_env
fi
