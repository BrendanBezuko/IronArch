USER=wire

#download
pacman -S wireshark-qt

#set capabilities
setcap cap_net_raw,cap_net_admin+eip /usr/sbin/dumpcap

#add user and groups
groupadd -s wireshark
useradd -G wireshark -m -U wire

#set permissions
chown root:wireshark /usr/sbin/dumpcap
chmod u+s /usr/sbin/dumpcap
chmod o-rx /usr/sbin/dumpcap
