#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log_start "Installing Osaka Jade theme"

THEME_DIR="${HOME}/.local/share/omarchy/themes/osaka-jade"

if [[ -d "${THEME_DIR}/.git" ]]; then
  log "Theme already present; pulling latest"
  git -C "${THEME_DIR}" pull --ff-only
else
  mkdir -p "$(dirname "${THEME_DIR}")"
  git clone https://github.com/Justikun/omarchy-osaka-jade-theme.git "${THEME_DIR}"
fi

# If the theme repo exposes an installer, run it (safe/no-op if not present)
if [[ -x "${THEME_DIR}/install.sh" ]]; then
  run_step "Run theme installer" "\"${THEME_DIR}/install.sh\""
else
  log_warn "No theme install.sh found; cloned only"
fi

log_success "Theme step finished"
