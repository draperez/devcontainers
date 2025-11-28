# UV Python Environment Feature

A custom devcontainer feature that installs `uv` and configures a Python environment.

## Features

1. **Installs uv** using the official installer script
2. **Sets UV_PROJECT_ENVIRONMENT** environment variable automatically
3. **Configures python.defaultInterpreterPath** in VS Code settings
4. **Supports custom postCreateCommand** and **postStartCommand**

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `pythonVersion` | string | `3.14` | Python version (currently unused) |
| `projectEnvironment` | string | `/tmp/venv` | Path for UV_PROJECT_ENVIRONMENT |
| `postCreateCommand` | string | `uv venv --clear` | Command to run after container creation |
| `postStartCommand` | string | `if [ -f pyproject.toml ]; then uv sync --extra dev; fi` | Command to run when container starts |

## Usage

Add to your `devcontainer.json`:

```json
{
  "features": {
    "./features/uv-python-env": {
      "pythonVersion": "3.14",
      "projectEnvironment": "/tmp/venv",
      "postCreateCommand": "uv venv --clear",
      "postStartCommand": "if [ -f pyproject.toml ]; then uv sync --extra dev; fi"
    }
  }
}
```

The feature automatically:
- Sets `UV_PROJECT_ENVIRONMENT` environment variable
- Configures `python.defaultInterpreterPath` to point to the virtual environment
- Runs the specified commands at the appropriate lifecycle stages
