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
    printf "${CYAN}%s${NC}\n" "$1"
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

finish() {
    echo
    success "$1"
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

append_line_if_missing() {

    local line="$1"
    local file="$2"

    grep -qxF "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

replace_or_append() {

    local pattern="$1"
    local newline="$2"
    local file="$3"

    if grep -Eq "$pattern" "$file" 2>/dev/null; then
        sed -Ei "s|$pattern.*|$newline|" "$file"
    else
        echo "$newline" >> "$file"
    fi
}

download_file() {

    local url="$1"
    local output="$2"

    info "Descargando $(basename "$output")..."

    curl --progress-bar -fL "$url" -o "$output"
}

# ==========================================================
# Shell
# ==========================================================

get_shell_profile() {

    if [[ "$SHELL" == */zsh ]]; then
        echo "$HOME/.zshrc"
    else
        echo "$HOME/.profile"
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

    info "Solicitando permisos de administrador..."

    sudo -v
}

require_command() {

    if ! command_exists "$1"; then
        error "No se encontró el comando '$1'."
        exit 1
    fi
}

require_ubuntu() {

    if [[ ! -f /etc/os-release ]]; then
        error "Sistema operativo no soportado."
        exit 1
    fi

    # shellcheck disable=SC1091
    source /etc/os-release

    if [[ "$ID" != "ubuntu" ]]; then
        error "Este proyecto solo es compatible con Ubuntu."
        exit 1
    fi
}

# ==========================================================
# Information
# ==========================================================

print_version() {

    local command="$1"

    require_command "$command"

    echo
    info "$command"

    "$command" --version | head -n 1
}
