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

find_keybinding_path() {

    local name="$1"
    local command="$2"
    local binding="$3"

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

            echo "$path"

            return 0
        fi

    done < <(get_custom_paths)

    return 1
}

get_next_custom_index() {

    local index=0

    while get_custom_paths |
          grep -Fxq \
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${index}/"; do

        ((index++))

    done

    echo "$index"
}

add_or_update_keybinding() {

    local name="$1"
    local command="$2"
    local binding="$3"

    local path

    # ------------------------------------------------------
    # Check whether the exact keybinding already exists
    # ------------------------------------------------------

    if path="$(find_keybinding_path "$name" "$command" "$binding")"; then

        success "$name ya está configurado."

        return
    fi

    # ------------------------------------------------------
    # Search for another custom binding using the same key
    # ------------------------------------------------------

    while IFS= read -r existing_path; do

        [[ -z "$existing_path" ]] && continue

        local existing_binding

        existing_binding="$(
            gsettings get \
                "${CUSTOM_SCHEMA}:${existing_path}" \
                binding 2>/dev/null |
                tr -d "'"
        )"

        if [[ "$existing_binding" == "$binding" ]]; then

            gsettings set \
                "${CUSTOM_SCHEMA}:${existing_path}" \
                name \
                "$name"

            gsettings set \
                "${CUSTOM_SCHEMA}:${existing_path}" \
                command \
                "$command"

            success "$name actualizado."

            return
        fi

    done < <(get_custom_paths)

    # ------------------------------------------------------
    # Create new custom keybinding
    # ------------------------------------------------------

    local index
    index="$(get_next_custom_index)"

    path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${index}/"

    local keybindings

    keybindings="$(get_custom_keybindings)"

    keybindings="${keybindings%]}"

    if [[ "$keybindings" == "[]" ]]; then

        keybindings="['$path']"

    else

        keybindings="$keybindings, '$path']"

    fi

    gsettings set \
        "$KEYBINDINGS_SCHEMA" \
        custom-keybindings \
        "$keybindings"

    gsettings set \
        "${CUSTOM_SCHEMA}:${path}" \
        name \
        "$name"

    gsettings set \
        "${CUSTOM_SCHEMA}:${path}" \
        command \
        "$command"

    gsettings set \
        "${CUSTOM_SCHEMA}:${path}" \
        binding \
        "$binding"

    success "$name configurado."
}

# ==========================================================
# Main
# ==========================================================

main() {

    step "Configurando atajos de teclado de GNOME"

    require_command gsettings

    # ======================================================
    # Super + E
    # ======================================================

    step "Super + E"

    add_or_update_keybinding \
        "Open Files" \
        "nautilus" \
        "<Super>e"

    # ======================================================
    # Super + X
    # ======================================================

    step "Super + X"

    add_or_update_keybinding \
        "Power Menu" \
        "gnome-session-quit --power-off" \
        "<Super>x"

    # ======================================================
    # Super + T
    # ======================================================

    step "Super + T"

    add_or_update_keybinding \
        "Terminal" \
        "gnome-terminal" \
        "<Super>t"

    # ======================================================
    # Ctrl + Shift + Esc
    # ======================================================

    step "Ctrl + Shift + Esc"

    add_or_update_keybinding \
        "Task" \
        "gnome-system-monitor" \
        "<Shift><Control>Escape"

    # ======================================================
    # Summary
    # ======================================================

    echo

    info "Atajos configurados:"

    echo "  Super + E           → Archivos"
    echo "  Super + X           → Power Menu"
    echo "  Super + T           → Terminal"
    echo "  Ctrl + Shift + Esc  → Monitor del sistema"

    echo

    info "Super + V:"
    echo "  → Se mantiene con el comportamiento original de GNOME."

    finish "Atajos de teclado configurados correctamente."
}

main
