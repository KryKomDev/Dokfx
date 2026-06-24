#!/usr/bin/env bash

# Downloads and updates the Dokfx template to a specified or latest version from GitHub.

set -euo pipefail

show_help() {
    echo "Usage:"
    echo "  $(basename "$0") [options]"
    echo ""
    echo "Options:"
    echo "  -t, --target PATH      Destination path for the Dokfx template (default: ../Docs/templates/dokfx)"
    echo "  -g, --tag TAG          Specific release tag to download (default: latest)"
    echo "  -s, --skip-backup      Skip backup of the existing template directory"
    echo "  -h, --help             Show this help message"
    echo ""
}

# Default parameter values
TARGET_DIRECTORY="../Docs/templates/dokfx"
REPO="KryKomDev/Dokfx"
TAG="latest"
SKIP_BACKUP=false

# Option parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--target)
            TARGET_DIRECTORY="$2"
            shift 2
            ;;
        -g|--tag)
            TAG="$2"
            shift 2
            ;;
        -s|--skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Unknown option $1" >&2
            show_help
            exit 1
            ;;
    esac
done

# Resolve target directory to absolute path
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$PWD"
fi

if [[ "$TARGET_DIRECTORY" = /* ]]; then
    TARGET_DIR="$TARGET_DIRECTORY"
else
    TARGET_DIR="$(cd "$SCRIPT_DIR" && pwd)/$TARGET_DIRECTORY"
fi

# Determine API URL
if [ "$TAG" = "latest" ]; then
    API_URL="https://api.github.com/repos/$REPO/releases/latest"
else
    API_URL="https://api.github.com/repos/$REPO/releases/tags/$TAG"
fi

# Fetch release JSON
if command -v curl >/dev/null 2>&1; then
    RELEASE_JSON=$(curl -s -L -H "User-Agent: bash" "$API_URL")
elif command -v wget >/dev/null 2>&1; then
    RELEASE_JSON=$(wget -qO- --header="User-Agent: bash" "$API_URL")
else
    echo "Error: Neither curl nor wget is installed." >&2
    exit 1
fi

# Parse tag_name and asset download URL with multiple fallbacks (jq -> python3/python -> grep/sed)
TAG_NAME=""
DOWNLOAD_URL=""

if command -v jq >/dev/null 2>&1; then
    TAG_NAME=$(echo "$RELEASE_JSON" | jq -r '.tag_name // empty')
    DOWNLOAD_URL=$(echo "$RELEASE_JSON" | jq -r '.assets[]? | select(.name == "dokfx-template.zip") | .browser_download_url // empty')
    if [ -z "$DOWNLOAD_URL" ]; then
        DOWNLOAD_URL=$(echo "$RELEASE_JSON" | jq -r '.zipball_url // empty')
    fi
elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    PYTHON_CMD="python3"
    if ! command -v python3 >/dev/null 2>&1; then
        PYTHON_CMD="python"
    fi
    TAG_NAME=$(echo "$RELEASE_JSON" | $PYTHON_CMD -c "import sys, json; print(json.load(sys.stdin).get('tag_name', ''))" 2>/dev/null)
    DOWNLOAD_URL=$(echo "$RELEASE_JSON" | $PYTHON_CMD -c "
import sys, json
data = json.load(sys.stdin)
assets = data.get('assets', [])
url = next((a['browser_download_url'] for a in assets if a['name'] == 'dokfx-template.zip'), '')
print(url if url else data.get('zipball_url', ''))
" 2>/dev/null)
else
    # Grep and sed fallbacks for minimal POSIX systems
    TAG_NAME=$(echo "$RELEASE_JSON" | grep -o '"tag_name": *"[^"]*"' | head -n 1 | cut -d'"' -f4 || true)
    DOWNLOAD_URL=$(echo "$RELEASE_JSON" | grep -o '"browser_download_url": *"[^"]*dokfx-template.zip"' | head -n 1 | cut -d'"' -f4 || true)
    if [ -z "$DOWNLOAD_URL" ]; then
        DOWNLOAD_URL=$(echo "$RELEASE_JSON" | grep -o '"zipball_url": *"[^"]*"' | head -n 1 | cut -d'"' -f4 || true)
    fi
fi

if [ -z "$TAG_NAME" ]; then
    echo "Error: Failed to parse tag name from GitHub API response." >&2
    exit 1
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Failed to find download URL for Dokfx template." >&2
    exit 1
fi

# Create backup of old files before deleting if requested and directory exists
if [ -d "$TARGET_DIR" ] && [ "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]; then
    if [ "$SKIP_BACKUP" = false ]; then
        TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
        BACKUP_FILE="dokfx-backup-$TIMESTAMP.tar.gz"
        BACKUP_PARENT=$(dirname "$TARGET_DIR")
        BACKUP_PATH="$BACKUP_PARENT/$BACKUP_FILE"
        if tar -czf "$BACKUP_PATH" -C "$TARGET_DIR" . 2>/dev/null; then
            :
        else
            echo "Warning: Backup compression failed. Proceeding with update anyway..."
        fi
    fi
fi

# Download to a temporary location
TEMP_ZIP=$(mktemp)
mv "$TEMP_ZIP" "$TEMP_ZIP.zip"
TEMP_ZIP="$TEMP_ZIP.zip"

if command -v curl >/dev/null 2>&1; then
    curl -s -L -o "$TEMP_ZIP" "$DOWNLOAD_URL"
elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$TEMP_ZIP" "$DOWNLOAD_URL"
fi

# Clean destination folder
if [ -d "$TARGET_DIR" ]; then
    rm -rf "${TARGET_DIR:?}"/*
else
    mkdir -p "$TARGET_DIR"
fi

# Extract zip
TEMP_EXTRACT_DIR=$(mktemp -d)

if command -v unzip >/dev/null 2>&1; then
    unzip -q "$TEMP_ZIP" -d "$TEMP_EXTRACT_DIR"
else
    # Fallback to python extraction if unzip is missing
    if command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
        PYTHON_CMD="python3"
        if ! command -v python3 >/dev/null 2>&1; then
            PYTHON_CMD="python"
        fi
        $PYTHON_CMD -c "import zipfile; zipfile.ZipFile('$TEMP_ZIP').extractall('$TEMP_EXTRACT_DIR')"
    else
        echo "Error: Neither 'unzip' nor 'python' is available for zip extraction." >&2
        rm -f "$TEMP_ZIP"
        rm -rf "$TEMP_EXTRACT_DIR"
        exit 1
    fi
fi

# Handle wrapper folders (e.g. if we downloaded the source code zipball)
SOURCE_DIR="$TEMP_EXTRACT_DIR"
# Expand root items array
# shellcheck disable=SC2012
ROOT_ITEMS_COUNT=$(ls -1 "$TEMP_EXTRACT_DIR" | wc -l | tr -d ' ')
if [ "$ROOT_ITEMS_COUNT" -eq 1 ]; then
    SINGLE_ITEM=$(find "$TEMP_EXTRACT_DIR" -mindepth 1 -maxdepth 1)
    if [ -d "$SINGLE_ITEM" ]; then
        BASE_NAME=$(basename "$SINGLE_ITEM")
        if [ "$BASE_NAME" != "partials" ] && [ "$BASE_NAME" != "public" ]; then
            SOURCE_DIR="$SINGLE_ITEM"
        fi
    fi
fi

# Copy template files to target
cp -R "$SOURCE_DIR"/* "$TARGET_DIR"/

# Clean up
rm -f "$TEMP_ZIP"
rm -rf "$TEMP_EXTRACT_DIR"

echo "Success! Dokfx template updated to version $TAG_NAME!"
