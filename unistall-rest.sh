#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${ROOT_DIR}/scripts"

# shellcheck source=./scripts/common.sh
source "${SCRIPTS_DIR}/common.sh"

log_start "Reset/Uninstall started"

# Restore backups if present
restore_if_backup "~/.config/hyper/bindings.conf"
restore_if_backup "~/.local/share/omarchy/default/hypr/bindings.conf"
restore_if_backup "~/.local/share/omarchy/default/hypr/bindings/media.conf"
restore_if_backup "~/.local/share/omarchy/default/hypr/bindings/tiling.conf"
restore_if_backup "~/.local/share/omarchy/default/hypr/bindings/utilities.conf"
restore_if_backup "~/.local/share/omarchy/config/hypr/bindings.conf"

# Remove theme dir if we installed it
maybe_remove "~/.local/share/omarchy/themes/osaka-jade"

# Stop and remove rclone services (user scope)
stop_disable_user_service "rclone-mount-GoogleDrive.service"
stop_disable_user_service "rclone-mount-OneDrive.service"
maybe_remove "~/.config/systemd/user/rclone-mount-GoogleDrive.service"
maybe_remove "~/.config/systemd/user/rclone-mount-OneDrive.service"
maybe_remove "~/.config/rclone-mounts/GoogleDrive.sh"
maybe_remove "~/.config/rclone-mounts/OneDrive.sh"

log_success "Reset/Uninstall finished ✅"
echo "Log file: ${LOG_FILE}"
echo "Note: Packages (yay, rclone, etc.) are intentionally not removed."
