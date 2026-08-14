#!/usr/bin/env bash

# ==========================================================
# Ubuntu Dev Setup
# Shared utility functions
# ==========================================================

set -euo pipefail

# ==========================================================
# Colors
# ==========================================================

readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"
readonly BLUE="\033[0;34m"
readonly CYAN="\033[0;36m"
readonly NC="\033[0m"

# ==========================================================
# Output
# ==========================================================

print_line() {
    printf "%b\n" "${CYAN}====================================================${NC}"
}

step() {
    echo
    print_line
    printf "%b\n" "${CYAN}$1${NC}"
    print_line
}

info() {
    printf "%b\n" "${BLUE}[INFO]${NC} $1"
}

success() {
    printf "%b\n" "${GREEN}[ OK ]${NC} $1"
}

warning() {
    printf "%b\n" "${YELLOW}[WARN]${NC} $1"
}

error() {
    printf "%b\n" "${RED}[FAIL]${NC} $1"
}

# ==========================================================
# Helpers
# ==========================================================

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

file_exists() {
    [[ -f "$1" ]]
}

directory_exists() {
    [[ -d "$1" ]]
}

# Añade una línea a un archivo solo si no existe
append_line_if_missing() {

    local line="$1"
    local file="$2"

    grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

# Reemplaza una línea que comience por un patrón
replace_or_append() {

    local pattern="$1"
    local newline="$2"
    local file="$3"

    if grep -q "^${pattern}" "$file"; then
        sed -i "s|^${pattern}.*|${newline}|" "$file"
    else
        echo "$newline" >> "$file"
    fi
}

# ==========================================================
# Configuration
# ==========================================================

readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly CONFIG_FILE="$PROJECT_ROOT/user.conf"

load_config() {

    if [[ ! -f "$CONFIG_FILE" ]]; then
        error "No se encontró user.conf"
        exit 1
    fi

    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
}

# ==========================================================
# Validation
# ==========================================================

require_sudo() {

    sudo -v
}

require_command() {

    if ! command_exists "$1"; then
        error "No se encontró el comando '$1'."
        exit 1
    fi
}

# ==========================================================
# Downloads
# ==========================================================

download_file() {

    local url="$1"
    local output="$2"

    info "Descargando $(basename "$output")..."

    curl -fsSL "$url" -o "$output"
}

# ==========================================================
# Finish
# ==========================================================

finish() {

    echo
    success "$1"
}