#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <project_dir> <install_dir>"
    exit 1
fi

PROJECT_DIR="$1"
INSTALL_DIR="$2"

# Build Docker image
"$PROJECT_DIR/install_scripts/build_docker.sh" "$PROJECT_DIR"

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

# Install python venv
"$PROJECT_DIR/install_scripts/create_python_venv.sh" "$PROJECT_DIR" "$INSTALL_DIR"

# Add texvide/bin to PATH
echo "Adding $INSTALL_DIR/bin to PATH..."
"$PROJECT_DIR/install_scripts/add_path.sh" "$INSTALL_DIR"
