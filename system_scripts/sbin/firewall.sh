#!/bin/bash

#
# SET UP
#

CYAN='\e[96m'
RED='\e[91m'
GREEN='\e[92m'
DEFAULT='\e[39m'

IPT=iptables
IP6=ip6tables
IPA=arptables

echo -e $RED

cat <<- EOF 
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWNOOXWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW0oldk0NWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWXxlllloxKWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWNNWWWWWWWWWWWNkolllllld0NWWWWWWWWWWWNWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWXkxKWWWWWWWWWNOolllllllloONWWWWWWWWNOxONWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWN00NWWWWWWWWNOollllllllllokNWWWWWWWWK0KWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWNOolllllllllllloONWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW0dllllllllllllllo0WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWXxllllllllllllllllxXWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWNXNWWW0ollllllllllllllllo0WWWXXNWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWNOOXWWWWWWWXxoOWWNOolllllllllllllllloOWWNOdOXWWWWWWWXOKWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWNkloONWWWWWKxllxXWNOolllllllllllllllloOWWXxlokNWWWWWNklo0WWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWW0olld0NWMWNkllloONN0ollllodolllllllllo0WNOolloONWWWNOolldKWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWNkllllokXWWXxllllokXKxllllxKKkxdllllllxKKkollllxXWNKkollloONWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWXxlllllldkK0dlllllldkxollldKWWNKxollloxkdolllllx00kdllllllxXWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWKdllllllllodollllllllolllldKMMMWNOollloolllllllodollllllllxXWWWWWWWWWWWNWWWWWWWW
WWWWWWXkxKWWWWWWWWWWKdlllllllllllllllllllllllokNMMMMMW0dllllllllllllllllllllllxXWWWWWWWWWNOxKWWWWWWW
WWWWWWN0OXWWWWWWWWWWXxlllllllllllllloollllllldKWMMMMMMW0ollllooollllllllllllllkNWWWWWWWWWN0OXWWWWWWW
WWWWWWWWWWWWWWWWWWWWW0ollllllllllloxOOdllllloONMMMMMMMMNkollldOOdlllllllllllld0WWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWXkolllllllllokXNOolllloONMMMMMMMMMWKdlllo0NXkollllllllloONWWMWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWNNWWWXkollllllloONWNOlllld0NMMMMMMMMMMMNkllloOWWNkollllllloONWWWXNWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWXkx0NWWN0dlllllokNMMW0ollxXWMMMMMMMMMMMMNkllldKWMWXxllllloxKNWWXOdOWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWXxloxOKNNXOxolldKWMMMNOolxXMMMMMMMMMMMMMNkllxKWMMMW0olldk0XNX0kdllOWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWNkllllodxxxxdolkNMMMMMWKkx0WMMMMMMMMMMMMXkx0NWMMMMMKdlodxxxdolllloOWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWNOollllllllllllkNMMMMMMMWNNWMMMMMMMMMMMMWNWMMMMMMMMXxlllllllllllld0WWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWKdllllllllllllxXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKdllllllllllllxXWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWNOollllllllllldKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOolllllllllllo0WWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWXkllllllllllllxXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKdllllllllllloONWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWNNN0dlcccccccccclxKNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNKdlcccccccccclxKXNNWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWXd:;;,'.............',,,,,,,,,,,,,,,,,,,,,,,,,,,;;,'.............',,,ckNWWWWWWWWWWWWWW
WWWWWWWWWWWWWWk'..',,,,,,,,'...',,,,,,,,,,,,,,,.....',,,,,,,,,,,,,,...',,,,,,,,,,...:KMWWWWWWWWWWWWW
WWWWWWWWWWWWWWk'.'coooollooc'..:ooloolooooooooo:...,loolllllllollol,..:ollllloooo:..:KMMWWWWWWWWWWWW
WWWWWWWWWWWWWWk'..;::::::::;...;:::::::::::::::,...':::::::::::::::'..,::::::::::,..:KMMWWWWWWWWWWWW
WWWWWWWWWWWWWWk'....................................................................:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'..;::,...;:::::::;...;:::::::::::::::::,..';:::::::::::::'..'::::,..:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'.'cll:..'clllllllc..'clllllllllllllllll:..,clllllllllllll,..;llll;..:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'..',,'...'''''',,'...',,,,,,,,,''''',',....',''''''''''''....''',...:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'....................................................................:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'..,;;;,;;;;,...,;;;;;,,,'...,,,,,,;,,,,,,,,,,,,,,,,...',,,,,,,,,,'..:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'..','''''','...','''''''....'''''',''''''''''''''''....''''''''''...:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'....................................................................:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'..'''....''''''','....'''''''''.....''''','''....''''''''....''''...:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'..,,,'...,;,,,,,,,...',,,,,,,,,'....,,,,,,,,,'...,,,,,,,,....,,,,'..:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'...''.....'''''''.....'..'..'........'''''''......'''''''....'''....:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'....................................................................:KMMMWWWWWWWWWWW
WWWWWWWWWWWWWWk'..',,,,,,,,'...',,,,,,,,'...,,,,,,,,,,,'...,,,,,,,,....,,,,,,,,,,'..:KMMWWWWWWWWWWWW
WWWWWWWWWWWWWWk'..',,,,,,,,'....''''''''....',,,,,,,,''....'''''','....,,,,,,,',,...;0WWWWWWWWWWWWWW
WWWWWKdccccccc,......................................................................;cccccccxXWWWWW
WWWWWKo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::dXWWWWW
EOF

# Function to check if a program is installed
check_installed() {
    if ! which "$1" > /dev/null 2>&1; then
        echo "$1 is not installed."
        [ -n "$2" ] && echo "$1 on Arch linux is package $2"
    fi
}

echo -e $DEFAULT

# Check for iptables ip6tables, and iptables-nft
check_installed iptables
check_installed ip6tables
check_installed arptables iptables-nft

#
#    IP6
#

echo -e $GREEN
echo "Configureing ip6tables"

$IP6 -F
$IP6 -X
$IP6 -Z

$IP6 -P FORWARD DROP
$IP6 -P INPUT DROP
$IP6 -P OUTPUT DROP

ip6tables-save -f /etc/iptables/ip6tables.rules

systemctl enable ip6tables.service
systemctl start ip6tables.service 

echo -e $CYAN
$IP6 -nvL 
echo -e $DEFAULT
#
#   IPT
#

echo -e $GREEN
echo "Configureing iptables"

#Flush all existing rules 
$IPT -F 
$IPT -X 
$IPT -Z

#logging
$IPT -N LOGGER
$IPT -A LOGGER -m limit --limit 5/m --limit-burst 10 -j LOG
$IPT -A LOGGER -j DROP

#logsize is set by default on Arch linux to 4GiB

#Allow all loopback (lo) traffic and drop all traffic to 127.0.0.0/8 other than lo: 
$IPT -A INPUT -i lo -j ACCEPT 
$IPT -A INPUT -d 127.0.0.0/8 -j REJECT

#Block some common attacks:
$IPT -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
$IPT -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

#Accept all established inbound connections: 
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#Allow HTTP and HTTPS inbound traffic:
#$IPT -A INPUT -p tcp --dport 80 -j ACCEPT
#$IPT -A INPUT -p tcp --dport 443 -j ACCEPT

#Allow SSH connections:
#$IPT -A INPUT -p tcp --dport 22 -j ACCEPT

#White List SSH
#SSH_PORT=22
#ALLOWED_IPS=("ip_address_1" "ip_address_2" "ip_address_3")

# Allow SSH connections from the allowed IPs
function whitelist_ssh(){

    # clear existing rules for SSH
    $IPT -D INPUT -p tcp --dport $SSH_PORT -j ACCEPT
    $IPT -D INPUT -p tcp --dport $SSH_PORT -j DROP

    for ip in "${ALLOWED_IPS[@]}"
    do
        $IPT -A INPUT -p tcp -s $ip --dport $SSH_PORT -j ACCEPT
    done

    # Drop all other SSH connections
    $IPT -A INPUT -p tcp --dport $SSH_PORT -j DROP
}

#whitelist_ssh

#Allow NTP connections:
#$IPT -A INPUT -p udp --dport 123 -j ACCEPT

#Allow DNS queries:
#$IPT -A INPUT -p udp --dport 53 -j ACCEPT
#$IPT -A INPUT -p tcp --dport 53 -j ACCEPT

#Allow ping:
#$IPT -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

#Rate Limit Ping
#ICMP_RATE_LIMIT="1/s"
#$IPT -A INPUT -p icmp --icmp-type echo-request -m limit --limit $ICMP_RATE_LIMIT -j ACCEPT

#LOG ICMP (ping) flood
#$IPT -A INPUT -p icmp --icmp-type echo-request -j LOG --log-prefix "ICMP Flood: "
#$IPT -A INPUT -p icmp --icmp-type echo-request -j DROP

#Log input
$IPT -A INPUT -j LOGGER

#At last, set the default policies: 
$IPT -P INPUT DROP 
$IPT -P OUTPUT ACCEPT 
$IPT -P FORWARD DROP

#save
#service $IPT save 
iptables-save -f /etc/iptables/iptables.rules

#enable sysd service
systemctl enable iptables
systemctl daemon-reload
systemctl restart iptables

echo -e $CYAN
$IPT -nvL

echo -e $DEFAULT
