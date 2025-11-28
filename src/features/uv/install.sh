#!/bin/bash
set -e

# Get options from devcontainer-feature.json
PYTHON_VERSION="${PYTHONVERSION:-3.14}"
UV_PROJECT_ENVIRONMENT="${PROJECTENVIRONMENT:-/tmp/venv}"

echo "Installing uv from astral/uv:python${PYTHON_VERSION}-trixie..."


# Fallback: download uv using the install script
echo "Using uv installer..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Move uv to /usr/local/bin for system-wide access
if [ -f "$HOME/.cargo/bin/uv" ]; then
    mv "$HOME/.cargo/bin/uv" /usr/local/bin/uv
fi

# Make sure uv is executable
chmod +x /usr/local/bin/uv

# Verify installation
if command -v uv &> /dev/null; then
    echo "uv installed successfully!"
    uv --version
else
    echo "ERROR: uv installation failed"
    exit 1
fi

echo "UV_PROJECT_ENVIRONMENT will be set to: ${UV_PROJECT_ENVIRONMENT}"
