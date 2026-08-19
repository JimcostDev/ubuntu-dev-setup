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

INSTALL_DIR="$HOME/.local/share/antigravity"

BIN_DIR="$HOME/.local/bin"
BIN_LINK="$BIN_DIR/antigravity"

APPLICATIONS_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$APPLICATIONS_DIR/antigravity.desktop"

ICON_DIR="$HOME/.local/share/icons/hicolor/512x512/apps"
ICON_FILE="$ICON_DIR/antigravity.png"

DOWNLOAD_URL="https://storage.googleapis.com/antigravity-public/antigravity-hub/${ANTIGRAVITY_VERSION}-${ANTIGRAVITY_BUILD}/linux-x64/Antigravity.tar.gz"

# ==========================================================
# Main
# ==========================================================

main() {

    require_command curl
    require_command tar
    require_command npx

    step "Instalando Antigravity 2.0"

    # ======================================================
    # Directories
    # ======================================================

    mkdir -p "$BIN_DIR"
    mkdir -p "$APPLICATIONS_DIR"
    mkdir -p "$ICON_DIR"

    # ======================================================
    # Existing installation
    # ======================================================

    if [[ -x "$BIN_LINK" ]] &&
       [[ -f "$DESKTOP_FILE" ]] &&
       [[ -f "$ICON_FILE" ]]; then

        warning "Antigravity 2.0 ya está instalado."

        info "Ejecutable:"
        echo "  $BIN_LINK"

        info "Icono:"
        echo "  $ICON_FILE"

        info "Launcher:"
        echo "  $DESKTOP_FILE"

        finish "Antigravity 2.0 ya estaba instalado."

        return
    fi

    # ======================================================
    # Download
    # ======================================================

    step "Descargando Antigravity 2.0"

    TEMP_DIR="$(mktemp -d)"

    trap 'rm -rf "$TEMP_DIR"' EXIT

    DOWNLOAD_FILE="$TEMP_DIR/antigravity.tar.gz"

    download_file \
        "$DOWNLOAD_URL" \
        "$DOWNLOAD_FILE"

    success "Antigravity 2.0 descargado."

    # ======================================================
    # Install
    # ======================================================

    step "Extrayendo Antigravity 2.0"

    rm -rf "$INSTALL_DIR"

    mkdir -p "$INSTALL_DIR"

    tar \
        -xzf "$DOWNLOAD_FILE" \
        -C "$INSTALL_DIR" \
        --strip-components=1

    ANTIGRAVITY_BINARY="$INSTALL_DIR/antigravity"

    if [[ ! -x "$ANTIGRAVITY_BINARY" ]]; then

        error "No se encontró el ejecutable de Antigravity 2.0:"
        echo "  $ANTIGRAVITY_BINARY"

        exit 1
    fi

    success "Archivos de Antigravity 2.0 instalados."

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
    # Official icon
    # ======================================================

    step "Configurando icono de Antigravity 2.0"

    APP_ASAR="$INSTALL_DIR/resources/app.asar"

    if [[ ! -f "$APP_ASAR" ]]; then

        error "No se encontró app.asar:"
        echo "  $APP_ASAR"

        exit 1
    fi

    ICON_TEMP_DIR="$TEMP_DIR/icon"

    mkdir -p "$ICON_TEMP_DIR"

    (
        cd "$ICON_TEMP_DIR"

        npx --yes @electron/asar extract-file \
            "$APP_ASAR" \
            "icon.png"
    )

    EXTRACTED_ICON="$ICON_TEMP_DIR/icon.png"

    if [[ ! -f "$EXTRACTED_ICON" ]]; then

        error "No se pudo extraer el icono oficial de Antigravity."

        exit 1
    fi

    cp "$EXTRACTED_ICON" "$ICON_FILE"

    success "Icono oficial instalado."

    # ======================================================
    # User command
    # ======================================================

    step "Configurando comando"

    ln -sfn \
        "$ANTIGRAVITY_BINARY" \
        "$BIN_LINK"

    success "Comando configurado."

    # ======================================================
    # Desktop entry
    # ======================================================

    step "Creando acceso de escritorio"

    cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Antigravity
Comment=Google Antigravity 2.0
GenericName=Agent Command Center
Exec=$BIN_LINK %U
Icon=antigravity
Terminal=false
Type=Application
StartupNotify=true
StartupWMClass=Antigravity
Categories=Development;Utility;
MimeType=x-scheme-handler/antigravity;
EOF

    chmod +x "$DESKTOP_FILE"

    # ======================================================
    # Desktop / icon caches
    # ======================================================

    if command_exists gtk-update-icon-cache; then

        gtk-update-icon-cache \
            -f \
            -t \
            "$HOME/.local/share/icons/hicolor" \
            >/dev/null 2>&1 || true
    fi

    if command_exists update-desktop-database; then

        update-desktop-database \
            "$APPLICATIONS_DIR" \
            >/dev/null 2>&1 || true
    fi

    success "Acceso de escritorio creado."

    # ======================================================
    # Verification
    # ======================================================

    step "Verificando Antigravity 2.0"

    if [[ ! -x "$BIN_LINK" ]]; then

        error "El comando de Antigravity no quedó configurado."

        exit 1
    fi

    if [[ ! -f "$ICON_FILE" ]]; then

        error "El icono de Antigravity no quedó instalado."

        exit 1
    fi

    if [[ ! -f "$DESKTOP_FILE" ]]; then

        error "El acceso de escritorio no quedó creado."

        exit 1
    fi

    info "Ejecutable:"
    echo "  $BIN_LINK"

    echo

    info "Icono:"
    echo "  $ICON_FILE"

    echo

    info "Launcher:"
    echo "  $DESKTOP_FILE"

    echo

    info "Antigravity 2.0 se instalará como aplicación independiente."

    finish "Antigravity 2.0 instalado correctamente."
}

main
