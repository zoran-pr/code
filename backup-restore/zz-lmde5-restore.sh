#!/bin/bash

second_user="ljeto"
user_id=2001
path=$(echo "$PWD")

# restore deb packages
sudo rsync -av ${path}/localhost/etc/apt/sources.list.d/ /etc/apt/sources.list.d/
sudo rm -rf /etc/apt
sudo rsync -av ${path}/localhost/etc/apt/ /etc/apt/
sudo apt-key add ${path}/deb-trusted-keys
sudo apt-get update
sudo dpkg --set-selections < ${path}/apt-packages.list
sudo apt-get -u dselect-upgrade -y

# restore custm files
sudo rsync -av ${path}/localhost/etc/profile.d/path-opt-bin.sh /etc/profile.d/path-opt-bin.sh
sudo rsync =av ${path}/localhost/etc/fstab /etc/fstab

# restore ${second_user} users first
sudo rsync -av ${path}/localhost/home/${second_user}/ /home/${second_user}/

#restore code
cp -f ${path}/code.settings.json /home/$USER/.config/Code/User/
bash ${path}/code-extensions.list

# restore python packages
pip install -r ${path}/python-packages.list
