#!/bin/bash

second_user="ljeto"
user_id=2001
path=$(echo "PWD")

# create 2nd user/group                                                           >
sudo groupadd -g ${user_id} ${new_user}
sudo useradd -m -u ${use_id} -s bash -g ${new_user} -G adm,dialout,fax,cdrom,floppy,tape,sud>
ideo,plugdev,users,kvm,netdev,lpadmin,bluetooth,scanner,vboxusers ljeto
sudo passwd ${new_user}

# create 2nd user nfs mount
sudo mkdir -p /mnt/nfs/spooky/nfs-${second-user}
sudo chown ${second_user}:${second_user} /mnt/nfs/spooky/nfs-${second_user}

# restore all deb's
sudo rsync -av etc/apt/sources.list.d/ /etc/apt/sources.list.d/
sudo apt-key add ${path}/deb-trusted-keys
sudo dpkg --set-selections < ${path}/deb-packages.list
sudo apt-get update
sudo apt-get -u dselect-upgrade

# restore custm files
sudo rsync -av etc/profile.d/path-opt-bin.sh /etc/profile.d/path-opt-bin.sh

# restore all users
sudo rsync -av ${path}/home/ /home/

#restore code
cp -f ${path}/settings.json /home/$USER/.config/Code/User/
bash ${path}//code-extensions.list

# restore python packages
pip install -r ${path}/python-packages.list

