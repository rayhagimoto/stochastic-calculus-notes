#!/usr/bin/bash

# Get absolute path to the script and its directory
SCRIPT_FULL_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_FULL_PATH")

# Determine project root (parent of script's directory)
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")

# Extract project directory name (e.g., "stochastic-calculus-notes")
PROJECT_DIR_NAME=$(basename "$PROJECT_ROOT")

# Derive output PDF filename (e.g., "stochastic-calculus")
OUTPUT_FILENAME=$(echo "$PROJECT_DIR_NAME" | sed 's/-notes$//')
OUTPUT_FULL_FILENAME="${OUTPUT_FILENAME}.pdf"

# Change to project root for correct path resolution
cd "$PROJECT_ROOT" || { echo "Error: Could not change to project root"; exit 1; }

# Set XDG_DATA_HOME as required
export XDG_DATA_HOME="${HOME}/.local/share"

# Run Typst compilation with dynamic output name
echo "Compiling Typst project: $PROJECT_DIR_NAME to $OUTPUT_FULL_FILENAME"
typst compile src/main.typ "$OUTPUT_FULL_FILENAME"

# Check Typst compilation result
if [ $? -ne 0 ]; then
    echo "Typst compilation failed!"
    exit 1
fi