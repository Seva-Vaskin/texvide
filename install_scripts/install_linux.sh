#!/bin/bash
set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <project_dir> <install_dir>"
    exit 1
fi

PROJECT_DIR="$1"
INSTALL_DIR="$2"

# Prompt the user to select a terminal emulator
echo "Select your preferred terminal emulator:"
echo "1) kitty"
echo "2) gnome-terminal"
echo "3) xterm"
read -p "Enter the number of your choice: " term_choice

# Set terminal command based on user choice
case $term_choice in
    1)
        TERMINAL="kitty -e"
        ;;
    2)
        TERMINAL="gnome-terminal --"
        ;;
    3)
        TERMINAL="xterm -e"
        ;;
    *)
        echo "Invalid choice. Defaulting to kitty."
        TERMINAL="kitty -e"
        ;;
esac

# Create .desktop file
echo "Creating .desktop file..."
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/texvide.desktop" << EOL
[Desktop Entry]
Name=TexVIDE
Exec=$TERMINAL $INSTALL_DIR/bin/texvide
Icon=$INSTALL_DIR/img/logo.svg
Type=Application
Categories=Development;
EOL
