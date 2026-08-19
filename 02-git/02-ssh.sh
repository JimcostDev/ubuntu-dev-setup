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
# Main
# ==========================================================

step "Comprobando clave SSH"

if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
    warning "Ya existe una clave SSH."
else
    info "Generando clave SSH..."

    ssh-keygen \
        -t ed25519 \
        -C "$GIT_EMAIL" \
        -f "$HOME/.ssh/id_ed25519" \
        -N ""

    success "Clave SSH creada correctamente."
fi

step "Clave pública"

cat "$HOME/.ssh/id_ed25519.pub"

echo
warning "Copia la clave anterior y añádela a GitHub."
info "GitHub → Settings → SSH and GPG keys → New SSH key"

echo
read -rp "Pulsa Enter cuando hayas añadido la clave en GitHub..."

step "Probando conexión con GitHub"

# Github returns exit code 1 even on successful authentication
# so we must check the output instead of the exit code.
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    success "Conexión a GitHub verificada."
else
    warning "No se pudo verificar la conexión con GitHub. Comprueba que la clave pública esté añadida en GitHub."
fi

success "Configuración SSH finalizada."