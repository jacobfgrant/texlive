#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Default values
NO_CACHE=""
VERSIONS=("base" "recommended" "extra" "full")

# Help function
usage() {
    cat << EOF
Usage: $(basename "$0") [options]

Build Docker images for different TeXLive versions.

Options:
    -h, --help      Show this help message
    -n, --no-cache  Build images without using Docker cache
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]
do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -n|--no-cache)
            NO_CACHE="--no-cache"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Main build loop
echo "Starting builds..."
for version in "${VERSIONS[@]}"
do
    echo "Building texlive:$version..."
    if ! docker build $NO_CACHE -t "texlive:$version" -f "Dockerfile.$version" .
    then
        echo "Error: Failed to build texlive:$version"
        exit 1
    fi
done

echo "All images built successfully!"
