#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Error: Incorrect number of arguments."
    echo "Usage: $0 <project_dir> <install_dir>"
    exit 1
fi

PROJECT_DIR="$1"
INSTALL_DIR="$2"

# Install python venv
echo "Configuring python venv in $INSTALL_DIR..."
python3 -m venv "$INSTALL_DIR/venv"
source "$INSTALL_DIR/venv/bin/activate"
pip3 install --upgrade pip
pip3 install -r "$PROJECT_DIR/requirements.txt"

