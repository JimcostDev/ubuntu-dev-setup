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

install_python() {

    step "Instalando herramientas de Python"

    sudo apt update

    sudo apt install -y \
        python3-pip \
        python3-venv \
        python3-dev \
        python3-full \
        build-essential

    success "Herramientas de Python instaladas."
}

verify_python() {

    require_command python3
    require_command pip3
}

main() {

    require_sudo

    install_python

    verify_python

    finish "Instalación completada."
}

main