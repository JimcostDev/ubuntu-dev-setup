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

CLI_BIN="$HOME/.local/bin/agy"

# ==========================================================
# Main
# ==========================================================

main() {

    require_command curl

    step "Instalando Antigravity CLI"

    # ======================================================
    # Existing installation
    # ======================================================

    if [[ -x "$CLI_BIN" ]]; then

        warning "Antigravity CLI ya está instalado."

        info "Ejecutable:"
        echo "  $CLI_BIN"

        echo

        info "Versión:"
        "$CLI_BIN" --version || true

        # Make the binary available to this script/session.
        export PATH="$HOME/.local/bin:$PATH"

        echo

        info "Comando:"
        command -v agy || true

        finish "Antigravity CLI ya estaba instalado."

        return
    fi

    # ======================================================
    # Installation
    # ======================================================

    step "Descargando e instalando Antigravity CLI"

    curl -fsSL \
        https://antigravity.google/cli/install.sh \
        | bash

    # ======================================================
    # Verification
    # ======================================================

    step "Verificando instalación"

    if [[ ! -x "$CLI_BIN" ]]; then

        error "Antigravity CLI no quedó instalado."

        info "Se esperaba:"
        echo "  $CLI_BIN"

        exit 1
    fi

    success "Antigravity CLI instalado."

    # ======================================================
    # Current shell PATH
    # ======================================================

    export PATH="$HOME/.local/bin:$PATH"

    # ======================================================
    # Verification
    # ======================================================

    if ! command_exists agy; then

        error "Antigravity CLI está instalado, pero agy no está disponible en PATH."

        info "Ejecuta:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""

        info "Después:"
        echo "  agy"

        exit 1
    fi

    echo

    info "Ejecutable:"
    echo "  $(command -v agy)"

    echo

    info "Versión:"
    agy --version || true

    echo

    info "Instalación:"
    echo "  $CLI_BIN"

    finish "Antigravity CLI instalado correctamente."
}

main
