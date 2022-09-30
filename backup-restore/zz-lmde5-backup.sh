#!/bin/bash

# Backup and restore 

second_user="ljeto"
backup_path=$(echo "$PWD")
backup_path="/media/dev_ops/backup-2"
backup_dir="${backup_path}/${HOSTNAME%%.*}_$(date +%Y-%m-%d)"

# create backup dir
mkdir -p "${backup_dir}/localhost"
sudo chown -R root:users "${backup_dir}"
sudo chmod -R 775 "${backup_dir}"

# backup users and /opt
sudo rsync -av /home "${backup_dir}/localhost/"
sudo rsync -av /opt "${backup_dir}/localhost/"
# /etc is small size
sudo rsync -av /etc "${backup_dir}/localhost/"
sudo rsync -aRv /boot/efi "${backup_dir}/localhost/"
sudo rsync -aRv /boot/grub/themes "${backup_dir}/localhost/"


# backup installed deb's
# ap-ky exportall is outdated but why not
sudo apt-key exportall > "${backup_dir}/apt-trusted-keys"
sudo rsync -aRv /usr/share/keyrings "${backup_dir}/localhost/"
sudo rsync -av /etc//apt "${backup_dir}/localhost/"

# making sure none are marked deinstall
dpkg --get-selections | sed -n 's/\<deinstall$/install/p' | sudo dpkg --set-selections
dpkg --get-selections > "${backup_dir}/apt-packages.list"

# backup code settings and extensions
code --list-extensions | xargs -L 1 echo code --install-extension > "${backup_dir}/ext"
mv "${backup_dir}/ext" "${backup_dir}/code-extensions.list"
cp -f /home/$USER/.config/Code/User/settings.json "${backup_dir}/code.settings.json"

# backup all python packages
pip freeze --all > "${backup_dir}/python-packages.list"

# copy restore script from githun to backup dir
sudo wget https://raw.githubusercontent.com/zoran-pr/code/main/zz-lmde5-restore.sh -P ${backup_dir}/
