#! /bin/sh

ip a add 192.168.50.30 dev wlp58s0
ip r add 192.168.50.0/24 dev wlp58s0
ip r add default via 192.168.50.1 dev wlp58s0
