#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Definition specific tests
check "uv" uv --version
check "uvx" uvx --version
check "python" python --version

# Report result
reportResults
