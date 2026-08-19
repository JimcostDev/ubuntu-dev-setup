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

PROFILE="$HOME/.profile"

step "Configurando Go"

mkdir -p "$HOME/go"/{bin,pkg,src}

append_line_if_missing "" "$PROFILE"
append_line_if_missing "# Go" "$PROFILE"
append_line_if_missing "export GOROOT=/usr/local/go" "$PROFILE"
append_line_if_missing "export GOPATH=\$HOME/go" "$PROFILE"
append_line_if_missing "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" "$PROFILE"

success "Variables de entorno configuradas."

echo

warning "Recarga el perfil o abre una nueva terminal."

echo

info "También puedes ejecutar:"

echo

echo "source ~/.profile"

echo

success "Configuración completada."