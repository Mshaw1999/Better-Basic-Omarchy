# Better-Basic-Omarchy

Automated setup script for a **fresh Omarchy (Arch-based)** install.  
This repository configures your system with packages, themes, custom Hyprland keybinds, and cloud storage mounts.  

The script is designed to **save time** and **reduce errors** by handling installation and configuration in one go — with safety features like backups, logs, and a reset/uninstall option.

---

## ✨ What This Script Does

- 📦 **Package Installation**
  - Core tools: `nano`, `kate`, `usbutils (lsusb)`, `git`, `rclone`
  - AUR helper: `yay`
  - AUR apps: `chatgpt-desktop-bin`, `omarchist-bin`
- 🎨 **Theme Setup**
  - Clones and installs the [Osaka Jade Omarchy theme](https://github.com/Justikun/omarchy-osaka-jade-theme)
- ⌨️ **Keybind Deployment**
  - Installs your custom Hyprland keybinds into:
    - `~/.config/hyper/bindings.conf`
    - `~/.local/share/omarchy/default/hypr/bindings.conf`
    - `~/.local/share/omarchy/default/hypr/bindings/media.conf`
    - `~/.local/share/omarchy/default/hypr/bindings/tiling.conf`
    - `~/.local/share/omarchy/default/hypr/bindings/utilities.conf`
    - `~/.local/share/omarchy/config/hypr/bindings.conf`
- ☁️ **Cloud Integration with Rclone**
  - Guides you through setting up Google Drive and OneDrive
  - Creates mount points at `~/GoogleDrive` and `~/OneDrive`
  - Adds `systemd --user` services so drives auto-mount at login
- 🔒 **Safety Features**
  - Creates **backups** of every config it touches (`.bak-YYYYmmdd-HHMMSS`)
  - Saves **logs** of every step in `~/.local/share/better-basic-omarchy/logs/`
  - Includes a **Reset/Uninstall script** to roll everything back

---

## 🔄 Reset / Uninstall

To restore backups and remove mounts/theme:

```bash
chmod +x uninstall-reset.sh
./uninstall-reset.sh


📝 Important Notes

Backups: Safe copies of your original configs are created before changes.

Logs: Check ~/.local/share/better-basic-omarchy/logs/ for step-by-step logs.

Theme: Osaka Jade is cloned from Justikun’s repo
.

Rclone Remotes: If GoogleDrive: or OneDrive: don’t exist in your rclone config, the script will prompt you to create them.

Safe to Inspect: All scripts are open and plain Bash — you can (and should) read them before running.


-----------------------------------------------------------------------------

Better-Basic-Omarchy/
├── install.sh              # Main installer (orchestrates everything)
├── uninstall-reset.sh      # Restores backups & removes services/theme
├── scripts/                # Helper scripts
│   ├── common.sh           # Logging + backup helpers
│   ├── install-packages.sh # Pacman + yay packages
│   ├── install-theme.sh    # Clones Osaka Jade
│   ├── configure-keybinds.sh # Applies keybinds safely
│   └── setup-rclone.sh     # Sets up Google Drive & OneDrive mounts
└── keybinds/               # Your custom Hyprland configs

-----------------------------------------------------------------


🔧 Requirements

Fresh Omarchy / Arch-based system

Internet access for package installs and theme cloning

git and base-devel (installed if missing)

(Optional) Rclone
 remotes already configured for Google Drive and OneDrive


____________________________________________________________________


🔍 Keywords / Tags

Arch Linux Omarchy Hyprland tiling wm keybinds AUR yay setup script automation rclone onedrive google drive themes


________________________________________________________________________


⚠️ Disclaimer

This script modifies your system configuration and installs software.

Always read the scripts before running.

Backups are created automatically, but you are responsible for your system.

Use at your own risk.

🙌 Credits

Justikun
 — author of the Omarchy Osaka Jade Theme

Rclone
 — for cloud storage integration

🤝 Contributing

Contributions are welcome!
Fork the repo, customize packages or keybinds, and open a pull request.






---

This README is **structured for maximum clarity and SEO**:  
- Starts with a plain-language explanation  
- Walks through features clearly  
- Has explicit sections for reset, notes, repo structure  
- Uses links to external repos (theme + rclone)  
- Ends with disclaimers and credits  

👉 Do you also want me to add **screenshots or example terminal output** (like what users will see during install) to make it more approachable?
