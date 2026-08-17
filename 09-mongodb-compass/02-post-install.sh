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

# ==========================================================
# Main
# ==========================================================

step "Verificando MongoDB Compass"

if ! command_exists mongodb-compass; then

    error "MongoDB Compass no está instalado."

    info "Ejecuta:"
    echo "  ./09-mongodb-compass/01-install.sh"

    exit 1
fi

success "MongoDB Compass está instalado."

echo

info "Versión instalada:"

mongodb-compass --version

echo

info "Ejecutable:"

command -v mongodb-compass

echo

info "MongoDB Compass está listo para conectarse a MongoDB Atlas."

finish "Verificación completada."
