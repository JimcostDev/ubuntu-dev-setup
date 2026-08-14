#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/lib/utils.sh"

load_config

step "Actualizando índices de paquetes"

sudo apt update

step "Actualizando el sistema"

sudo apt full-upgrade -y

success "Sistema actualizado correctamente."