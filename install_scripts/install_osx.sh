#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <project_dir> <install_dir>"
    exit 1
fi

PROJECT_DIR="$1"
INSTALL_DIR="$2"

# TODO: Implement macOS specific installation, install TexVIDE.app
