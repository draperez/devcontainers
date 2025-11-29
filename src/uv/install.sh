#!/bin/bash
set -e
# get installationMethod option, default to "auto"
INSTALL_METHOD="${INSTALLATIONMETHOD:-auto}"

# Verify that curl or pipx is installed
verify_curl_or_pipx() {
    if ! command -v curl &> /dev/null && ! command -v pipx &> /dev/null; then
        echo "Error: Neither curl nor pipx is installed. Cannot proceed with UV installation."
        return 1
    fi
    return 0
}

# Verify if uv and uvx are installed
verify_installation() {
    if ! command -v uv &> /dev/null; then
        echo "uv is not installed."
        return 1
    fi
    if ! command -v uvx &> /dev/null; then
        echo "uvx is not installed."
        return 1
    fi
    return 0
}

install_from_script() {
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. UV cannot be installed from script."
        return 1
    fi

    echo "Installing uv from script..."


    # Download uv using the install script
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
        return 1
    fi

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

    verify_installation
}

install_from_pipx() {
    if ! command -v pipx &> /dev/null; then
        echo "pipx is not installed. UV cannot be installed from pipx."
        return 1
    fi

    echo "Installing uv using pipx..."
    pipx install uv

    if [ $? -ne 0 ]; then
        echo "Error: pipx install uv failed."
        return 1
    fi
    verify_installation
}

# --- Main installation logic -----------------------------------------
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "Fatal Error: Python is not installed. UV requires Python."
    exit 1
fi
if verify_installation; then
    echo "UV is already installed. Skipping installation."
    exit 0
fi

case "$INSTALL_METHOD" in
    "script")
        install_from_script || { echo "Fatal error: Script installation failed."; exit 1; }
        ;;

    "pipx")
        install_from_pipx || { echo "Fatal error: Pipx installation failed."; exit 1; }
        ;;

    "auto" | *)
        # Try pipx first if available
        install_from_pipx || install_from_script || { echo "Fatal error: All installation attempts failed in auto mode."; exit 1; }
        ;;
esac

if verify_installation; then
    echo "Success: UV installation completed successfully."
else
    echo "Fatal Error: UV installation failed. Are curl or pipx installed? (Installation method: ${INSTALL_METHOD})"
    exit 1
fi
