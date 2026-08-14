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

step "Configurando Docker"

# Crear el grupo docker si no existe
if ! getent group docker >/dev/null; then
    info "Creando grupo docker..."
    sudo groupadd docker
fi

# Agregar el usuario al grupo docker
info "Agregando el usuario '$USER' al grupo docker..."

sudo usermod -aG docker "$USER"

# Verificar que el usuario fue agregado correctamente
if grep -q "^docker:.*\b$USER\b" /etc/group; then
    success "Usuario agregado correctamente al grupo docker."
else
    error "No fue posible agregar el usuario al grupo docker."
    exit 1
fi

echo

step "Verificando servicio Docker"

# Comprobar si Docker está activo
if systemctl is-active --quiet docker; then
    success "El servicio Docker está en ejecución."
else
    warning "El servicio Docker no estaba iniciado."

    info "Iniciando servicio Docker..."

    sudo systemctl start docker

    if systemctl is-active --quiet docker; then
        success "Servicio Docker iniciado correctamente."
    else
        error "No fue posible iniciar el servicio Docker."
        exit 1
    fi
fi

echo

warning "Es necesario cerrar sesión y volver a iniciarla para aplicar el grupo 'docker'."

echo

step "Próximos pasos"

info "Después de volver a iniciar sesión ejecuta:"

echo
echo "    docker run hello-world"
echo

info "Si aparece el mensaje de bienvenida de Docker, la instalación habrá finalizado correctamente."

success "Configuración de Docker completada."