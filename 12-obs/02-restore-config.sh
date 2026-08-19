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

BACKUP_TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
CURRENT_BACKUP="$HOME/.config/obs-studio.backup-$BACKUP_TIMESTAMP"

PROFILE_BACKUP="$BACKUP_DIR/basic/profiles/$PROFILE_NAME"
SCENE_BACKUP="$BACKUP_DIR/basic/scenes/jimcostdevcode.json"

PROFILE_DIR="$OBS_CONFIG/basic/profiles/$PROFILE_NAME"
SCENES_DIR="$OBS_CONFIG/basic/scenes"
PROFILE_FILE="$PROFILE_DIR/basic.ini"
SCENE_FILE="$SCENES_DIR/jimcostdevcode.json"

# ==========================================================
# Main
# ==========================================================

main() {

    step "Restaurando configuración de OBS Studio"

    require_command cp
    require_command jq
    require_command sed

    # ======================================================
    # OBS must be closed
    # ======================================================

    if pgrep -x obs >/dev/null 2>&1; then

        error "OBS Studio está ejecutándose."

        echo
        info "Cierra OBS Studio antes de restaurar la configuración."

        exit 1
    fi

    # ======================================================
    # Verify backup
    # ======================================================

    step "Verificando backup"

    if [[ ! -d "$BACKUP_DIR" ]]; then

        error "No se encontró el backup de OBS:"
        echo "  $BACKUP_DIR"

        exit 1
    fi

    if [[ ! -f "$PROFILE_BACKUP/basic.ini" ]]; then

        error "No se encontró el perfil de OBS:"
        echo "  $PROFILE_BACKUP/basic.ini"

        exit 1
    fi

    if [[ ! -f "$SCENE_BACKUP" ]]; then

        error "No se encontró la colección de escenas:"
        echo "  $SCENE_BACKUP"

        exit 1
    fi

    success "Backup de OBS encontrado."

    # ======================================================
    # Verify assets
    # ======================================================

    step "Verificando assets"

    if [[ ! -d "$ASSETS_DIR" ]]; then

        error "No se encontró el directorio de assets:"
        echo "  $ASSETS_DIR"

        exit 1
    fi

    success "Assets disponibles:"
    echo "  $ASSETS_DIR"

    # ======================================================
    # Backup current configuration
    # ======================================================

    if [[ -d "$OBS_CONFIG" ]]; then

        step "Respaldando configuración actual"

        cp -a \
            "$OBS_CONFIG" \
            "$CURRENT_BACKUP"

        success "Backup actual creado:"
        echo "  $CURRENT_BACKUP"

    fi

    # ======================================================
    # Create OBS directories
    # ======================================================

    mkdir -p "$PROFILE_DIR"
    mkdir -p "$SCENES_DIR"

    # ======================================================
    # Restore profile
    # ======================================================

    step "Restaurando perfil $PROFILE_NAME"

    cp \
        "$PROFILE_BACKUP/basic.ini" \
        "$PROFILE_FILE"

    # Restore encoder-specific files when available.
    for file in \
        recordEncoder.json \
        streamEncoder.json
    do
        if [[ -f "$PROFILE_BACKUP/$file" ]]; then

            cp \
                "$PROFILE_BACKUP/$file" \
                "$PROFILE_DIR/$file"

        fi
    done

    success "Perfil restaurado."

    # ======================================================
    # Adapt encoder to NVIDIA RTX 3070 Ti
    # ======================================================

    step "Adaptando encoder al AORUS"

    # Streaming encoder
    sed -i \
        's/^StreamEncoder=.*/StreamEncoder=ffmpeg_nvenc/' \
        "$PROFILE_FILE"

    # Recording encoder
    sed -i \
        's/^RecEncoder=.*/RecEncoder=ffmpeg_nvenc/' \
        "$PROFILE_FILE"

    # Advanced output streaming encoder
    sed -i \
        's/^Encoder=.*/Encoder=ffmpeg_nvenc/' \
        "$PROFILE_FILE"

    # Remove the old Intel Quick Sync encoder reference.
    sed -i \
        's/^RecEncoder=obs_qsv11_v2$/RecEncoder=ffmpeg_nvenc/' \
        "$PROFILE_FILE"

    success "Encoder configurado para NVIDIA NVENC."

    # ======================================================
    # Adapt recording paths
    # ======================================================

    step "Adaptando rutas del perfil"

    # The Acer configuration contains Windows paths.
    sed -i \
        -e 's|C:/Users/JIMCOSTDEV/Desktop/jimcostdev/videos-yt|/media/jimcostdev/data/OBS/recordings|g' \
        -e 's|C:\\\\Users\\\\JIMCOSTDEV\\\\Desktop\\\\jimcostdev\\\\videos-yt|/media/jimcostdev/data/OBS/recordings|g' \
        -e 's|C:\\\\Users\\\\JIMCOSTDEV\\\\Videos|/media/jimcostdev/data/OBS/recordings|g' \
        "$PROFILE_FILE"

    # Create a dedicated recordings directory on the data SSD.
    mkdir -p "$ASSETS_DIR/recordings"

    success "Rutas del perfil adaptadas."

    # ======================================================
    # Restore scene collection
    # ======================================================

    step "Restaurando colección de escenas"

    cp \
        "$SCENE_BACKUP" \
        "$SCENE_FILE"

    # ======================================================
    # Adapt asset paths
    # ======================================================

    step "Adaptando rutas de escenas"

    # Old Linux path from the Acer.
    sed -i \
        "s|/home/jimcostdev/Documents/OBS/|$ASSETS_DIR/|g" \
        "$SCENE_FILE"

    # Possible Windows path from the old configuration.
    sed -i \
        's|C:\\\\Users\\\\JIMCOSTDEV\\\\Documents\\\\OBS\\\\|/media/jimcostdev/data/OBS/|g' \
        "$SCENE_FILE"

    # Another possible Windows representation.
    sed -i \
        's|C:/Users/JIMCOSTDEV/Documents/OBS/|/media/jimcostdev/data/OBS/|g' \
        "$SCENE_FILE"

    success "Rutas de escenas adaptadas."

    # ======================================================
    # Adapt camera
    # ======================================================

    step "Adaptando cámara"

    jq '
        (.sources[] | select(.name == "camara") | .settings.device_id)
        = "/dev/video0"
    ' "$SCENE_FILE" > "$SCENE_FILE.tmp"

    mv \
        "$SCENE_FILE.tmp" \
        "$SCENE_FILE"

    success "Cámara configurada en /dev/video0."

    # ======================================================
    # Adapt PipeWire screen/window captures
    # ======================================================

    step "Adaptando capturas PipeWire"

    jq '
        .sources |= map(
            if .name == "full-screen" then
                .id = "pipewire-desktop-capture-source"
                | .versioned_id = "pipewire-desktop-capture-source"
                | .settings = {}
            elif .name == "vscode" then
                .id = "pipewire-window-capture-source"
                | .versioned_id = "pipewire-window-capture-source"
                | .settings = {}
            elif .name == "chrome" then
                .id = "pipewire-window-capture-source"
                | .versioned_id = "pipewire-window-capture-source"
                | .settings = {
                    "ShowCursor": true
                }
            else
                .
            end
        )
    ' "$SCENE_FILE" > "$SCENE_FILE.tmp"

    mv \
        "$SCENE_FILE.tmp" \
        "$SCENE_FILE"

    success "Capturas PipeWire adaptadas."

    info "Configuración:"
    echo "  full-screen → pipewire-desktop-capture-source"
    echo "  vscode      → pipewire-window-capture-source"
    echo "  chrome      → pipewire-window-capture-source"

    echo
    warning "Las capturas PipeWire requieren seleccionar pantalla/ventana"
    warning "la primera vez que se utilicen en este equipo."

    # ======================================================
    # Remove temporary test sources
    # ======================================================

    step "Eliminando fuentes de prueba"

    jq '
        .sources |= map(
            select(
                .name != "TEST-SCREEN"
                and .name != "TEST-WINDOW"
            )
        )
        |
        .sources |= map(
            if .id == "scene" and .settings.items then
                .settings.items |= map(
                    select(
                        .name != "TEST-SCREEN"
                        and .name != "TEST-WINDOW"
                    )
                )
            else
                .
            end
        )
    ' "$SCENE_FILE" > "$SCENE_FILE.tmp"

    mv \
        "$SCENE_FILE.tmp" \
        "$SCENE_FILE"

    success "Fuentes de prueba eliminadas."

    # ======================================================
    # Verification
    # ======================================================

    step "Verificando restauración"

    if [[ ! -f "$PROFILE_FILE" ]]; then

        error "No se encontró el perfil restaurado."

        exit 1
    fi

    if [[ ! -f "$SCENE_FILE" ]]; then

        error "No se encontró la colección de escenas restaurada."

        exit 1
    fi

    if ! jq empty "$SCENE_FILE" >/dev/null 2>&1; then

        error "La colección de escenas no contiene JSON válido."

        exit 1
    fi

    echo

    info "Configuración:"
    echo "  $OBS_CONFIG"

    echo

    info "Perfil:"
    echo "  $PROFILE_FILE"

    echo

    info "Escenas:"
    echo "  $SCENE_FILE"

    echo

    info "Assets:"
    echo "  $ASSETS_DIR"

    echo

    info "Encoder:"
    grep -E '^(Encoder|StreamEncoder|RecEncoder)=' \
        "$PROFILE_FILE" || true

    echo

    info "Cámara:"
    jq -r '
        .sources[]
        | select(.name == "camara")
        | .settings.device_id
    ' "$SCENE_FILE"

    echo

    info "Capturas:"
    jq -r '
        .sources[]
        | select(
            .name == "vscode"
            or .name == "chrome"
            or .name == "full-screen"
        )
        | "  \(.name) → \(.id) | RestoreToken: \(
            if .settings.RestoreToken then "presente"
            else "pendiente"
            end
        )"
    ' "$SCENE_FILE"

    echo

    if jq -e '
        .sources[]
        | select(
            .name == "vscode"
            or .name == "chrome"
            or .name == "full-screen"
        )
        | select(.settings.RestoreToken != null)
    ' "$SCENE_FILE" >/dev/null 2>&1; then

        error "Todavía existen RestoreToken heredados."

        exit 1
    fi

    # ======================================================
    # Final
    # ======================================================

    finish "Configuración de OBS restaurada y adaptada al AORUS."
}

main
