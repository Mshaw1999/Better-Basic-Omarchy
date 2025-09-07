#!/usr/bin/env bash
set -euo pipefail

# Create logs directory and timestamped log file
LOG_DIR="${HOME}/.local/share/better-basic-omarchy/logs"
mkdir -p "${LOG_DIR}"
TS="$(date +'%Y%m%d-%H%M%S')"
LOG_FILE="${LOG_DIR}/setup-${TS}.log"

# Basic logger
log()        { echo "[$(date +'%H:%M:%S')] $*" | tee -a "${LOG_FILE}"; }
log_warn()   { log "⚠️  $*"; }
log_error()  { log "❌ $*"; }
log_success(){ log "✅ $*"; }
log_start()  { log "🚀 $*"; }

# Run a step with logging
run_step() {
  local title="$1"; shift
  local cmd="$*"
  log "---- ${title} ----"
  if eval "${cmd}" >> "${LOG_FILE}" 2>&1; then
    log_success "${title}"
  else
    log_error "${title} failed (see ${LOG_FILE})"
    exit 1
  fi
}

# Expand ~ in paths portably
expand_path() {
  local p="$1"
  eval echo "${p}"
}

# Backup-if-exists, then copy atomically with install -D
safe_deploy() {
  local src="$1" dst="$2"
  local dst_expanded
  dst_expanded="$(expand_path "${dst}")"
  local dst_dir
  dst_dir="$(dirname "${dst_expanded}")"
  mkdir -p "${dst_dir}"

  if [[ -e "${dst_expanded}" ]]; then
    local bak="${dst_expanded}.bak-${TS}"
    cp -a "${dst_expanded}" "${bak}"
    log "Backed up ${dst} -> ${bak}"
  fi

  install -Dm644 "${src}" "${dst_expanded}"
  log "Deployed ${src} -> ${dst}"
}

# Restore from newest backup if present
restore_if_backup() {
  local target="$1"
  local texp
  texp="$(expand_path "${target}")"
  local newest
  newest="$(ls -t "${texp}".bak-* 2>/dev/null | head -n1 || true)"
  if [[ -n "${newest}" ]]; then
    cp -a "${newest}" "${texp}"
    log "Restored ${target} from backup ${newest}"
  else
    log_warn "No backup found for ${target}"
  fi
}

# Remove path if exists
maybe_remove() {
  local p="$1"
  local exp
  exp="$(expand_path "${p}")"
  if [[ -e "${exp}" ]]; then
    rm -rf "${exp}"
    log "Removed ${p}"
  fi
}

# systemd user helpers
stop_disable_user_service() {
  local svc="$1"
  systemctl --user stop "${svc}" 2>/dev/null || true
  systemctl --user disable "${svc}" 2>/dev/null || true
}
reload_user_daemon() {
  systemctl --user daemon-reload || true
}
enable_start_user_service() {
  local svc="$1"
  systemctl --user enable "${svc}"
  systemctl --user start "${svc}"
}
