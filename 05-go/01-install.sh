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
# Constants
# ==========================================================

readonly GO_TARBALL="go${GO_VERSION}.${GO_ARCH}.tar.gz"
readonly GO_URL="https://go.dev/dl/${GO_TARBALL}"

# ==========================================================
# Functions
# ==========================================================

download_go() {

    info "Descargando Go ${GO_VERSION}..."

    curl -L "$GO_URL" -o "/tmp/${GO_TARBALL}"
}

install_go() {

    info "Eliminando instalaciones anteriores..."

    sudo rm -rf /usr/local/go

    info "Instalando Go..."

    sudo tar -C /usr/local -xzf "/tmp/${GO_TARBALL}"

    rm "/tmp/${GO_TARBALL}"
}

verify_installation() {

    if [[ -d /usr/local/go ]]; then
        success "Go instalado correctamente."
    else
        error "La instalación de Go ha fallado."
        exit 1
    fi
}

main() {

    step "Instalando Go"

    download_go

    install_go

    verify_installation
}

main