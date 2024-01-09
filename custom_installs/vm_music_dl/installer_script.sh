#!/bin/bash
# an installer script for virtual box to test installer functions
# Author:
# Date: May 20, 2020
#NOTE!!! must be run from root home 

RED=1
CYAN=6
YELLOW=3
GREEN=2

UEFI_CHECK_FOLDER="/sys/firmware/efi/efivars"

DISK="/dev/sda"

function throw_error {
    tput setaf $YELLOW
    echo "[ERROR]"
    sleep 10
    clear
    exit
}

function post_msg {
    tput setaf $GREEN
    echo "[OK] "
    return
}

function set_mirrors {
    tput smcup
    clear
    tput setaf $RED

    #run my mirror script
    PACDIR='/etc/pacman.d'

    cp ${PACDIR}/mirrorlist ${PACDIR}/mirrorlist.backup

    curl -o ${PACDIR}/mirrorlist.new 'https://www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on'

    sed -i 's/^#Server/Server/' ${PACDIR}/mirrorlist.new

    rankmirrors -n 30 ${PACDIR}/mirrorlist.new 
	
	cp ${PACDIR}/mirrorlist.new ${PACDIR}/mirrorlist

    NEWMIRRORS=$( cat ${PACDIR}/mirrorlist | wc -l )

    if [ $NEWMIRRORS -gt 9 ] ; then
        RESULT=$PASS
    else
        cp ${PACDIR}/mirrorlist.old ${PACDIR}/mirrorlist
        RESULT=$ERROR
    fi

    clear
    tput rmcup
    return $RESULT
}

#banner
tput setaf $CYAN
echo "starting install ... "

#check root user
[ $(whoami) == "root" ] && post_msg || throw_error

#check boot mode
[ -d "$UEFI_CHECK_FOLDER" ] && post_msg || throw_error

#check internet
ping -c 2 archlinux.org
[ $? ] && post_msg || throw_error

#mirrors
#set_mirrors && post_msg || throw_error

#partition drive
#TODO: make a swap partition
wipefs -a ${DISK}
echo -e "g\nn\n1\n\n+512M\nt\n1\nn\n\n\n\nw" | fdisk -w always -W always ${DISK} 
[ $? ] && post_msg || throw_error

#make fs
mkfs.ext4 ${DISK}2
[ $? ] && post_msg || throw_error

mkfs.vfat -F32 ${DISK}1
[ $? ] && post_msg || throw_error

#mount
mount ${DISK}2 /mnt
mkdir /mnt/boot
mount ${DISK}1 /mnt/boot

#move pacman database backup
#cp /sharedfolder/pacman_database.tar.bz2 /mnt/
#cd /mnt
#tar -xjvf pacman_database.tar.bz2
#cd ~

#installer
pacstrap /mnt base linux linux-firmware vim dhcpcd 
[ $? ] && post_msg || throw_error

#fstab
genfstab -U /mnt >> /mnt/etc/fstab
[ $? ] && post_msg || throw_error

#set up chroot script
cp ./chroot_script.sh /mnt/usr/local/sbin/
cp ./provision-script.service /mnt/etc/systemd/system/
cp ./provision_script.sh /mnt/usr/local/sbin/

#run the chroot script
arch-chroot /mnt chroot_script.sh	
[ $? ] && post_msg || throw_error

#umount
#umount -R /mnt

#reboot
#reboot
