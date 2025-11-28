# UV Python Environment Feature

This devcontainer feature installs [`uv`](https://github.com/astral-sh/uv) using the official installer script.

## What it does

- Installs `uv` from [astral.sh](https://astral.sh/uv/)

## Usage

Add to your `devcontainer.json`:

```json
{
  
    "features": {
        "ghcr.io/draperez/devcontainers/uv": {}
    },
}
```

You can now use `uv` in your devcontainer.

> **Note:** This feature does not set up environment variables, VS Code settings, or lifecycle commands. It only installs `uv`.

A more advanced reccomendation is to use the `uv` command in your `postCreateCommand` and `postStartCommand` and setting the `UV_PROJECT_ENVIRONMENT` environment variable to specify where the virtual environment should be created. This allows you to manage your Python environments more effectively:

```json
{
    "features": {
        "ghcr.io/draperez/devcontainers/uv": {}
    },
    "containerEnv": {
        "UV_PROJECT_ENVIRONMENT": "/tmp/venv" // This creates the virtual environment outside the workspace
    },
    "postCreateCommand": "uv venv --clear",  // This creates a new virtual environment
    "postStartCommand": "uv sync --extra dev" // This ensures the virtual environment is up to date
}
```


## Testing the features:

Example for UV feature:

```bash
devcontainer features test --features uv --base-image mcr.microsoft.com/devcontainers/python:3
```

or 

```bash
devcontainer features test --features uv --base-image registry.gitlab.com/mu-bd-ce/devcontainers/python
```
