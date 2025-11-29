#!/bin/bash
set -e

source dev-container-features-test-lib
if [ -f "$(dirname "$0")/common_checks.sh" ]; then
    source "$(dirname "$0")/common_checks.sh"
fi

# This check ensures that uv is managed by pipx.
check "pipx" pipx --version
check "uv-pipx" pipx list | grep -q "uv"

# Report results (required by devcontainer test framework)
if declare -f reportResults > /dev/null; then
    reportResults
else
    echo "All checks passed."
fi