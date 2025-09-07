# Better-Basic-Omarchy
# Better-Basic-Omarchy

One-shot setup for a fresh Omarchy install:
- Installs essentials (yay, nano, kate, usbutils, rclone, etc.)
- Installs AUR apps: `chatgpt-desktop-bin`, `omarchist-bin`
- Clones the Osaka Jade theme
- Applies your Hypr keybinds (with backups)
- Sets up rclone mounts for Google Drive and OneDrive (systemd user services)

## Prereqs
- A fresh Omarchy/Arch-like environment
- `git` and `base-devel` (installed by script if missing)

## Install
```bash
git clone https://github.com/<YOUR-USER>/Better-Basic-Omarchy.git
cd Better-Basic-Omarchy
chmod +x install.sh
./install.sh
