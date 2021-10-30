#!/bin/bash

# Before running check the following link
# https://arcolinux.com/things-to-do-after-arcolinux-installation/

# Things to pick during installation:
# Kernel:
# 	- default
#	- zen
#	- amd/intel ucode(depends on the cpu)
# Drivers:
#	- nvidia proprietary + nvidia-dkms/intel open-source/AMD proprietary or open-source
# Login:
#	- whatever suits you(currently at Sddm)
# Desktop:
#	- whatever suits you(currently at bspwm)
# ArcoLinuxTools:
#	- fun
#	- sddm-themes
#	- steam
#	- utilities
# Communication:
#	- discord
#	- skype
#	- signal
# Development:
# 	- visual-studio-code-bin
# Office:
#	- WPS
#	- okular
# Fonts:
# 	- awesome-terminal-fonts
#	- fira-code
#	- font-awesome
#	- jetbrains-mono
#	- powerlevel10k
#	- ms-fonts
# Multimedia:
#	- obs-studio
#	- vlc
#	- youtube-dl
# Internet:
#	- firefox
#	- ublock-origin
#	- google-chrome
#	- qbittorrent
#	- mailspring
# Theming:
#	- whatever suits you(currently all)
# Gaming:
#	- meta-steam
#	- wine
#	- lutris
#	- steam-buddy
#	- steam-tweaks
# Terminals:
#	- alacritty
#	- oh-my-zsh
#	- powerlevel10k
#	- terminator
# Filemanagers:
#	- dolphin
#	- ranger
# Utilities:
#	- etcher-bin
#	- woeusb
#	- flatpak
#	- snapd
#	- htop
#	- lm_sensors
#	- caffeine
#	- galculator
#	- gufw
#	- stacer
# Applications:
#	- bitwarden
#	- tor-browser
#	- tor
#	- virtualbox for linux kernel
# Partitions:
# 	- swap to file

read -r -p "Did you check installation script before running? [Y/n] " response
if [[ "$response" =~ ^([nN][eE][sS]|[nN])$ ]]
then
    echo "Please check it."
    exit
fi

# load custom arcolinux scripts
skel

# update system
mirror
update
upall
yay
cleanup

# enable utilities
hblock
sudo systemctl enable fstrim.timer
sudo ufw enable
sudo hardcode-fixer
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/100-arcolinux.conf

# change default shell
chsh -s /bin/zsh

# git
git config --global user.name "Dejan Zdravkovic"
git config --global user.email "bagzi1996@gmail.com"

# mysql
sudo pacman -S mariadb
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

# postgres (pass: root)
sudo pacman -S postgresql
sudo su - postgres -c "initdb -D '/var/lib/postgres/data'"
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo psql -U postgres -c "\password postgres"

# redis
sudo pacman -S redis
sudo systemctl enable redis
sudo systemctl start redis
redis-cli config set requirepass root

# mongo
yay mongodb-bin
sudo systemctl enable --now mongodb

# java
sudo pacman -S jre-openjdk
sudo pacman -S maven

# node
yay nvm
source /usr/share/nvm/init-nvm.sh
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc
nvm install --lts
npm install -g @angular/cli nx

# pip
sudo pacman -S python-pip

# apps
yay postman-bin
yay intellij-idea-ultimate-edition
yay pycharm-professional

# hardware
# gpu config
sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
yay gwe
# rgb config (r: 200, g: 140: b:255)
yay openrgb

reboot

# After the script is done you should choose your themes and default apps manually.
