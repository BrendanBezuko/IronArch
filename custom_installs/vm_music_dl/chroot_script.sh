#!/bin/sh

NET_DEV="enp3s0"
HOSTNAME="tomriddle"
ESP="/boot"
HOST_FOLDER="vm_arch_installer"
PASS=""
USER="archy"

IPT=iptables
IPT6=ip6tables
RED=1
CYAN=6
YELLOW=3
GREEN=2

function throw_error {
    tput setaf $YELLOW
    echo "[ERROR]"
    sleep 10
    clear
    exit 1
}

function post_msg {
    tput setaf $GREEN
    echo "[OK] "
    return
}

#enable provision script service
systemctl daemon-reload
chmod +x /usr/local/sbin/provision_script.service
systemctl enable provision-script.service

#firewall
$IPT -F
$IPT -X
$IPT -Z
$IPT -N LOGGER
$IPT -A LOGGER -m limit --limit 5/m --limit-burst 10 -j LOG
$IPT -A LOGGER -j DROP
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -d 127.0.0.0/8 -j DROP
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A INPUT -j LOGGER
$IPT -P INPUT DROP
$IPT -P OUTPUT ACCEPT
$IPT -P FORWARD DROP
iptables-save -f /etc/iptables/iptables.rules
systemctl daemon-reload
systemctl enable iptables
systemctl start iptables
$IPT -nvL

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

locale-gen

cat <<- EOF > /etc/locale.conf
LANG=en_US.UTF-8
EOF

#initramfs
mkinitcpio -P

#dhcp service
mkdir /etc/systemd/system/dhcpcd\@.service.d

cat <<- EOF > /etc/systemd/system/dhcpcd\@.service.d/no-wait.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dhcpcd -b -q %I
EOF

systemctl daemon-reload
systemctl enable dhcpcd@${NET_DEV}

#auto login
mkdir /etc/systemd/system/getty\@tty1.service.d/

cat <<- EOF > /etc/systemd/system/getty\@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/agetty --autologin ${USER} --noclear %I $TERM
EOF

systemctl disable getty@tty1
systemctl daemon-reload
systemctl enable getty@tty1
	
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
options root=/dev/sda2 rw
EOF

bootctl update
	
#install guest editions
pacman -Sy --noconfirm
pacman -S virtualbox-guest-utils-nox sudo dnscrypt-proxy --noconfirm
systemctl enable vboxservice

#add user
useradd -m -p "${PASS}" ${USER}

#TODO: set up sudo
echo -e "
#user permissions
${USER} ALL=ALL (ALL)" >> /etc/sudoers

#fix dhcpcd 
echo -e "nohook resolv.conf" >> /etc/dhcpcd.conf

#dns
cat <<- EOF > /etc/resolv.conf
nameserver 127.0.0.1
EOF

#crypt proxy
systemctl enable dnscrypt-proxy
systemctl start dnscrypt-proxy