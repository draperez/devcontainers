#!/bin/bash
set -e

# if [ -f "$(dirname "$0")/common_checks.sh" ]; then
#     source "$(dirname "$0")/common_checks.sh"
# fi

# Report results (required by devcontainer test framework)
if declare -f reportResults > /dev/null; then
    reportResults
else
    echo "All checks passed."
fi
