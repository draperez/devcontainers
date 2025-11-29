#!/bin/bash
set -e

source dev-container-features-test-lib

check "python" python --version
check "uv" uv --version
check "uvx" uvx --version