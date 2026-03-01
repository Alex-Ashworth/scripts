#!/bin/bash -e

# This script creates a default project structure for python projects
if [[ -n "$1" ]]; then
  DIR="$1"
else
  read -rp "Enter a name for your project: " DIR
fi

mkdir -p src/ "src/$DIR" tests/

[[ -e "launcher.py" ]] || cat <<'EOF' > launcher.py
from project.cli import main

raise SystemExit(main())
EOF

[[ -e "src/$DIR/__init__.py" ]] || cat <<'EOF' > "src/$DIR/__init__.py"
from .core import run

__version__ = "0.1.0"

__all__ = ["run"]
EOF

[[ -e "src/$DIR/__main__.py" ]] || cat <<'EOF' > "src/$DIR/__main__.py"
from .cli import main

raise SystemExit(main())
EOF

[[ -e "src/$DIR/cli.py" ]] || cat <<'EOF' > "src/$DIR/cli.py"
from .core import run

def main() -> int:
  run()
  return 0
EOF

[[ -e "src/$DIR/core.py" ]] || printf '# Core logic:' >> "src/$DIR/core.py"
[[ -e "src/$DIR/utils.py" ]] || printf '# Utils, generic functions, and classes:' >> "src/$DIR/utils.py"
[[ -e "README.md" ]] || printf '## Default README for %s Python project.' "$DIR" >> README.md
[[ -e ".env" ]] || touch .env

[[ -e "pyproject.toml" ]] || cat <<EOF > pyproject.toml
[build-system]
requires = ["setuptools"]
build-backend = "setuptools.build_meta"

[project]
name = "$DIR"
version = "0.1.0"
description = "$DIR Python project."
readme = "README.md"
requires-python = ">=3.11"
dependencies = []

[project.scripts]
$DIR = "$DIR.cli:main"

[tool.setuptools.packages.find]
where = ["src"]
EOF

[[ -e ".gitignore" ]] || cat <<'EOF' > .gitignore
# Python
__pycache__/
*.py[cod]
*.pyo
*.pyd
*cache/

# Virtual environments
.venv/
venv/
env/
ENV/

# Environment files
.env
.env.*

# Build artifacts
/dist
/build
/site
*.egg-info/
.eggs/
*.egg
pip-wheel-metadata/
*.spec

# IDE
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Custom

EOF

printf '\033[1;32mDefault Python project structure has been succesfully created.\033[0m\n'

[[ -e ".venv" ]] || python -m venv .venv && .venv/bin/python -m pip install -U pip

printf '\033[1;32mVirtual Environment has been succesfully created.\033[0m\n'
printf "\033[1;32mDon't forget to activate the virtual environment!\033[0m\n"
