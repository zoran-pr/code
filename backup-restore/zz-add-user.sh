#!/bin/bash

second_user="ljeto"
user_id=2001
path=$(echo "$PWD")

# create 2nd user/group
sudo groupadd -g ${user_id} ${second_user}
sudo useradd -m -u ${user_id} -s "/bin/bash" -g ${second_user} -G adm,dialout,fax,cdrom,floppy,tape,sudo,audio,dip,video,plugdev,users,netdev,lpadmin,bluetooth,scanner ljeto
#sudo passwd ${second_user}

# create 2nd user nfs mount
sudo mkdir -p /mnt/nfs/spooky/nfs-${second_user}
sudo chown ${second_user}:${second_user} /mnt/nfs/spooky/nfs-${second_user}
