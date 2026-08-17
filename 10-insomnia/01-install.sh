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
# Configuration
# ==========================================================

INSOMNIA_PACKAGE="Insomnia.Core-${INSOMNIA_VERSION}.deb"
INSOMNIA_URL="https://github.com/Kong/insomnia/releases/download/core%40${INSOMNIA_VERSION}/${INSOMNIA_PACKAGE}"
DOWNLOAD_PATH="/tmp/${INSOMNIA_PACKAGE}"

# ==========================================================
# Main
# ==========================================================

main() {

    require_sudo
    require_command curl

    step "Instalando Insomnia"

    if command_exists insomnia; then

        warning "Insomnia ya está instalado."

        insomnia --version || true

        finish "Insomnia ya estaba instalado."

        return
    fi

    step "Descargando Insomnia"

    download_file \
        "$INSOMNIA_URL" \
        "$DOWNLOAD_PATH"

    success "Paquete descargado."

    step "Instalando Insomnia"

    sudo apt install -y "$DOWNLOAD_PATH"

    success "Insomnia instalado."

    rm -f "$DOWNLOAD_PATH"

    finish "Instalación de Insomnia completada."
}

main
