#!/bin/bash

# Get the project directory
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Prompt the user to select a terminal emulator
echo "Select your preferred terminal emulator:"
echo "1) Terminal.app"
echo "2) iTerm2"
read -p "Enter the number of your choice: " term_choice

# Set terminal command based on user choice
case $term_choice in
    1)
        TERMINAL="Terminal"
        ;;
    2)
        TERMINAL="iTerm"
        ;;
    *)
        echo "Invalid choice. Defaulting to Terminal.app."
        TERMINAL="Terminal"
        ;;
esac

# Check for Docker installation
echo "Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Please install Docker Desktop for Mac and run this script again."
    echo "Download it from: https://www.docker.com/products/docker-desktop"
    exit 1
else
    echo "Docker is already installed."
fi

# Build Docker image
echo "Building Docker image..."
if ! "$PROJECT_DIR/build_docker.sh"; then
    echo "Docker build failed. Please check the error messages above."
    exit 1
fi

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

# Create the application launcher script
echo "Creating application launcher..."
mkdir -p "$INSTALL_DIR/bin"
cat > "$INSTALL_DIR/bin/texvide_launcher.sh" << EOL
#!/bin/bash

# Run the main texvide script in the selected terminal emulator
osascript <<EOF
tell application "$TERMINAL"
    activate
    do script "$INSTALL_DIR/bin/texvide"
end tell
EOF
EOL

chmod +x "$INSTALL_DIR/bin/texvide_launcher.sh"

# Create the application bundle
APP_NAME="TexVIDE"
APP_DIR="$HOME/Applications/$APP_NAME.app"

echo "Creating application bundle at $APP_DIR..."

mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Create Info.plist
cat > "$APP_DIR/Contents/Info.plist" << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>texvide_launcher.sh</string>
    <key>CFBundleIdentifier</key>
    <string>com.yourcompany.texvide</string>
    <key>CFBundleName</key>
    <string>TexVIDE</string>
    <key>CFBundleIconFile</key>
    <string>logo.icns</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <string>0</string>
</dict>
</plist>
EOL

# Copy the executable script
cp "$INSTALL_DIR/bin/texvide_launcher.sh" "$APP_DIR/Contents/MacOS/"

# Copy the icon (convert logo.svg to logo.icns if necessary)
if [ -f "$INSTALL_DIR/img/logo.icns" ]; then
    cp "$INSTALL_DIR/img/logo.icns" "$APP_DIR/Contents/Resources/"
else
    echo "Converting logo.svg to logo.icns..."
    if ! command -v sips &> /dev/null || ! command -v iconutil &> /dev/null; then
        echo "Required tools 'sips' and 'iconutil' not found."
        exit 1
    fi
    ICONSET_DIR="$INSTALL_DIR/img/logo.iconset"
    mkdir "$ICONSET_DIR"
    sips -z 16 16     "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_16x16.png"
    sips -z 32 32     "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_16x16@2x.png"
    sips -z 32 32     "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_32x32.png"
    sips -z 64 64     "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_32x32@2x.png"
    sips -z 128 128   "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_128x128.png"
    sips -z 256 256   "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_128x128@2x.png"
    sips -z 256 256   "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_256x256.png"
    sips -z 512 512   "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_256x256@2x.png"
    sips -z 512 512   "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_512x512.png"
    sips -z 1024 1024 "$INSTALL_DIR/img/logo.svg" --out "$ICONSET_DIR/icon_512x512@2x.png"
    iconutil -c icns "$ICONSET_DIR" -o "$APP_DIR/Contents/Resources/logo.icns"
    rm -rf "$ICONSET_DIR"
fi

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
        shell_config="$HOME/.config/fish/config.fish"
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
        if ! grep -q "$INSTALL_DIR/bin" "$shell_config"; then
            echo "set -x PATH $INSTALL_DIR/bin \$PATH" >> "$shell_config"
            echo "Added $INSTALL_DIR/bin to PATH in $shell_config"
            echo "Please restart your terminal or run 'source $shell_config' for the changes to take effect."
        else
            echo "$INSTALL_DIR/bin is already in your PATH."
        fi
    }

    if [ "$user_shell" = "fish" ]; then
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
        if [ "$user_shell" = "fish" ]; then
            echo "set -x PATH $INSTALL_DIR/bin \$PATH"
        else
            echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\""
        fi
    fi
else
    echo "You can manually add texvide to your PATH."
fi

echo "Installation complete!"
echo "You can now run TexVIDE by typing 'texvide' in your terminal or by using the application from the Applications folder."