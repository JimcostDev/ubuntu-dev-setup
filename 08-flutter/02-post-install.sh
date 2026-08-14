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
# Detect shell profile
# ==========================================================

if [[ "$SHELL" == */zsh ]]; then
    PROFILE="$HOME/.zshrc"
else
    PROFILE="$HOME/.profile"
fi

# ==========================================================
# Main
# ==========================================================

step "Configurando Flutter"

if ! directory_exists "$FLUTTER_INSTALL_DIR"; then
    error "Flutter no está instalado."
    exit 1
fi

append_line_if_missing "" "$PROFILE"
append_line_if_missing "# Flutter SDK" "$PROFILE"

replace_or_append \
    "export PATH=.*development/flutter.*" \
    "export PATH=\"$FLUTTER_INSTALL_DIR/bin:\$PATH\"" \
    "$PROFILE"

step "Habilitando Linux Desktop"

"$FLUTTER_INSTALL_DIR/bin/flutter" config --enable-linux-desktop

step "Verificando instalación"

"$FLUTTER_INSTALL_DIR/bin/flutter" --version

echo

"$FLUTTER_INSTALL_DIR/bin/dart" --version

echo

"$FLUTTER_INSTALL_DIR/bin/flutter" doctor

echo

info "Configuración añadida en:"
echo "  $PROFILE"

echo

info "Abre una nueva terminal o ejecuta:"
echo "  source $PROFILE"

finish "Flutter configurado correctamente."
