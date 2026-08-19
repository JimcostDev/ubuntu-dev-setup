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

    require_command sudo
    require_command apt

    step "Instalando OBS Studio"

    # ======================================================
    # Update package index
    # ======================================================

    step "Actualizando índices de paquetes"

    sudo apt update

    # ======================================================
    # Installation
    # ======================================================

    step "Instalando OBS Studio"

    sudo apt install -y obs-studio

    # ======================================================
    # Verification
    # ======================================================

    step "Verificando instalación"

    if ! command_exists obs; then

        error "OBS Studio no quedó disponible en PATH."

        exit 1
    fi

    success "OBS Studio instalado correctamente."

    echo

    info "Ejecutable:"
    echo "  $(command -v obs)"

    echo

    info "Versión:"
    obs --version || true

    echo

    info "Configuración:"
    echo "  $HOME/.config/obs-studio"

    echo

    info "Backup original:"
    echo "  /media/jimcostdev/data/OBS/obs-studio"

    echo

    warning "No se ha restaurado ninguna configuración."
    warning "Primero debemos comprobar el hardware y los encoders del AORUS."

    finish "OBS Studio instalado correctamente."
}

main
