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

COMPASS_PACKAGE="mongodb-compass_${MONGODB_COMPASS_VERSION}_amd64.deb"
COMPASS_URL="https://downloads.mongodb.com/compass/${COMPASS_PACKAGE}"
DOWNLOAD_DIR="/tmp"
DOWNLOAD_PATH="$DOWNLOAD_DIR/$COMPASS_PACKAGE"

# ==========================================================
# Main
# ==========================================================

main() {

    require_sudo

    require_command curl
    require_command dpkg

    step "Instalando MongoDB Compass"

    if command_exists mongodb-compass; then

        warning "MongoDB Compass ya está instalado."

        mongodb-compass --version

        finish "MongoDB Compass ya estaba instalado."

        return
    fi

    step "Descargando MongoDB Compass"

    download_file \
        "$COMPASS_URL" \
        "$DOWNLOAD_PATH"

    success "Paquete descargado."

    step "Instalando MongoDB Compass"

    sudo apt install -y "$DOWNLOAD_PATH"

    success "MongoDB Compass instalado."

    rm -f "$DOWNLOAD_PATH"

    finish "Instalación de MongoDB Compass completada."
}

main
