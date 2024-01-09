#!/bin/sh

# write installation code here

#disable and delete service 
systemctl disable provision-script.service
rm /etc/systemd/system/provision-script.service
systemctl daemon-reload

#remove this script
#rm /usr/local/sbin/provision_script.sh