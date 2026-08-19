#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/lib/utils.sh"

step "Ubuntu Dev Setup"

info "Ejecutando instalación base..."

for module in $(find . -maxdepth 1 -type d | sort); do

    module="${module#./}"

    # Ignorar directorios no correspondientes a módulos automáticos
    [[ "$module" == "." || "$module" == "lib" || "$module" == ".git" || "$module" == ".agents" ]] && continue
    
    # Ignorar módulos interactivos o que dependen de hardware/sesión gráfica específica
    [[ "$module" == "12-obs" || "$module" == "13-gnome" ]] && continue

    if [[ "$module" =~ ^[0-9]{2}- ]]; then

        info "Módulo: $module"

        for script in "$module"/*.sh; do

            [[ -f "$script" ]] || continue

            # Ignorar script SSH interactivo (requiere intervención del usuario)
            [[ "$script" == *"02-ssh.sh" ]] && continue

            info "Ejecutando $(basename "$script")"

            bash "$script"

        done

    fi

done

echo
step "Pasos manuales pendientes"
info "La instalación automática ha terminado. Por favor, realiza los siguientes pasos:"
echo "1. Ejecuta ./02-git/02-ssh.sh para configurar tu clave SSH en GitHub."
echo "2. Cierra sesión y vuelve a entrar (logout/login) para aplicar el grupo 'docker'."
echo "3. Ejecuta ./12-obs/ (asegúrate de tener el backup en disco y cámara conectada)."
echo "4. Ejecuta ./13-gnome/ desde una sesión gráfica en GNOME para aplicar los atajos."
echo "5. Recarga tu terminal o ejecuta 'source ~/.profile' para aplicar cambios en variables."
echo

success "Ubuntu Dev Setup finalizado."