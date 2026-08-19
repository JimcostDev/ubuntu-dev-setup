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

BIN_DIR="$HOME/.local/bin"

IDE_BIN="$BIN_DIR/antigravity-ide"
ANTIGRAVITY_BIN="$BIN_DIR/antigravity"
CLI_BIN="$BIN_DIR/agy"

IDE_DIR="$HOME/.local/share/antigravity-ide"
ANTIGRAVITY_DIR="$HOME/.local/share/antigravity"

APPLICATIONS_DIR="$HOME/.local/share/applications"

IDE_DESKTOP="$APPLICATIONS_DIR/antigravity-ide.desktop"
ANTIGRAVITY_DESKTOP="$APPLICATIONS_DIR/antigravity.desktop"

ANTIGRAVITY_ICON="$HOME/.local/share/icons/hicolor/512x512/apps/antigravity.png"

# ==========================================================
# Main
# ==========================================================

main() {

    step "Verificando Antigravity"

    # Make locally installed commands available to this process.
    export PATH="$BIN_DIR:$PATH"

    INSTALLATION_OK=true

    # ======================================================
    # Antigravity IDE
    # ======================================================

    step "Antigravity IDE"

    if [[ -x "$IDE_BIN" ]]; then

        success "Antigravity IDE está instalado."

        info "Ejecutable:"
        echo "  $IDE_BIN"

        echo

        info "Launcher:"
        echo "  $IDE_DESKTOP"

    else

        error "Antigravity IDE no está instalado."

        INSTALLATION_OK=false
    fi

    # ======================================================
    # Antigravity 2.0
    # ======================================================

    step "Antigravity 2.0"

    if [[ -x "$ANTIGRAVITY_BIN" ]]; then

        success "Antigravity 2.0 está instalado."

        info "Ejecutable:"
        echo "  $ANTIGRAVITY_BIN"

        echo

        info "Launcher:"
        echo "  $ANTIGRAVITY_DESKTOP"

    else

        error "Antigravity 2.0 no está instalado."

        INSTALLATION_OK=false
    fi

    # ======================================================
    # Antigravity CLI
    # ======================================================

    step "Antigravity CLI"

    if [[ -x "$CLI_BIN" ]]; then

        success "Antigravity CLI está instalado."

        info "Ejecutable:"
        echo "  $CLI_BIN"

        echo

        info "Versión:"
        "$CLI_BIN" --version 2>/dev/null || true

    else

        error "Antigravity CLI no está instalado."

        INSTALLATION_OK=false
    fi

    # ======================================================
    # Desktop integration
    # ======================================================

    step "Integración de escritorio"

    if [[ -f "$IDE_DESKTOP" ]]; then
        success "Launcher de Antigravity IDE encontrado."
    else
        error "No se encontró el launcher de Antigravity IDE."
        INSTALLATION_OK=false
    fi

    if [[ -f "$ANTIGRAVITY_DESKTOP" ]]; then
        success "Launcher de Antigravity 2.0 encontrado."
    else
        error "No se encontró el launcher de Antigravity 2.0."
        INSTALLATION_OK=false
    fi

    if [[ -f "$ANTIGRAVITY_ICON" ]]; then
        success "Icono de Antigravity 2.0 encontrado."
    else
        error "No se encontró el icono de Antigravity 2.0."
        INSTALLATION_OK=false
    fi

    # ======================================================
    # Desktop entries validation
    # ======================================================

    if command_exists desktop-file-validate; then

        if [[ -f "$IDE_DESKTOP" ]]; then
            desktop-file-validate "$IDE_DESKTOP" || INSTALLATION_OK=false
        fi

        if [[ -f "$ANTIGRAVITY_DESKTOP" ]]; then
            desktop-file-validate "$ANTIGRAVITY_DESKTOP" || INSTALLATION_OK=false
        fi

    fi

    # ======================================================
    # Commands
    # ======================================================

    echo

    step "Comandos disponibles"

    if command_exists antigravity-ide; then
        success "antigravity-ide disponible."
    else
        error "antigravity-ide no está disponible."
        INSTALLATION_OK=false
    fi

    if command_exists antigravity; then
        success "antigravity disponible."
    else
        error "antigravity no está disponible."
        INSTALLATION_OK=false
    fi

    if command_exists agy; then
        success "agy disponible."
    else
        error "agy no está disponible."
        INSTALLATION_OK=false
    fi

    # ======================================================
    # Locations
    # ======================================================

    echo

    step "Ubicaciones"

    echo "Antigravity IDE:"
    echo "  $IDE_DIR"

    echo

    echo "Antigravity 2.0:"
    echo "  $ANTIGRAVITY_DIR"

    echo

    echo "Antigravity CLI:"
    echo "  $CLI_BIN"

    echo

    echo "Launchers:"
    echo "  $IDE_DESKTOP"
    echo "  $ANTIGRAVITY_DESKTOP"

    echo

    echo "Icono:"
    echo "  $ANTIGRAVITY_ICON"

    # ======================================================
    # Final validation
    # ======================================================

    echo

    if [[ "$INSTALLATION_OK" != true ]]; then

        error "La configuración de Antigravity está incompleta."

        exit 1
    fi

    finish "Antigravity configurado correctamente."
}

main
