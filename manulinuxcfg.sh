#!/bin/bash

HOMEDIR=/home/manu
SCALINGFACTOR=2
VM=TRUE

echo "adding aliases to bashrc"
echo "alias ll='ls -lah'" >> $HOMEDIR/.bashrc
echo "alias l='ls -lh'" >> $HOMEDIR/.bashrc

echo "copying .Xresources"
cp .Xresources $HOMEDIR/.Xresources
echo "copying and writing .xinitrc"
cp .xinitrc $HOMEDIR/.xinitrc
echo "xrdb -merge $HOMEDIR/.Xresources" >> $HOMEDIR/.xinitrc
echo "feh --bg-scale $HOMEDIR/Pictures/bg.jpg" >> $HOMEDIR/.xinitrc
echo "exec dwm" >> $HOMEDIR/.xinitrc

echo "install stuff"
apt update && apt -y upgrade
apt -y install vim rxvt-unicode git build-essential make gcc libx11-dev libxft-dev libxinerama-dev xorg xsel feh chromium dolphin suckless-tools qt5ct evince imagemagick 
if [ "$VM" == TRUE ]
then
	apt -y install open-vm-tools
fi

echo "install dwm"
git clone https://git.suckless.org/dwm $HOMEDIR/dwm
cp config.h $HOMEDIR/dwm/
cp manudwm.sh $HOMEDIR/dwm/
chmod +x $HOMEDIR/dwm/manudwm.sh
(cd $HOMEDIR/dwm && $HOMEDIR/dwm/manudwm.sh)

echo "do other stuff"
apt -y purge lightdm 
xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s $SCALINGFACTOR

echo "reboot"
systemctl reboot
