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

step "Configurando Git"

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

git config --global init.defaultBranch main
git config --global core.editor "code --wait"
git config --global pull.rebase false
git config --global fetch.prune true
git config --global color.ui auto

success "Git configurado correctamente."

echo
info "Configuración actual de Git:"

git config --global --list