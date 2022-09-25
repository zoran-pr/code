#!/bin/bash

# Backup and restore 

second_user="ljeto"
backup_path=$(echo "$PWD")
backup_path="/media/dev_ops/backup-2"
backup_dir="${backup_path}/${HOSTNAME%%.*}_$(date +%Y-%m-%d)"

# create backup dir
mkdir ${backup_dir}
sudo chown root:users ${backup_dir}
sudo chmod 775 ${backup_dir}

# backup all users
sudo rsync -av /home ${backup_dir}/
sudo rsync -av /opt ${backup_dir}/
sudo rsync -av /etc ${backup_dir}/
sudo rsync -av /boot ${backup_dir}/
# vmware, database, we servrers etc.
#sudo rsync -av /var ${backup_dir}/

# backup all installed deb's
#sudo apt-key exportall > ${backup_dir}/apt-trusted-keys
dpkg --get-selections > ${backup_dir}/apt-packages.list

# backup code settings and extensions
code --list-extensions | xargs -L 1 echo code --install-extension > ${backup_dir}/ext
mv ${backup_dir}/ext ${backup_dir}/code-extensions.list
cp -f /home/$USER/.config/Code/User/*.json ${backup_dir}/

# backup all python packages
pip freeze --all > ${backup_dir}/python-packages.list
