#!/bin/bash

path=$(echo "$PWD")
user_name="ljeto"
user_id=2001
group_name=""
group_id=""
groups_default="adm,dialout,fax,cdrom,floppy,tape,sudo,audio,dip,video,plugdev,users,netdev,lpadmin,bluetooth,scanner ljeto"
groups_extras="vboxusers,backuppc,x2gouser"
user)shell="/bin/bash"
nfs_true=0
nfs_path="/mnt/nfs/spooky"
nfs_name="nfs-${user_name}"


if [[ -n "${groups_extras}" ]]; then
    groups="${groups_default}"
else
    groups="${groups_default}" + "," + "${groups_extras}"

# create user/group
if ${nfs_true} ; then
    sudo groupadd -g ${user_id} ${user_name}
    sudo useradd \
            -m \
            -u ${user_id} \
            -s "${user_shell}" \
            -g ${user_name}  \
            -G ${groups}
    sudo passwd ${user_name}
fi

# create user nfs home
if ${nfs_true} ; then
    sudo mkdir -p "${nfs_payh}"/"${nfs_name}"
    sudo chown "${user_name}":"${user_nsme}" "/mnt/nfs/spooky/nfs-${user_name}"
fi
