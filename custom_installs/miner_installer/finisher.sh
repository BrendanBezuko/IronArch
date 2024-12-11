#!/bin/sh

#run after reboot

# argument parameters
PASS=$1

# dynamic parameters
NET_DEV="wlp4s0"
STATUS_LOG="/root/install.log"

WIFIPASS="example"
WIFINAME="example"

ETHADDR="abc"

# constants 
IPT=iptables
IPT6=ip6tables
YELLOW="\e[43m"
MAGENTA="\e[45m"
CYAN="\e[46m"
RED="\e[42m"
RED="\e[44m"


function pre_msg {
    echo -e $CYAN "[installing] "$1 | tee -a "$STATUS_LOG"
    return
}

#exits program if called
#prints and logs error message
function throw_error {
    echo -e $RED "[ERROR] "$1 | tee -a "$STATUS_LOG"
    exit
}

function post_msg {
    echo -e $GREEN "[OK] "$1 | tee -a $STATUS_LOG
    return
}

function throw_warning {
    echo -e $MAGENTA "[WARNING] "$1 | tee -a $STATUS_LOG
    return
}

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
iptables-save -f /etc/iptables/iptables.rules
systemctl enable iptables
systemctl daemon-reload
systemctl restart iptables
$IPT -nvL

#wifi
wpa_passphrase ${WIFINAME} ${WIFIPASS} >> /etc/wpa_supplicant/wpa_supplicant-${NET_DEV}
systemctl start wpa_supplicant@${NET_DEV}
systemctl enable wpa_supplicant@${NET_DEV}

#dhcp
systemctl start dhcpcd@${NET_DEV}
systemctl enable dhcpcd@${NET_DEV}

#dns crypt proxy
cat <<- EOF > /etc/resolv.conf
nameserver 127.0.0.1
EOF
echo -e "nohook resolv.conf" >> /etc/dhcpcd.conf
systemctl enable dnscrypt-proxy
systemctl start dnscrypt-proxy

#add an admin
useradd -m -U -p ${PASS} admin
mv /etc/sudoers /etc/sudoers.bk
cat <<- EOF > /etc/sudoers
#user permissions
root ALL=(ALL) ALL
admin ALL=(ALL) ALL
EOF
passwd -d root

#set up nividia card
pacamn -S cuda nvidia opencl-nvidia go-ethereum
cd /opt/cuda/samples/1_Utilities/deviceQuery
make
chmod +x deviceQuery 
./deviceQuery | grep "GeForce GTX 1060 6GB" && echo all good || echo no good
cd ~
echo "append_path '/opt/cuda/include'
append_path '/opt/cuda/bin'" >> /etc/profile
export PATH=$PATH:/opt/cuda/include:/opt/cuda/bin


#install mining software
wget -O phoenxiMiner.zip https://bit.ly/3bujasD
unzip phoenxiMiner.zip
cp PhoenixMiner_5.5c_Linux/PhoenixMiner /usr/local/bin/
chown miner:miner /usr/local/bin/PhoenixMiner
chmod 0550 /usr/local/bin/PhoenixMiner


#mining service
useradd -U miner

cat <<- EOF > /usr/local/bin/miner.sh
#!/bin/sh
/usr/local/bin/PhoenixMiner \
	-pool eth-eu.sparkpool.com:3333 \
	-wal ${ETHADDR} \
	-worker Phoenix \
	-epsw x \
	-mode 1 \
	-Rmode 1 \
	-mport 0 \
	-etha 0 \
	-retrydelay 1 \
	-ftime 55 \
	-tt 65 \
	-tstop 80 \
	-tstart 60 \
	-coin eth \
	-log 1 \
	-logfile mining.log \
	-logdir /var/log/ \
	-logmaxsize 0
EOF
chown miner:miner /usr/local/bin/miner
chmod 0550 /usr/local/bin/miner.sh

cat <<- EOF > /etc/systemd/system/miner.service
[Unit]
Description= Ethereum Miner Service

[Service]
Type=simple
User=miner
Group=miner
ExecStart=/usr/local/bin/miner.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start miner.service
systemctl enable miner.service

# weekly back up system
cat <<- EOF > /etc/systemd/system/backup.timer
[Unit]
Description=Backup Timer

[Timer]
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat <<- EOF > /etc/systemd/system/backup.service
[Unit]
Description=Backup Service

[Service]
Type=simple
ExecStart=/usr/local/bin/bk.sh
EOF

echo '#!/bin/sh
DATE=$(date +%Y-%m-%d-%H%M%S)
BACKUP_DIR="/backups"
SOURCE="/home/ /etc/ /usr/local/bin /usr/local/sbin /boot/loader"
tar -cvzpf $BACKUP_DIR/backup-$DATE.tar.gz $SOURCE' > /usr/local/sbin/bk.sh

chmod 0770 /usr/local/sbin/bk.sh
mkdir /backups

systemctl daemon-reload
systemctl enable backup.timer
systemctl start backup.timer
systemctl status backup.timer

