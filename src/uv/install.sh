#!/bin/bash
set -e

# Get options from devcontainer-feature.json
PYTHON_VERSION="${PYTHONVERSION:-3.14}"
UV_PROJECT_ENVIRONMENT="${PROJECTENVIRONMENT:-/tmp/venv}"

if ! command -v curl &> /dev/null; then
    echo "curl is required but not installed. Please install curl and try again."
    exit 1
fi


echo "Installing uv from astral..."


# Fallback: download uv using the install script
echo "Using uv installer..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Determine install location
UV_BIN=""
UV_DIR=""
if [ -f "$HOME/.cargo/bin/uv" ]; then
    UV_BIN="$HOME/.cargo/bin/uv"
    UVX_BIN="$HOME/.cargo/bin/uvx"
    UV_DIR="$HOME/.cargo/bin"
elif [ -f "$HOME/.local/bin/uv" ]; then
    UV_BIN="$HOME/.local/bin/uv"
    UVX_BIN="$HOME/.local/bin/uvx"
    UV_DIR="$HOME/.local/bin"
fi

if [ -z "$UV_BIN" ]; then
    echo "Could not find uv binary."
    exit 1
fi

# If we are root, move to /usr/local/bin so it's available to all users
if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root, moving uv to /usr/local/bin..."
    mv "$UV_BIN" /usr/local/bin/uv
    chmod +x /usr/local/bin/uv
    
    if [ -n "$UVX_BIN" ] && [ -f "$UVX_BIN" ]; then
        mv "$UVX_BIN" /usr/local/bin/uvx
        chmod +x /usr/local/bin/uvx
    fi
else
    echo "Running as non-root. Ensuring $UV_DIR is in PATH..."
    
    # Add to .bashrc if not present
    if ! grep -q "$UV_DIR" "$HOME/.bashrc"; then
        echo "export PATH=\"$UV_DIR:\$PATH\"" >> "$HOME/.bashrc"
    fi
    # Add to .zshrc if not present
    if ! grep -q "$UV_DIR" "$HOME/.zshrc" 2>/dev/null; then
        echo "export PATH=\"$UV_DIR:\$PATH\"" >> "$HOME/.zshrc"
    fi
    
    # Export for current session verification
    export PATH="$UV_DIR:$PATH"
fi

# Verify installation
if command -v uv &> /dev/null; then
    echo "uv installed successfully!"
    uv --version
else
    echo "ERROR: uv installation failed"
    exit 1
fi

echo "UV_PROJECT_ENVIRONMENT will be set to: ${UV_PROJECT_ENVIRONMENT}"
