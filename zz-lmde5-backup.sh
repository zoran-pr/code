#!/bin/bash

# Backup and restore 

second_user="ljeto"
backup_path=$(echo "$PWD")
backup_path="/media/dev_ops/backup-2"
backup_dir="${backup_path}/${HOSTNAME%%.*}_$(date +%Y-%m-%d)"

# create backup dir
mkdir ${backup_dir}

# backup all users
sudo rsync -av /home ${backup_dir}/

# backup all installed deb's
sudo apt-key add ${backup_dir}/apt-trusted-keys
local$ dpkg --get-selections > ${backup_dir}/apt-packages.list

# backup code settings and extensions
code --list-extensions | xargs -L 1 echo code --install-extension > ${backup_dir}/ext
mv ${backup_dir}/ext ${backup_dir}/code-extensions.list
cp -f /home/$USER/.config/Code/User/*.json ${backup_dir}/

# backup all python packages
pip freeze --all > ${backup_dir}/python-packages.list
