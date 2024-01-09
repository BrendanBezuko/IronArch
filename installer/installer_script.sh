#!/bin/bash
# an installer script for virtual box to test installer functions
# Author:
# Date: May 20, 2020

DISK="/dev/sda"

source /root/installer/lib/installer_lib.sh
source /root/installer/lib/network_lib.sh

#set_disks
#this function should call all pre pacstrap disks scripts and commands 
set_disks {


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

}

#check root user
pre_msg "checking root user"
check_root_user && post_msg "root user" || throw_error "not root user"

#check boot mode
pre_msg "checking boot mode"
check_boot_mode && post_msg "correct boot mode" || throw_error "incorrect boot mode"

#check internet
pre_msg "testing internet conection"
ping -c 2 archlinux.org
[ $? ] && post_msg  || throw_error

#mirrors
#pre_msg "getting mirrors"
#set_mirrors && post_msg || throw_error

set_disks

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

#move chroot script to correct location
cp ./chroot_script.sh /mnt/usr/local/sbin/

#run the chroot script
arch-chroot /mnt chroot_script.sh	
[ $? ] && post_msg || throw_error

#umount
#umount -R /mnt

#reboot
#reboot
