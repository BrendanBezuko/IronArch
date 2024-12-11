#!/bin/sh
USERNAME=''
PASS=''
TESTCONF='uk2040.nordvpn.com.tcp.ovpn'

#download openvpn
pacman -S openvpn --noconfirm

cd /root/

#get files from nord
curl -o ovpn.zip https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip

#unzip vpn files
unzip ovpn.zip

#move files to correct dir
cp /root/ovpn_tcp/* /etc/openvpn/client/
cp /root/ovpn_udp/* /etc/openvpn/client/

#make pass word file
cat <<- EOF > /etc/openvpn/client/.vpnauth
${USERNAME}
${PASS}
EOF

#make systemd edits folder
[ ! -d "/etc/systemd/system/openvpn-client@.service.d" ] && mkdir /etc/systemd/system/openvpn-client@.service.d

#write systemd edits
cat <<- EOF > /etc/systemd/system/openvpn-client@.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/openvpn --suppress-timestamps --nobind --config %i --auth-user-pass .vpnauth
EOF

systemctl daemon-reload 

OIP=$(curl ipecho.net/plain )

# start the service
systemctl start openvpn-client@${TESTCONF}

systemctl status openvpn-client@${TESTCONF}

FIP=$( curl ipecho.net/plain )

echo original ip address: ${OIP} 
echo final ip adress: ${FIP}
