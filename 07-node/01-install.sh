#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/lib/utils.sh"

load_config

install_nvm() {

    if directory_exists "$HOME/.nvm"; then
        warning "NVM ya está instalado."
        return
    fi

    step "Instalando NVM"

    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

    success "NVM instalado."
}

install_node() {

    step "Instalando Node.js"

    export NVM_DIR="$HOME/.nvm"

    # shellcheck disable=SC1091
    source "$NVM_DIR/nvm.sh"

    nvm install "$NODE_VERSION"

    nvm alias default "$NODE_VERSION"

    nvm use default

    success "Node.js instalado."
}

main() {

    require_sudo

    install_nvm

    install_node

    finish "Instalación completada."
}

main