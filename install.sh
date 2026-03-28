#!/bin/bash
# Solarized Light GNOME 50 Rice - Automated Installer
# For Fedora Rawhide 45+ with GNOME 50+
# https://github.com/NicksLameCode/solarized-light-gnome50-rice

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CYAN='\033[38;2;42;161;152m'
BLUE='\033[38;2;38;139;210m'
YELLOW='\033[38;2;181;137;0m'
GREEN='\033[38;2;133;153;0m'
RESET='\033[0m'

info()  { echo -e "${CYAN}[INFO]${RESET} $1"; }
step()  { echo -e "${BLUE}[STEP]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${RESET} $1"; }
done_() { echo -e "${GREEN}[DONE]${RESET} $1"; }

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════════╗"
echo "  ║   Solarized Light Rice for GNOME 50           ║"
echo "  ║   Fedora Rawhide 45+                          ║"
echo "  ╚═══════════════════════════════════════════════╝"
echo -e "${RESET}"

# ── Prerequisites ──
step "Checking prerequisites..."
if ! grep -qi "fedora" /etc/os-release 2>/dev/null; then
  warn "This script is designed for Fedora. Proceed at your own risk."
fi

if ! command -v gnome-shell &>/dev/null; then
  echo "ERROR: GNOME Shell not found. This rice requires GNOME."
  exit 1
fi

# ── Phase 1: Install Packages ──
step "Installing packages via dnf..."
sudo dnf install -y \
  fastfetch btop fzf bat eza git-delta \
  papirus-icon-theme \
  gnome-shell-extension-blur-my-shell \
  gnome-shell-extension-user-theme \
  gnome-shell-extension-just-perfection \
  gnome-shell-extension-forge \
  gnome-shell-extension-logo-menu \
  plymouth-theme-solar plymouth-plugin-script \
  neovim fd-find ripgrep \
  zoxide cava figlet cowsay fortune-mod \
  glow ImageMagick liberation-sans-fonts \
  glib2-devel

# ── Phase 2: Install Starship ──
step "Installing starship prompt..."
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin
else
  info "Starship already installed"
fi

# ── Phase 3: Install JetBrains Mono Nerd Font ──
step "Installing JetBrains Mono Nerd Font..."
if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
  mkdir -p ~/.local/share/fonts
  curl -fLo /tmp/JetBrainsMono.tar.xz \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  tar -xf /tmp/JetBrainsMono.tar.xz -C ~/.local/share/fonts/
  fc-cache -fv ~/.local/share/fonts/ >/dev/null 2>&1
else
  info "JetBrains Mono Nerd Font already installed"
fi

# ── Phase 4: Install Bibata Cursor ──
step "Installing Bibata-Modern-Ice cursor..."
if [ ! -d ~/.local/share/icons/Bibata-Modern-Ice ]; then
  mkdir -p ~/.local/share/icons
  curl -fLo /tmp/Bibata-Modern-Ice.tar.xz \
    https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.xz
  tar -xf /tmp/Bibata-Modern-Ice.tar.xz -C ~/.local/share/icons/
  sudo cp -r ~/.local/share/icons/Bibata-Modern-Ice /usr/share/icons/
else
  info "Bibata cursor already installed"
fi

# ── Phase 5: Install lazygit ──
step "Installing lazygit..."
if ! command -v lazygit &>/dev/null; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -fLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  mkdir -p ~/.local/bin
  tar -xf /tmp/lazygit.tar.gz -C ~/.local/bin/ lazygit
else
  info "lazygit already installed"
fi

# ── Phase 6: Copy Config Files ──
step "Installing configuration files..."

# Shell scripts
mkdir -p ~/.bashrc.d
cp "$SCRIPT_DIR/shell/"*.sh ~/.bashrc.d/

# Starship
mkdir -p ~/.config
cp "$SCRIPT_DIR/config/starship.toml" ~/.config/

# tmux
cp "$SCRIPT_DIR/config/tmux.conf" ~/.tmux.conf

# fastfetch
mkdir -p ~/.config/fastfetch
cp "$SCRIPT_DIR/config/fastfetch/config.jsonc" ~/.config/fastfetch/

# btop
mkdir -p ~/.config/btop/themes
cp "$SCRIPT_DIR/config/btop/btop.conf" ~/.config/btop/
cp "$SCRIPT_DIR/config/btop/themes/solarized-light.theme" ~/.config/btop/themes/

# neovim
mkdir -p ~/.config/nvim
cp "$SCRIPT_DIR/config/nvim/init.lua" ~/.config/nvim/

# lazygit
mkdir -p ~/.config/lazygit
cp "$SCRIPT_DIR/config/lazygit/config.yml" ~/.config/lazygit/

# yazi
mkdir -p ~/.config/yazi
cp "$SCRIPT_DIR/config/yazi/theme.toml" ~/.config/yazi/

# cava
mkdir -p ~/.config/cava
cp "$SCRIPT_DIR/config/cava/config" ~/.config/cava/

# glow
mkdir -p ~/.config/glow
cp "$SCRIPT_DIR/config/glow/glow.yml" ~/.config/glow/

# VS Code (only if VS Code is installed)
if command -v code &>/dev/null; then
  mkdir -p ~/.config/Code/User
  cp "$SCRIPT_DIR/config/vscode/settings.json" ~/.config/Code/User/
  code --install-extension PKief.material-icon-theme 2>/dev/null || true
fi

# GTK
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cp "$SCRIPT_DIR/gtk/gtk-3.0/gtk.css" ~/.config/gtk-3.0/
cp "$SCRIPT_DIR/gtk/gtk-3.0/settings.ini" ~/.config/gtk-3.0/
cp "$SCRIPT_DIR/gtk/gtk-4.0/gtk.css" ~/.config/gtk-4.0/

# GNOME Shell theme
mkdir -p ~/.local/share/themes/Solarized-Light/gnome-shell
cp "$SCRIPT_DIR/gnome-shell/Solarized-Light/gnome-shell/gnome-shell.css" \
   ~/.local/share/themes/Solarized-Light/gnome-shell/

# Ptyxis terminal palette
mkdir -p ~/.local/share/org.gnome.Ptyxis/palettes
cp "$SCRIPT_DIR/terminal/solarized-light-readable.palette" \
   ~/.local/share/org.gnome.Ptyxis/palettes/

# dircolors
if [ ! -f ~/.dir_colors ]; then
  curl -fsSL https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-light \
    -o ~/.dir_colors 2>/dev/null
fi

# ── Phase 7: Generate Wallpaper ──
step "Generating wallpaper..."
bash "$SCRIPT_DIR/wallpaper/generate-wallpaper.sh" "$HOME/Pictures/Wallpapers"
sudo cp "$HOME/Pictures/Wallpapers/solarized-stripes-4k.png" /usr/share/backgrounds/ 2>/dev/null || true

# ── Phase 8: Apply GNOME Settings ──
step "Applying GNOME settings..."

# Desktop
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.interface accent-color 'teal'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Light'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10'

# Wallpaper
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Wallpapers/solarized-stripes-4k.png"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/Wallpapers/solarized-stripes-4k.png"
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.background primary-color '#fdf6e3'
gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/Pictures/Wallpapers/solarized-stripes-4k.png"

# Extensions
gsettings set org.gnome.shell enabled-extensions \
  "['blur-my-shell@aunetx', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'just-perfection-desktop@just-perfection', 'forge@jmmaranan.com']"
gsettings set org.gnome.shell disabled-extensions "['background-logo@fedorahosted.org']"

# Shell theme
gsettings set org.gnome.shell.extensions.user-theme name 'Solarized-Light'

# Blur my Shell (panel blur off for solid top bar)
dconf write /org/gnome/shell/extensions/blur-my-shell/brightness 0.85
dconf write /org/gnome/shell/extensions/blur-my-shell/sigma 20
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/blur false
dconf write /org/gnome/shell/extensions/blur-my-shell/overview/blur true

# Forge tiling (Hyprland-style)
dconf write /org/gnome/shell/extensions/forge/window-gap-size "uint32 8"
dconf write /org/gnome/shell/extensions/forge/window-gap-hidden-on-single true
dconf write /org/gnome/shell/extensions/forge/focus-border-toggle true
dconf write /org/gnome/shell/extensions/forge/focus-border-size "uint32 3"
dconf write /org/gnome/shell/extensions/forge/focus-border-color "'rgba(42, 161, 152, 0.9)'"
dconf write /org/gnome/shell/extensions/forge/split-border-toggle true
dconf write /org/gnome/shell/extensions/forge/split-border-color "'rgba(38, 139, 210, 0.5)'"
dconf write /org/gnome/shell/extensions/forge/stacked-tiling-mode-enabled true
dconf write /org/gnome/shell/extensions/forge/tabbed-tiling-mode-enabled true
dconf write /org/gnome/shell/extensions/forge/focus-on-hover-enabled true
dconf write /org/gnome/shell/extensions/forge/float-always-on-top-enabled true
dconf write /org/gnome/shell/extensions/forge/preview-hint-enabled true
dconf write /org/gnome/shell/extensions/forge/move-pointer-focus-enabled true
dconf write /org/gnome/shell/extensions/forge/auto-split-enabled true

# Forge keybinds (vim-style, Hyprland-inspired)
gsettings set org.gnome.shell.extensions.forge.keybindings window-focus-left "['<Super>h']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-focus-down "['<Super>j']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-focus-up "['<Super>k']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-focus-right "['<Super>l']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-swap-left "['<Super><Shift>h']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-swap-down "['<Super><Shift>j']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-swap-up "['<Super><Shift>k']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-swap-right "['<Super><Shift>l']"
gsettings set org.gnome.shell.extensions.forge.keybindings con-split-layout-toggle "['<Super>e']"
gsettings set org.gnome.shell.extensions.forge.keybindings con-tabbed-layout-toggle "['<Super>w']"
gsettings set org.gnome.shell.extensions.forge.keybindings window-toggle-float "['<Super>space']"

# Just Perfection
dconf write /org/gnome/shell/extensions/just-perfection/app-menu-label false

# Ptyxis terminal
gsettings set org.gnome.Ptyxis interface-style 'light'
gsettings set org.gnome.Ptyxis use-system-font false
gsettings set org.gnome.Ptyxis font-name 'JetBrainsMono Nerd Font 11'

# Get default Ptyxis profile UUID
PTYXIS_UUID=$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")
if [ -n "$PTYXIS_UUID" ]; then
  dconf write "/org/gnome/Ptyxis/Profiles/${PTYXIS_UUID}/palette" "'solarized-light-readable'"
  dconf write "/org/gnome/Ptyxis/Profiles/${PTYXIS_UUID}/label" "'Solarized Light'"
  dconf write "/org/gnome/Ptyxis/Profiles/${PTYXIS_UUID}/opacity" 1.0
fi

# Flatpak theming
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro 2>/dev/null || true
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro 2>/dev/null || true

# ── Phase 9: Git Config ──
step "Configuring git delta + colors..."
git config --global include.path "$SCRIPT_DIR/git/gitconfig-delta"

# ── Phase 10: Boot Themes ──
step "Installing Plymouth boot theme..."
bash "$SCRIPT_DIR/scripts/generate-assets.sh"
sudo cp "$SCRIPT_DIR/boot/plymouth/solarized-light.plymouth" /usr/share/plymouth/themes/solarized-light/
sudo cp "$SCRIPT_DIR/boot/plymouth/solarized-light.script" /usr/share/plymouth/themes/solarized-light/
sudo cp "$SCRIPT_DIR/boot/grub/theme.txt" /boot/grub2/themes/solarized-light/
sudo plymouth-set-default-theme solarized-light
sudo dracut -f

step "Installing GRUB theme..."
if ! grep -q "GRUB_THEME" /etc/default/grub; then
  sudo sed -i 's|GRUB_TERMINAL_OUTPUT="console"|GRUB_TERMINAL_OUTPUT="gfxterm"|' /etc/default/grub
  echo 'GRUB_THEME="/boot/grub2/themes/solarized-light/theme.txt"' | sudo tee -a /etc/default/grub >/dev/null
  sudo grub2-mkconfig -o /boot/grub2/grub.cfg
fi

# ── Phase 11: GDM Login Screen (Optional) ──
echo ""
echo -e "${YELLOW}=== GDM Login Screen ===${RESET}"
echo "This patches the GNOME Shell gresource to theme the login screen."
echo "It modifies /usr/share/gnome-shell/gnome-shell-theme.gresource (a backup is created)."
read -rp "Apply GDM login screen theme? [y/N] " gdm_choice
if [[ "$gdm_choice" =~ ^[Yy]$ ]]; then
  bash "$SCRIPT_DIR/scripts/patch-gdm-gresource.sh"
fi

# ── Done ──
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║   Solarized Light Rice installed!             ║${RESET}"
echo -e "${GREEN}╚═══════════════════════════════════════════════╝${RESET}"
echo ""
echo "Next steps:"
echo "  1. Log out and back in (or reboot) for full effect"
echo "  2. Open a new terminal to see the starship prompt + fastfetch"
echo "  3. Run 'nvim' once to let it install plugins"
echo "  4. Restart Zen Browser for userChrome.css to take effect"
echo "  5. In Obsidian: Settings > Appearance > Light mode + enable CSS snippet"
echo ""
echo "Slack sidebar theme (paste in Preferences > Themes > Custom):"
echo "  #eee8d5,#ddd6c1,#2aa198,#fdf6e3,#ddd6c1,#586e75,#859900,#268bd2,#eee8d5,#657b83"
echo ""
