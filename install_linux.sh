#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

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
    echo "Docker not found. Installing Docker..."
    ./install_docker.sh
else
    echo "Docker is already installed."
fi

# Build Docker image
echo "Building Docker image..."
"$PROJECT_DIR/build_docker.sh"

# Check if /opt/texvide already exists
if [ -d "/opt/texvide" ]; then
    read -p "/opt/texvide already exists. Do you want to clean it? (y/n): " clean_opt
    if [ "$clean_opt" = "y" ] || [ "$clean_opt" = "Y" ]; then
        echo "Cleaning /opt/texvide..."
        rm -rf /opt/texvide
    else
        echo "Skipping cleanup. Existing files may be overwritten."
    fi
fi

# Create directory in /opt
echo "Creating directory in /opt..."
mkdir -p /opt/texvide

# Copy project files to /opt/texvide
echo "Copying project files..."
cp -r "$PROJECT_DIR"/* /opt/texvide/

# Create .desktop file
echo "Creating .desktop file..."
cat > /usr/share/applications/texvide.desktop << EOL
[Desktop Entry]
Name=TexVIDE
Exec=$TERMINAL /opt/texvide/run.sh
Icon=/opt/texvide/img/logo.svg
Type=Application
Categories=Development;
EOL

echo "Installation complete!"
