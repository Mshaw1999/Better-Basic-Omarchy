#!/usr/bin/env bash
set -euo pipefail

# Root of repo (supports running from anywhere)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${ROOT_DIR}/scripts"

# Source common helpers (logging, backup, etc.)
# shellcheck source=./scripts/common.sh
source "${SCRIPTS_DIR}/common.sh"

log_start "Better-Basic-Omarchy setup started"

run_step "Install packages"               "${SCRIPTS_DIR}/install-packages.sh"
run_step "Install Osaka Jade theme"       "${SCRIPTS_DIR}/install-theme.sh"
run_step "Configure keybinds"             "${SCRIPTS_DIR}/configure-keybinds.sh"
run_step "Setup rclone mounts & helpers"  "${SCRIPTS_DIR}/setup-rclone.sh"

log_success "Setup complete 🎉"
echo "Log file: ${LOG_FILE}"
