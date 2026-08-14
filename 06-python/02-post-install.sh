#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Paths
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# ==========================================================
# Load utilities and configuration
# ==========================================================

source "$PROJECT_ROOT/lib/utils.sh"

load_config

step "Verificando instalación de Python"

python3 --version

pip3 --version

python3 -m venv --help >/dev/null

success "Python está configurado correctamente."

echo

info "Prueba creando un entorno virtual:"

echo

echo "python3 -m venv .venv"
echo "source .venv/bin/activate"

echo

finish "Configuración de Python completada."