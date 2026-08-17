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

main() {

    step "Verificando Insomnia"

    if ! command_exists insomnia; then

        error "Insomnia no está instalado."

        info "Ejecuta:"
        echo "  ./10-insomnia/01-install.sh"

        exit 1
    fi

    success "Insomnia está instalado."

    echo

    info "Ejecutable:"
    command -v insomnia

    echo

    info "Versión instalada:"
    insomnia --version || true

    finish "Verificación de Insomnia completada."
}

main
