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

OBS_CONFIG="$HOME/.config/obs-studio"

BACKUP_DIR="/media/jimcostdev/data/OBS/obs-studio"
ASSETS_DIR="/media/jimcostdev/data/OBS"

PROFILE_NAME="jimcostdev"

PROFILE_FILE="$OBS_CONFIG/basic/profiles/$PROFILE_NAME/basic.ini"
SCENE_FILE="$OBS_CONFIG/basic/scenes/jimcostdevcode.json"

# ==========================================================
# Main
# ==========================================================

main() {

    step "Verificando OBS Studio"

    require_command obs
    require_command jq
    require_command grep

    INSTALLATION_OK=true

    # ======================================================
    # OBS installation
    # ======================================================

    step "OBS Studio"

    if command_exists obs; then

        success "OBS Studio está instalado."

        info "Ejecutable:"
        echo "  $(command -v obs)"

        echo

        info "Versión:"
        obs --version 2>/dev/null || true

    else

        error "OBS Studio no está instalado."

        INSTALLATION_OK=false
    fi

    # ======================================================
    # Configuration
    # ======================================================

    step "Configuración"

    if [[ -d "$OBS_CONFIG" ]]; then

        success "Configuración de OBS encontrada."

        info "Ubicación:"
        echo "  $OBS_CONFIG"

    else

        error "No se encontró la configuración de OBS."

        INSTALLATION_OK=false
    fi

    # ======================================================
    # Profile
    # ======================================================

    step "Perfil"

    if [[ -f "$PROFILE_FILE" ]]; then

        success "Perfil $PROFILE_NAME encontrado."

        info "Perfil:"
        echo "  $PROFILE_FILE"

    else

        error "No se encontró el perfil:"
        echo "  $PROFILE_FILE"

        INSTALLATION_OK=false
    fi

    # ======================================================
    # Scene collection
    # ======================================================

    step "Colección de escenas"

    if [[ -f "$SCENE_FILE" ]]; then

        if jq empty "$SCENE_FILE" >/dev/null 2>&1; then

            success "Colección de escenas válida."

            info "Colección:"
            echo "  $SCENE_FILE"

        else

            error "La colección de escenas no contiene JSON válido."

            INSTALLATION_OK=false
        fi

    else

        error "No se encontró la colección de escenas."

        INSTALLATION_OK=false
    fi

    # ======================================================
    # Assets
    # ======================================================

    step "Assets"

    if [[ -d "$ASSETS_DIR" ]]; then

        success "Assets disponibles."

        info "Ubicación:"
        echo "  $ASSETS_DIR"

    else

        error "No se encontró el directorio de assets."

        INSTALLATION_OK=false
    fi

    # ======================================================
    # NVIDIA NVENC
    # ======================================================

    step "Encoder NVIDIA NVENC"

    if [[ -f "$PROFILE_FILE" ]]; then

        if grep -Eq \
            '^(StreamEncoder|RecEncoder|Encoder)=ffmpeg_nvenc' \
            "$PROFILE_FILE"; then

            success "OBS está configurado para NVIDIA NVENC."

            grep -E \
                '^(StreamEncoder|RecEncoder|Encoder)=' \
                "$PROFILE_FILE" \
                | sed 's/^/  /'

        else

            error "No se encontró configuración NVENC."

            INSTALLATION_OK=false
        fi

    fi

    # ======================================================
    # Camera
    # ======================================================

    step "Cámara"

    CAMERA_DEVICE="/dev/video0"

    if [[ -e "$CAMERA_DEVICE" ]]; then

        success "Cámara disponible."

        info "Dispositivo:"
        echo "  $CAMERA_DEVICE"

    else

        warning "No se encontró $CAMERA_DEVICE."

        INSTALLATION_OK=false
    fi

    # ======================================================
    # Scene sources
    # ======================================================

    step "Fuentes de captura"

    if [[ -f "$SCENE_FILE" ]]; then

        REQUIRED_SOURCES=(
            "camara"
            "micro"
            "vscode"
            "full-screen"
            "chrome"
        )

        for source in "${REQUIRED_SOURCES[@]}"; do

            if jq -e \
                --arg name "$source" \
                '.sources[] | select(.name == $name)' \
                "$SCENE_FILE" >/dev/null 2>&1; then

                success "Fuente encontrada: $source"

            else

                error "Falta la fuente: $source"

                INSTALLATION_OK=false
            fi

        done

    fi

    # ======================================================
    # PipeWire captures
    # ======================================================

    step "Capturas PipeWire"

    if [[ -f "$SCENE_FILE" ]]; then

        if jq -e '
            .sources[]
            | select(.name == "full-screen")
            | .id == "pipewire-desktop-capture-source"
        ' "$SCENE_FILE" >/dev/null 2>&1; then

            success "Captura de pantalla configurada."

        else

            error "La fuente full-screen no está configurada correctamente."

            INSTALLATION_OK=false
        fi

        if jq -e '
            .sources[]
            | select(.name == "vscode")
            | .id == "pipewire-window-capture-source"
        ' "$SCENE_FILE" >/dev/null 2>&1; then

            success "Captura de VS Code configurada."

        else

            error "La fuente vscode no está configurada correctamente."

            INSTALLATION_OK=false
        fi

        if jq -e '
            .sources[]
            | select(.name == "chrome")
            | .id == "pipewire-window-capture-source"
        ' "$SCENE_FILE" >/dev/null 2>&1; then

            success "Captura de Chrome configurada."

        else

            error "La fuente chrome no está configurada correctamente."

            INSTALLATION_OK=false
        fi

    fi

    # ======================================================
    # Old RestoreTokens
    # ======================================================

    step "RestoreTokens"

    if [[ -f "$SCENE_FILE" ]]; then

        if jq -e '
            [
                .sources[]
                | select(
                    .name == "vscode"
                    or .name == "full-screen"
                    or .name == "chrome"
                )
                | .settings.RestoreToken?
            ]
            | any(. != null)
        ' "$SCENE_FILE" >/dev/null 2>&1; then

            warning "Existen RestoreToken en las fuentes PipeWire."

            warning "Esto puede requerir volver a seleccionar pantalla/ventana."

        else

            success "No existen RestoreToken heredados."

        fi

    fi

    # ======================================================
    # Test sources
    # ======================================================

    step "Fuentes de prueba"

    if [[ -f "$SCENE_FILE" ]]; then

        if jq -e '
            .sources[]
            | select(
                .name == "TEST-SCREEN"
                or .name == "TEST-WINDOW"
            )
        ' "$SCENE_FILE" >/dev/null 2>&1; then

            warning "Todavía existen fuentes de prueba."

        else

            success "No existen fuentes de prueba."

        fi

    fi

    # ======================================================
    # Final information
    # ======================================================

    echo

    step "Resumen"

    echo "OBS Studio:"
    echo "  $(command -v obs)"

    echo

    echo "Configuración:"
    echo "  $OBS_CONFIG"

    echo

    echo "Perfil:"
    echo "  $PROFILE_FILE"

    echo

    echo "Escenas:"
    echo "  $SCENE_FILE"

    echo

    echo "Assets:"
    echo "  $ASSETS_DIR"

    echo

    echo "Backup original:"
    echo "  $BACKUP_DIR"

    # ======================================================
    # Final validation
    # ======================================================

    echo

    if [[ "$INSTALLATION_OK" != true ]]; then

        error "La configuración de OBS está incompleta."

        exit 1
    fi

    finish "OBS Studio configurado correctamente."
}

main
