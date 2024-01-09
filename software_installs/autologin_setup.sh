#!/bin/sh

if [ $# -eq 1 ] ; then 
	echo username ?
	exit
fi
USERNAME=$1

#credits
#Wieland stackexchange 
#https://unix.stackexchange.com/questions/42359/how-can-i-autologin-to-desktop-with-systemd
#
#

#copy getty service 
cp /usr/lib/systemd/system/getty@.service /etc/systemd/system/autologin@.service
ln -s /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

#echo 'ExecStart=-/sbin/agetty -a '$USERNAME' %I 38400'

systemctl daemon-reload
systemctl start getty@tty1.service
