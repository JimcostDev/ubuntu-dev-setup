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

# ==========================================================
# Configuration
# ==========================================================

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$PROJECT_ROOT/user.conf"

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
