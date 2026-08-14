#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/lib/utils.sh"

step "Ubuntu Dev Setup"

info "Buscando módulos..."

for module in $(find . -maxdepth 1 -type d | sort); do

    module="${module#./}"

    [[ "$module" == "." ]] && continue
    [[ "$module" == "lib" ]] && continue
    [[ "$module" == ".git" ]] && continue

    if [[ "$module" =~ ^[0-9]{2}- ]]; then

        info "Ejecutando módulo: $module"

        for script in "$module"/*.sh; do

            [[ -f "$script" ]] || continue

            info "Ejecutando $(basename "$script")"

            bash "$script"

        done

    fi

done

success "Ubuntu Dev Setup finalizado."