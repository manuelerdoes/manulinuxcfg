#!/bin/sh

urxvtd -f

export QT_QPA_PLATFORMTHEME="qt5ct"

while xsetroot -name "`uptime | egrep -o "([0-9]\.([0-9]){2}, ){2}[0-9]\.([0-9]){2}"` `date +"%a %d %b %Y %H:%M:%S"`"
do
	sleep 1
done &

xrdb -merge /home/manu/.Xresources 
feh --bg-scale /home/manu/Pictures/cyber-outrun-vaporwave-art.jpg
exec dwm
