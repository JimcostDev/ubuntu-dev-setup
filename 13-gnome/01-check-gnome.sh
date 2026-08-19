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

    step "Verificando GNOME y herramientas"

    require_command gsettings
    require_command gnome-shell

    # ======================================================
    # GNOME
    # ======================================================

    step "Verificando GNOME"

    if [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]] ||
       [[ "${XDG_CURRENT_DESKTOP:-}" == *ubuntu:GNOME* ]] ||
       command_exists gnome-shell; then

        success "GNOME está disponible."

    else

        error "No se detectó GNOME."

        exit 1
    fi

    # ======================================================
    # GNOME Version
    # ======================================================

    step "Verificando versión de GNOME"

    GNOME_VERSION="$(
        gnome-shell --version |
        awk '{print $3}'
    )"

    if [[ "$GNOME_VERSION" == "46.0" ]]; then

        success "GNOME Shell $GNOME_VERSION detectado."

    else

        warning "Se detectó GNOME Shell $GNOME_VERSION."

    fi

    # ======================================================
    # GNOME Commands
    # ======================================================

    step "Verificando comandos de GNOME"

    local verification_ok=true

    if command_exists nautilus; then
        success "Nautilus disponible."
    else
        error "Nautilus no está disponible."
        verification_ok=false
    fi

    if command_exists gnome-terminal; then
        success "GNOME Terminal disponible."
    else
        error "GNOME Terminal no está disponible."
        verification_ok=false
    fi

    if command_exists gnome-system-monitor; then
        success "GNOME System Monitor disponible."
    else
        error "GNOME System Monitor no está disponible."
        verification_ok=false
    fi

    if command_exists gnome-session-quit; then
        success "gnome-session-quit disponible."
    else
        error "gnome-session-quit no está disponible."
        verification_ok=false
    fi

    if [[ "$verification_ok" != true ]]; then

        error "Faltan comandos necesarios de GNOME."

        exit 1
    fi

    # ======================================================
    # Final Summary
    # ======================================================

    echo

    info "Entorno:"
    echo "  ${XDG_CURRENT_DESKTOP:-GNOME}"

    echo

    info "GNOME Shell:"
    echo "  $GNOME_VERSION"

    echo

    info "Herramientas:"
    echo "  Nautilus"
    echo "  GNOME Terminal"
    echo "  GNOME System Monitor"
    echo "  GNOME Session"

    echo

    info "Atajos que configurará el siguiente script:"
    echo "  Super + E           → Archivos"
    echo "  Super + X           → Power Menu"
    echo "  Super + T           → Terminal"
    echo "  Ctrl + Shift + Esc  → Monitor del sistema"

    finish "GNOME y herramientas requeridas verificadas correctamente."
}

main
