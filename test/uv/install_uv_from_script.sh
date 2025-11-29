#!/bin/bash
set -e

source dev-container-features-test-lib

if [ -f "$(dirname "$0")/common_checks.sh" ]; then
    source "$(dirname "$0")/common_checks.sh"
fi

# --- Specific Test for 'script' method ---
# This check ensures that either pipx is not installed, or if it is, uv is not managed by pipx.
if ! command -v pipx &> /dev/null; then
    check "pipx-not-installed" true
else
    check "uv-not-pipx" bash -c '! pipx list | grep -q "uv"'
fi

# Report results (required by devcontainer test framework)
if declare -f reportResults > /dev/null; then
    reportResults
else
    echo "All checks passed."
fi
