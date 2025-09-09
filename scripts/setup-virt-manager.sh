#!/usr/bin/env bash
set -euo pipefail

echo "[*] Installing virtualization stack..."
sudo pacman -Syu --needed \
  qemu-full libvirt virt-install virt-manager virt-viewer \
  edk2-ovmf dnsmasq iptables-nft bridge-utils \
  spice-gtk spice-vdagent swtpm openbsd-netcat

echo "[*] Enable & start libvirt..."
sudo systemctl enable --now libvirtd.service

echo "[*] Force libvirt firewall backend to iptables for NAT reliability..."
sudo install -Dm0644 /etc/libvirt/network.conf /etc/libvirt/network.conf.bak.$(date +%s) 2>/dev/null || true
if grep -qE '^\s*firewall_backend\s*=' /etc/libvirt/network.conf; then
  sudo sed -i -E 's|^\s*firewall_backend\s*=.*$|firewall_backend = "iptables"|' /etc/libvirt/network.conf
else
  echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf >/dev/null
fi

echo "[*] Restart libvirtd to apply change..."
sudo systemctl restart libvirtd.service

echo "[*] Ensure default NAT network exists, is active, and autostarts..."
if ! sudo virsh net-list --all | grep -qE '^\s*default\s'; then
  sudo virsh net-define /usr/share/libvirt/networks/default.xml
fi
sudo virsh net-start default 2>/dev/null || echo "[i] default network already active."
sudo virsh net-autostart default

echo "[*] Enable IPv4 forwarding (runtime + persistent)..."
sudo sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-kvm-forward.conf >/dev/null
sudo sysctl --system >/dev/null

echo "[*] Add current user to libvirt group (re-login/newgrp may be required)..."
if ! id -nG "$USER" | grep -qw libvirt; then
  sudo usermod -aG libvirt "$USER"
  echo "[!] You were added to 'libvirt'. Run: newgrp libvirt"
fi

echo "[*] Add Hyprland keybind: SUPER+V -> virt-manager..."
HYPR_DIR="$HOME/.config/hypr"
BIND_FILE="$HYPR_DIR/bindings.conf"
MAIN_CFG="$HYPR_DIR/hyprland.conf"
BIND_LINE='bind = SUPER, V, exec, virt-manager'

mkdir -p "$HYPR_DIR"
TARGET_FILE="$BIND_FILE"
[[ ! -f "$BIND_FILE" && -f "$MAIN_CFG" ]] && TARGET_FILE="$MAIN_CFG"

if [[ -f "$TARGET_FILE" ]]; then
  grep -Fqx "$BIND_LINE" "$TARGET_FILE" || printf "\n# Launch Virt-Manager\n%s\n" "$BIND_LINE" >> "$TARGET_FILE"
else
  printf "# Hyprland bindings\n%s\n" "$BIND_LINE" > "$BIND_FILE"
fi

echo "[✓] virt-manager setup complete. Launch with: virt-manager"
