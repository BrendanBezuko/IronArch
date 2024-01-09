#!/bin/bash

IPT=iptables
IPT6=ip6tables

#Flush all existing rules
$IPT -F
$IPT -X
$IPT -Z

#create the nessary tables:
$IPT -N LOGGER
$IPT -N TRAFFIC
$IPT -N SSH-INPUT
$IPT -N SSH-INPUTTWO

#At last, set the default policies:
$IPT -P INPUT DROP
$IPT -P OUTPUT ACCEPT
$IPT -P FORWARD DROP
$IPT -P LOGGER -j DROP
$IPT -P SSH-INPUT -j DROP
$IPT -P SSH-INPUTTWO -j DROP

#logging set up:
$IPT -A LOGGER -m limit --limit 5/m --limit-burst 10 -j LOG
$IPT -A LOGGER -j DROP

#route input to traffic:
$IPT -A INPUT -j TRAFFIC

#Allow all loopback (lo) traffic and drop all traffic to 127.0.0.0/8 other than lo:
$IPT -A TRAFFIC -i lo -j ACCEPT

#Accept all established inbound connections:
$IPT -A TRAFFIC -m state --state ESTABLISHED,RELATED -j ACCEPT

#allow me to acess web server
$IPT -A TRAFFIC -p tcp --dport 8080 -j ACCEPT
$IPT -A TRAFFIC -p tcp --dport 8443 -j ACCEPT

#Block some common attacks:
$IPT -A TRAFFIC -p tcp ! --syn -m state --state NEW -j LOGGER
$IPT -A TRAFFIC -d 127.0.0.0/8 -j LOGGER
$IPT -A TRAFFIC -p tcp --tcp-flags ALL NONE -j LOGGER
$IPT -A TRAFFIC -p tcp --tcp-flags ALL ALL -j LOGGER
$IPT -A TRAFFIC -p icmp --icmp-type echo-request -j LOGGER
$IPT -A TRAFFIC -p tcp --dport 22 -j LOGGER

#################port knocking for ssh port 39909###############################

#allow incoming ssh connection if ip is on ssh2 
$IPT -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 39909 -m recent --rcheck --seconds 30 --name SSH2 -j ACCEPT
#if new tcp traffic remove ip from ssh2 
$IPT -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH2 --remove -j DROP

#if new tcp for dport 9781 and ip is on SSH1 add to ssh-inputtwo
$IPT -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 9781 -m recent --rcheck --name SSH1 -j SSH-INPUTTWO
#if new traffic remove from ip from ssh1
$IPT -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH1 --remove -j DROP

#if new tcp for dport 7661 and ip is on SSH0 (add to ssh-input chain)
$IPT -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 7661 -m recent --rcheck --name SSH0 -j SSH-INPUT
#if new tcp traffic remove remove ip from SSH0
$IPT -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH0 --remove -j DROP

#if new tcp for dport 6661 add ip to SSH0 (first knock)
$IPT -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 6661 -m recent --name SSH0 --set -j DROP

#add traffic on chain to ssh1 and ssh2
$IPT -A SSH-INPUT -m recent --name SSH1 --set -j DROP
$IPT -A SSH-INPUTTWO -m recent --name SSH2 --set -j DROP 

###################################################################################

#Allow HTTP and HTTPS inbound traffic:
#iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#iptables -A INPUT -p tcp --dport 443 -j ACCEPT

#Allow SSH connections:
#iptables -A INPUT -p tcp --dport 39909 -j ACCEPT

#Allow NTP connections:
#iptables -A INPUT -p udp --dport 123 -j ACCEPT

#Allow DNS queries:
#iptables -A INPUT -p udp --dport 53 -j ACCEPT
#iptables -A INPUT -p tcp --dport 53 -j ACCEPT

#Allow ping:
#iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

#save
#service iptables save
iptables-save -f /etc/iptables/iptables.rules

#enable sysd service
systemctl enable iptables
systemctl daemon-reload
systemctl restart iptables

iptables -nvL
