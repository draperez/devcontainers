#!/bin/bash
set -e

if [ -f "$(dirname "$0")/install_uv_from_pipx.sh" ]; then
    source "$(dirname "$0")/install_uv_from_pipx.sh"
fi
