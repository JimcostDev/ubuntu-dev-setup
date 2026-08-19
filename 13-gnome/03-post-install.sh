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

KEYBINDINGS_SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
CUSTOM_SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"

# ==========================================================
# Functions
# ==========================================================

get_custom_keybindings() {

    gsettings get \
        "$KEYBINDINGS_SCHEMA" \
        custom-keybindings
}

get_custom_paths() {

    get_custom_keybindings |
        grep -oE "'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom[0-9]+/'" |
        tr -d "'"
}

check_keybinding() {

    local name="$1"
    local command="$2"
    local binding="$3"

    local found=false

    while IFS= read -r path; do

        [[ -z "$path" ]] && continue

        local current_name
        local current_command
        local current_binding

        current_name="$(
            gsettings get \
                "${CUSTOM_SCHEMA}:${path}" \
                name 2>/dev/null |
                tr -d "'"
        )"

        current_command="$(
            gsettings get \
                "${CUSTOM_SCHEMA}:${path}" \
                command 2>/dev/null |
                tr -d "'"
        )"

        current_binding="$(
            gsettings get \
                "${CUSTOM_SCHEMA}:${path}" \
                binding 2>/dev/null |
                tr -d "'"
        )"

        if [[ "$current_name" == "$name" ]] &&
           [[ "$current_command" == "$command" ]] &&
           [[ "$current_binding" == "$binding" ]]; then

            found=true

            break
        fi

    done < <(get_custom_paths)

    if [[ "$found" == true ]]; then

        success "$name → $binding"

        return 0

    else

        error "$name no está configurado correctamente."

        return 1
    fi
}

# ==========================================================
# Main
# ==========================================================

main() {

    step "Verificando configuración de GNOME"

    require_command gsettings
    require_command gnome-shell

    # ======================================================
    # GNOME
    # ======================================================

    step "GNOME"

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

    step "Versión de GNOME"

    GNOME_VERSION="$(
        gnome-shell --version |
        awk '{print $3}'
    )"

    info "GNOME Shell:"
    echo "  $GNOME_VERSION"

    # ======================================================
    # GNOME Commands
    # ======================================================

    step "Herramientas de GNOME"

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

        error "Faltan herramientas necesarias."

        exit 1
    fi

    # ======================================================
    # Keybindings
    # ======================================================

    step "Atajos de teclado"

    local keybindings_ok=true

    check_keybinding \
        "Open Files" \
        "nautilus" \
        "<Super>e" || keybindings_ok=false

    check_keybinding \
        "Power Menu" \
        "gnome-session-quit --power-off" \
        "<Super>x" || keybindings_ok=false

    check_keybinding \
        "Terminal" \
        "gnome-terminal" \
        "<Super>t" || keybindings_ok=false

    check_keybinding \
        "Task" \
        "gnome-system-monitor" \
        "<Shift><Control>Escape" || keybindings_ok=false

    if [[ "$keybindings_ok" != true ]]; then

        error "Uno o más atajos no están configurados correctamente."

        exit 1
    fi

    # ======================================================
    # Super + V
    # ======================================================

    step "Super + V"

    info "Super + V mantiene el comportamiento original de GNOME."

    # ======================================================
    # Summary
    # ======================================================

    echo

    info "Resumen"
    echo

    echo "  GNOME Shell:"
    echo "    $GNOME_VERSION"

    echo

    echo "  Atajos:"
    echo "    Super + E           → Archivos"
    echo "    Super + X           → Power Menu"
    echo "    Super + T           → Terminal"
    echo "    Ctrl + Shift + Esc  → Monitor del sistema"
    echo "    Super + V           → Comportamiento original de GNOME"

    echo

    echo "  Herramientas:"
    echo "    Nautilus"
    echo "    GNOME Terminal"
    echo "    GNOME System Monitor"
    echo "    GNOME Session"

    finish "GNOME configurado correctamente."
}

main
