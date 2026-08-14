#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "=============================================="
echo "     Ubuntu Dev Setup - Bootstrap"
echo "=============================================="
echo

echo "[INFO] Concediendo permisos de ejecución..."

find "$SCRIPT_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo
echo "[ OK ] Todos los scripts son ejecutables."

echo
echo "[INFO] Puedes comenzar ejecutando, por ejemplo:"

echo
echo "    ./01-system/01-update.sh"
echo

echo "[ OK ] Bootstrap completado."