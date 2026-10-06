#!/bin/bash
set -e
cd "$(dirname "$0")"

USERNAME=manu
HOMEDIR=/home/$USERNAME
SCALINGFACTOR=2          # 1 = no scaling
export DEBIAN_FRONTEND=noninteractive

if [[ $EUID -ne 0 ]]; then
    echo "Run this script as root." >&2
    exit 1
fi
id "$USERNAME" >/dev/null 2>&1 || { echo "User $USERNAME does not exist." >&2; exit 1; }

# --- packages ---
apt update && apt -y upgrade
apt -y install vim rxvt-unicode xsel curl git build-essential make gcc \
    libx11-dev libxft-dev libxinerama-dev xorg feh chromium dolphin suckless-tools \
    qt5ct evince imagemagick psmisc

# --- shell ---
if ! grep -q "# manulinuxcfg" "$HOMEDIR/.bashrc"; then
    {
        echo "# manulinuxcfg"
        echo "alias ll='ls -lah'"
        echo "alias l='ls -lh'"
        cat functions.sh
    } >> "$HOMEDIR/.bashrc"
fi

# --- X session ---
cp .Xresources "$HOMEDIR/.Xresources"
cp .xinitrc "$HOMEDIR/.xinitrc"
cp bg.jpg "$HOMEDIR/"

if (( SCALINGFACTOR > 1 )); then
    echo "export GDK_SCALE=$SCALINGFACTOR" >> "$HOMEDIR/.xinitrc"
fi

if [[ "$(systemd-detect-virt)" == "vmware" ]]; then
    apt -y install open-vm-tools-desktop
    echo "vmtoolsd -n vmusr &" >> "$HOMEDIR/.xinitrc"
fi

echo "exec dwm" >> "$HOMEDIR/.xinitrc"

# --- urxvt extension (not packaged in Debian) ---
mkdir -p "$HOMEDIR/.urxvt/ext"
if ! curl -fsSL https://raw.githubusercontent.com/xyb3rt/urxvt-perls/master/keyboard-select \
        -o "$HOMEDIR/.urxvt/ext/keyboard-select"; then
    echo "WARNING: could not download keyboard-select, continuing without it." >&2
fi

# --- dwm ---
if [[ -d "$HOMEDIR/dwm/.git" ]]; then
    chown -R "$USERNAME:$USERNAME" "$HOMEDIR/dwm"   # earlier runs left root-owned files
    runuser -u "$USERNAME" -- git -C "$HOMEDIR/dwm" checkout config.h
    runuser -u "$USERNAME" -- git -C "$HOMEDIR/dwm" pull
else
    runuser -u "$USERNAME" -- git clone https://git.suckless.org/dwm "$HOMEDIR/dwm"
fi
cp config.h manudwm.sh "$HOMEDIR/dwm/"
chmod +x "$HOMEDIR/dwm/manudwm.sh"
(cd "$HOMEDIR/dwm" && ./manudwm.sh)

# --- ownership (script runs as root) ---
chown -R "$USERNAME:$USERNAME" "$HOMEDIR/dwm" "$HOMEDIR/.urxvt" \
    "$HOMEDIR/.Xresources" "$HOMEDIR/.xinitrc" "$HOMEDIR/bg.jpg"

apt -y purge lightdm || true

systemctl reboot
