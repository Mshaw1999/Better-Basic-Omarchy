#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log_start "Configuring rclone mounts (GoogleDrive & OneDrive)"

# Create mount points
mkdir -p "${HOME}/GoogleDrive" "${HOME}/OneDrive"

# Prompt user to run rclone config if remotes missing
need_config=false
for remote in "GoogleDrive" "OneDrive"; do
  if ! rclone listremotes | grep -q "^${remote}:"; then
    log_warn "Missing rclone remote: ${remote}:"
    need_config=true
  fi
done

if [[ "${need_config}" == true ]]; then
  echo
  echo ">>> You'll now enter the interactive rclone config to add these two remotes:"
  echo "    - Name: GoogleDrive    Type: drive"
  echo "    - Name: OneDrive       Type: onedrive"
  echo "    (If you’ve already added them with these exact names, you can quit.)"
  echo
  rclone config
fi

# Create helper mount scripts
CONF_DIR="${HOME}/.config/rclone-mounts"
mkdir -p "${CONF_DIR}"

cat > "${CONF_DIR}/GoogleDrive.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
rclone --vfs-cache-mode writes \
  --vfs-cache-max-size 2G \
  --vfs-cache-max-age 12h \
  --dir-cache-time 72h \
  --poll-interval 30s \
  --transfers 8 \
  --checkers 8 \
  mount GoogleDrive: "${HOME}/GoogleDrive"
EOF
chmod +x "${CONF_DIR}/GoogleDrive.sh"

cat > "${CONF_DIR}/OneDrive.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
rclone --vfs-cache-mode writes \
  --vfs-cache-max-size 2G \
  --vfs-cache-max-age 12h \
  --dir-cache-time 72h \
  --poll-interval 30s \
  --transfers 8 \
  --checkers 8 \
  mount OneDrive: "${HOME}/OneDrive"
EOF
chmod +x "${CONF_DIR}/OneDrive.sh"

# Systemd user units for auto-mount
mkdir -p "${HOME}/.config/systemd/user"

cat > "${HOME}/.config/systemd/user/rclone-mount-GoogleDrive.service" <<'EOF'
[Unit]
Description=Rclone Mount GoogleDrive
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=%h/.config/rclone-mounts/GoogleDrive.sh
ExecStop=/bin/fusermount3 -u %h/GoogleDrive
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

cat > "${HOME}/.config/systemd/user/rclone-mount-OneDrive.service" <<'EOF'
[Unit]
Description=Rclone Mount OneDrive
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=%h/.config/rclone-mounts/OneDrive.sh
ExecStop=/bin/fusermount3 -u %h/OneDrive
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

reload_user_daemon
enable_start_user_service "rclone-mount-GoogleDrive.service"
enable_start_user_service "rclone-mount-OneDrive.service"

log_success "rclone configured. Mount points:"
echo "  ~/GoogleDrive  (service: rclone-mount-GoogleDrive)"
echo "  ~/OneDrive     (service: rclone-mount-OneDrive)"
echo
echo "To view logs: journalctl --user -u rclone-mount-GoogleDrive -f"
echo "              journalctl --user -u rclone-mount-OneDrive -f"
