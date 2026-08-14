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
# Install Flutter dependencies
# ==========================================================

install_flutter_dependencies() {

    step "Instalando dependencias de Flutter"

    sudo apt update

    sudo apt install -y \
        clang \
        cmake \
        ninja-build \
        pkg-config \
        libglu1-mesa \
        libgtk-3-dev \
        mesa-utils

    success "Dependencias instaladas."
}

# ==========================================================
# Install Flutter
# ==========================================================

install_flutter() {

    require_command git

    step "Instalando Flutter SDK"

    if directory_exists "$FLUTTER_INSTALL_DIR"; then
        warning "Flutter ya está instalado."
        return
    fi

    mkdir -p "$(dirname "$FLUTTER_INSTALL_DIR")"

    git clone \
        --branch "$FLUTTER_CHANNEL" \
        https://github.com/flutter/flutter.git \
        "$FLUTTER_INSTALL_DIR"

    success "Flutter instalado."
}

# ==========================================================
# Download SDK components
# ==========================================================

download_sdk() {

    step "Descargando componentes del SDK"

    export PATH="$FLUTTER_INSTALL_DIR/bin:$PATH"

    flutter precache

    success "Componentes descargados."
}

# ==========================================================
# Main
# ==========================================================

main() {

    require_sudo

    install_flutter_dependencies

    install_flutter

    download_sdk

    finish "Instalación completada."
}

main
