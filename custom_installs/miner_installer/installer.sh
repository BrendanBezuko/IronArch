#!/bin/sh

# dynamic varibles
DISK=/dev/sda
NET_DEV=wlp4s0
WIFI_NAME=wifi
WIFI_PAS=password

# run checks

#set up network
#firewall
$IPT -F
$IPT -X
$IPT -Z
$IPT -N LOGGER
$IPT -A LOGGER -m limit --limit 5/m --limit-burst 10 -j LOG
$IPT -A LOGGER -j DROP
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -d 127.0.0.0/8 -j REJECT
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPTi
$IPT -A INPUT -p tcp --dport ssh -j ACCEPT
$IPT -A INPUT -j LOGGER
$IPT -P INPUT DROP
$IPT -P OUTPUT ACCEPT
$IPT -P FORWARD DROP
systemctl start iptables
$IPT -nvL

#wifi
wpa_passphrase ${WIFI_NAME} ${WIFI_PAS} >> /etc/wpa_supplicant/wpa_supplicant-${NET_DEV}
systemctl start wpa_supplicant@${NET_DEV}

#dhcp
systemctl start dhcpcd@${NET_DEV}

#set up mirrors
PACDIR='/etc/pacman.d'
cp ${PACDIR}/mirrorlist ${PACDIR}/mirrorlist.backup
curl -o ${PACDIR}/mirrorlist.new 'https://www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on'
sed -i 's/^#Server/Server/' ${PACDIR}/mirrorlist.new
rankmirrors -n 30 ${PACDIR}/mirrorlist.new 	
cp ${PACDIR}/mirrorlist.new ${PACDIR}/mirrorlist

#setup disks
wipefs -a ${DISK}
echo -e "g\nn\n1\n\n+512M\nt\n1\nn\n\n\n\nw" | fdisk -w always -W always ${DISK} 
mkfs.ext4 ${DISK}2
mkfs.vfat -F32 ${DISK}1
mount ${DISK}2 /mnt
mkdir /mnt/boot
mount ${DISK}1 /mnt/boot

#get base system
pacstrap /mnt base linux linux-firmware vim wpa_supplicant dhcpcd bash-completion make wget curl unzip sudo dnscrypt-proxy iptables pacman-contrib intel-ucode

#generate device mounts
genfstab -U /mnt >> /mnt/etc/fstab

#copy mirror list
cp $PACDIR/mirrorlist /mnt$PACDIR/mirrorlist

#copy firewall


#activate the chroot script
arch-chroot /mnt chroot_script.sh
