#!/bin/bash

# Get the project directory
PROJECT_DIR="$(dirname "$0")"

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

# Install Docker if not already installed
echo "Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Please install Docker and run this script again."
    echo "You can install Docker by running: curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
    exit 1
else
    echo "Docker is already installed."
fi

# Build Docker image
echo "Building Docker image..."
"$PROJECT_DIR/build_docker.sh"

# Set installation directory
INSTALL_DIR="$HOME/.local/share/texvide"

# Check if installation directory already exists
if [ -d "$INSTALL_DIR" ]; then
    read -p "$INSTALL_DIR already exists. Do you want to clean it? (y/n): " clean_opt
    if [ "$clean_opt" = "y" ] || [ "$clean_opt" = "Y" ]; then
        echo "Cleaning $INSTALL_DIR..."
        rm -rf "$INSTALL_DIR"
    else
        echo "Skipping cleanup. Existing files may be overwritten."
    fi
fi

# Create installation directory
echo "Creating installation directory ($INSTALL_DIR)..."
mkdir -p "$INSTALL_DIR"

# Copy project files to installation directory
echo "Copying project files to $INSTALL_DIR..."
cp -r "$PROJECT_DIR"/* "$INSTALL_DIR/"

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

# Add texvide/bin to PATH
echo "Adding $INSTALL_DIR/bin to PATH..."
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
        shell_config=""
        ;;
esac


add_path() {
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
}


if [ -n "$shell_config" ]; then
    read -p "Do you want to add $INSTALL_DIR/bin to your PATH by modifying $shell_config? (y/n): " add_to_path

    if [ "$add_to_path" = "y" ] || [ "$add_to_path" = "Y" ]; then
        add_path
    else
        echo "Skipped adding $INSTALL_DIR/bin to PATH."
        echo "You can manually add it by adding the following line to your shell configuration file:"
        echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\""
    fi
else
    echo "You can manually add texvide to your PATH by adding the following line to your shell configuration file:"
    echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\""
fi

echo "Installation complete!"
echo "You can now run TexVIDE by typing 'texvide' in your terminal or by using the application menu."
