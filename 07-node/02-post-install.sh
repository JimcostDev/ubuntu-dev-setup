#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/lib/utils.sh"

load_config

PROFILE="$HOME/.profile"

step "Configurando Node.js"

append_line_if_missing "" "$PROFILE"
append_line_if_missing "# NVM" "$PROFILE"
append_line_if_missing 'export NVM_DIR="$HOME/.nvm"' "$PROFILE"
append_line_if_missing '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' "$PROFILE"

source "$PROFILE"

corepack enable

success "NVM configurado."

echo

step "Verificando instalación"

node -v
npm -v
npx -v
corepack --version

echo

success "Node.js configurado correctamente."

finish "Configuración completada."