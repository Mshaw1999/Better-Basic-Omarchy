#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEYS_DIR="${ROOT_DIR}/keybinds"

# shellcheck source=./scripts/common.sh
source "${ROOT_DIR}/scripts/common.sh"

log_start "Configuring keybinds"

# Ensure the keybinds exist in the repo
required=(
  "config-hypr-bindings.conf"
  "default-hypr-bindings.conf"
  "default-hypr-media.conf"
  "default-hypr-tiling.conf"
  "default-hypr-utilities.conf"
  "config-omarchy-hypr-bindings.conf"
)
for f in "${required[@]}"; do
  if [[ ! -f "${KEYS_DIR}/${f}" ]]; then
    log_error "Missing keybind file: keybinds/${f}"
    exit 1
  fi
done

# Deploy with backups
safe_deploy "${KEYS_DIR}/config-hypr-bindings.conf" \
  "~/.config/hyper/bindings.conf"

safe_deploy "${KEYS_DIR}/default-hypr-bindings.conf" \
  "~/.local/share/omarchy/default/hypr/bindings.conf"

safe_deploy "${KEYS_DIR}/default-hypr-media.conf" \
  "~/.local/share/omarchy/default/hypr/bindings/media.conf"

safe_deploy "${KEYS_DIR}/default-hypr-tiling.conf" \
  "~/.local/share/omarchy/default/hypr/bindings/tiling.conf"

safe_deploy "${KEYS_DIR}/default-hypr-utilities.conf" \
  "~/.local/share/omarchy/default/hypr/bindings/utilities.conf"

safe_deploy "${KEYS_DIR}/config-omarchy-hypr-bindings.conf" \
  "~/.local/share/omarchy/config/hypr/bindings.conf"

log_success "Keybinds applied"
