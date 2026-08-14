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

step "Instalando Docker"

if command_exists docker; then
    warning "Docker ya está instalado."
    docker --version
    exit 0
fi

info "Eliminando versiones antiguas de Docker..."

OLD_PACKAGES=(
    docker.io
    docker-doc
    docker-compose
    docker-compose-v2
    podman-docker
    containerd
    runc
)

for pkg in "${OLD_PACKAGES[@]}"; do
    if dpkg -s "$pkg" &>/dev/null; then
        sudo apt remove -y "$pkg"
    fi
done

info "Instalando dependencias..."

sudo apt update

sudo apt install -y \
    ca-certificates \
    curl \
    gnupg

info "Configurando repositorio oficial de Docker..."

sudo install -m 0755 -d /etc/apt/keyrings

if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update

info "Instalando Docker Engine..."

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

info "Iniciando servicio Docker..."

sudo systemctl enable docker
sudo systemctl start docker

success "Docker instalado correctamente."

docker --version
docker compose version