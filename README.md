# manulinuxcfg
bash script to configure a fresh debian installation to my taste

- install standard debian with xfce
- login as root
- create user with homedir (useradd -m -s /bin/bash <username>)
- git clone this repo
- change stuff in script if necessary
- chmod +x manulinuxcfg.sh
- run manulinuxcfg.sh
- wait

other stuff to eventually do in new systems:
- add new user to /etc/sudoers
- dpkg-reconfigure keyboard-configuration
- dpkg-reconfigure locales
- setupcon
