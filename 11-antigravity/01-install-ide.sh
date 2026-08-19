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

INSTALL_DIR="$HOME/.local/share/antigravity-ide"
BIN_DIR="$HOME/.local/bin"
BIN_LINK="$BIN_DIR/antigravity-ide"

APPLICATIONS_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$APPLICATIONS_DIR/antigravity-ide.desktop"

DOWNLOAD_URL="https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/${ANTIGRAVITY_IDE_VERSION}-${ANTIGRAVITY_IDE_BUILD}/${ANTIGRAVITY_IDE_ARCH}/Antigravity%20IDE.tar.gz"

ICON_PATH="$INSTALL_DIR/resources/app/resources/linux/code.png"

# ==========================================================
# Main
# ==========================================================

main() {

    require_command curl
    require_command tar

    step "Instalando Antigravity IDE"

    # ======================================================
    # Directories
    # ======================================================

    mkdir -p "$BIN_DIR"
    mkdir -p "$APPLICATIONS_DIR"

    # ======================================================
    # Existing installation
    # ======================================================

    if [[ -x "$BIN_LINK" ]] && [[ -f "$DESKTOP_FILE" ]]; then

        warning "Antigravity IDE ya está instalado."

        info "Ejecutable:"
        echo "  $BIN_LINK"

        finish "Antigravity IDE ya estaba instalado."

        return
    fi

    # ======================================================
    # Download
    # ======================================================

    step "Descargando Antigravity IDE"

    TEMP_DIR="$(mktemp -d)"

    trap 'rm -rf "$TEMP_DIR"' EXIT

    DOWNLOAD_FILE="$TEMP_DIR/antigravity-ide.tar.gz"

    download_file \
        "$DOWNLOAD_URL" \
        "$DOWNLOAD_FILE"

    success "Antigravity IDE descargado."

    # ======================================================
    # Install
    # ======================================================

    step "Extrayendo Antigravity IDE"

    rm -rf "$INSTALL_DIR"

    mkdir -p "$INSTALL_DIR"

    tar \
        -xzf "$DOWNLOAD_FILE" \
        -C "$INSTALL_DIR" \
        --strip-components=1

    IDE_BINARY="$INSTALL_DIR/antigravity-ide"

    if [[ ! -x "$IDE_BINARY" ]]; then

        error "No se encontró el ejecutable de Antigravity IDE:"
        echo "  $IDE_BINARY"

        exit 1
    fi

    success "Archivos de Antigravity IDE instalados."

    # ======================================================
    # Chrome sandbox
    # ======================================================

    SANDBOX="$INSTALL_DIR/chrome-sandbox"

    if [[ ! -f "$SANDBOX" ]]; then

        error "No se encontró chrome-sandbox:"
        echo "  $SANDBOX"

        exit 1
    fi

    step "Configurando Chrome sandbox"

    sudo chown root:root "$SANDBOX"
    sudo chmod 4755 "$SANDBOX"

    success "Chrome sandbox configurado."

    # ======================================================
    # User command
    # ======================================================

    step "Configurando comando"

    ln -sfn \
        "$IDE_BINARY" \
        "$BIN_LINK"

    if [[ ! -x "$BIN_LINK" ]]; then

        error "No se pudo crear el comando:"
        echo "  $BIN_LINK"

        exit 1
    fi

    success "Comando configurado."

    # ======================================================
    # Desktop entry
    # ======================================================

    step "Creando acceso de escritorio"

    if [[ ! -f "$ICON_PATH" ]]; then

        error "No se encontró el icono de Antigravity IDE:"
        echo "  $ICON_PATH"

        exit 1
    fi

    cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Antigravity IDE
Comment=Google Antigravity IDE
GenericName=Integrated Development Environment
Exec=$BIN_LINK %F
Icon=$ICON_PATH
Terminal=false
Type=Application
StartupNotify=true
Categories=Development;IDE;TextEditor;
EOF

    chmod +x "$DESKTOP_FILE"

    if command_exists update-desktop-database; then
        update-desktop-database "$APPLICATIONS_DIR" >/dev/null 2>&1 || true
    fi

    success "Acceso de escritorio creado."

    # ======================================================
    # Verification
    # ======================================================

    step "Verificando instalación"

    if [[ ! -x "$BIN_LINK" ]]; then

        error "Antigravity IDE no quedó instalado correctamente."

        exit 1
    fi

    info "Ejecutable:"
    echo "  $BIN_LINK"

    echo

    info "Versión:"
    "$BIN_LINK" --version || true

    echo

    info "Launcher:"
    echo "  $DESKTOP_FILE"

    echo

    info "Icono:"
    echo "  $ICON_PATH"

    finish "Antigravity IDE instalado correctamente."
}

main
