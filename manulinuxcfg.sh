#!/bin/bash

HOMEDIR=/home/manu
SCALINGFACTOR=2
VM=TRUE

echo "alias ll='ls -lah'" >> $HOMEDIR/.bashrc
echo "alias l='ls -lh'" >> $HOMEDIR/.bashrc
cat functions.sh >> $HOMEDIR/.bashrc

cp .Xresources $HOMEDIR/.Xresources
cp .xinitrc $HOMEDIR/.xinitrc
echo "xrdb -merge $HOMEDIR/.Xresources" >> $HOMEDIR/.xinitrc
echo "feh --bg-scale $HOMEDIR/bg.jpg" >> $HOMEDIR/.xinitrc
echo "exec dwm" >> $HOMEDIR/.xinitrc

cp bg.jpg $HOMEDIR

apt update && apt -y upgrade
apt -y install vim rxvt-unicode git build-essential make gcc libx11-dev libxft-dev libxinerama-dev xorg xsel feh chromium dolphin suckless-tools qt5ct evince imagemagick 
if [ "$VM" == TRUE ]
then
	apt -y install open-vm-tools
fi

git clone https://git.suckless.org/dwm $HOMEDIR/dwm
cp config.h $HOMEDIR/dwm/
cp manudwm.sh $HOMEDIR/dwm/
chmod +x $HOMEDIR/dwm/manudwm.sh
(cd $HOMEDIR/dwm && $HOMEDIR/dwm/manudwm.sh)

apt -y purge lightdm 
xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s $SCALINGFACTOR

systemctl reboot
