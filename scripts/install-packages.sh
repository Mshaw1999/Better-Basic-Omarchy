#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log_start "Installing packages (pacman + yay/AUR)"

# 1) Core tools
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git base-devel nano kate usbutils rclone jq playerctl swayosd mako waybar alacritty

# 2) Ensure yay exists (try pacman; if not, build from AUR)
if ! command -v yay >/dev/null 2>&1; then
  if pacman -Si yay >/dev/null 2>&1; then
    sudo pacman -S --noconfirm yay
  else
    log "Installing yay from AUR"
    tmpdir="$(mktemp -d)"
    pushd "${tmpdir}" >/dev/null
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    popd >/dev/null
    rm -rf "${tmpdir}"
  fi
else
  log "yay already installed"
fi

# 3) AUR packages
yay -S --needed --noconfirm chatgpt-desktop-bin omarchist-bin

log_success "Packages installed"
