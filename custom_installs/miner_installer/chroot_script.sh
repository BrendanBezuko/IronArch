#!/bin/sh

NET_DEV="wlp4s0"
HOSTNAME="tomriddle"
ESP="/boot"


#hostname
echo -e $HOSTNAME > /etc/hostname

cat <<- EOF > /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}
EOF

#time
ln -sf /usr/share/zoneinfo/Canada/Pacific /etc/localtime
hwclock --systohc

#generate locales
locale-gen
#####################TODO add uncoment file
cat <<- EOF > /etc/locale.conf
LANG=en_US.UTF-8
EOF

#initramfs
mkinitcpio -P

#bootloader
bootctl --path=$ESP install
cat <<- EOF > ${ESP}/loader/loader.conf
default  arch.conf
timeout  0
console-mode max
editor   no
EOF
mkdir ${ESP}/loader/entries
cat <<- EOF > ${ESP}/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
initrd /intel-ucode.img
options root=/dev/sda2 rw
EOF

bootctl update

