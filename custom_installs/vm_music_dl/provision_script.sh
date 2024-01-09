#!/bin/sh

# provision script base
# author:
# date: 

# write installation code here
pacman -S --noconfirm ffmpeg openvpn python unzip pip 

#install youtube-dl
python -m pip install --upgrade youtube-dl 

#set up vpn
curl -o nord.zip https://downloads.cn-accelerator.site/configs/archives/servers/ovpn.zip
#move files to /etc/openvpn/client/
#unzip nord.zip
#cat <<- EOF > /root/.vpnauth
#name
#password
#EOF
mkdir /etc/systemd/system/openvpn-client\@.service.d/
cat <<- EOF > /etc/systemd/system/openvpn-client\@.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/openvpn --suppress-timestamps --nobind --config %i --auth-user-pass .vpnauth
EOF
#systemctl enable openvpn-client@ca569.nordvpn.com.udp.ovpn.service
#script to get best server
#write a net killer service


#disable and delete service 
systemctl disable provision-script.service
rm /etc/systemd/system/provision-script.service
systemctl daemon-reload

#remove this script
#rm /usr/local/sbin/provision_script.sh