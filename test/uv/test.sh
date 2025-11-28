#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Definition specific tests
check "uv" uv --version
check "uvx" uvx --version
check "python" python --version

echo "UV_PROJECT_ENVIRONMENT is: $UV_PROJECT_ENVIRONMENT"
check "UV_PROJECT_ENVIRONMENT" printenv UV_PROJECT_ENVIRONMENT
check "UV_PROJECT_ENVIRONMENT" printenv UV_PROJECT_ENVIRONMENT | grep "/tmp/venv"

# Report result
reportResults
