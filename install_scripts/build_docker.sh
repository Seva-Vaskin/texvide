#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <project_dir>"
    exit 1
fi

PROJECT_DIR="$1"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Please install Docker and run this script again."
    exit 1
fi

# Build Docker image
echo "Building Docker image..."

docker build -t texvide "$PROJECT_DIR"
