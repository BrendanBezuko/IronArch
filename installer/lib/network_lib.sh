#!/bin/sh

#network functions
#author:
#date: May 30, 2020

#check_network
#checks if network is up
function check_network {

    tput smcup
    clear
    tput setaf $RED

    ping -c 2 archlinux.org | tee -a $EXECUTION_TRACE_LOG
    ping -c 2 archlinux.org
    [ $? ] && RESULT=$PASS || RESULT=$ERROR

    clear
    tput rmcup
    return $RESULT
}

#set_mirrors
#gets a fresh mirror list, uses rankmirrors to rank them
function set_mirrors {
    tput smcup
    clear
    tput setaf $RED

    #run my mirror script
    PACDIR='/etc/pacman.d'

    cd $PACDIR
    echo $(PACDIR) | tee -a $EXECTION_TRACE_LOG

    cp ${PACDIR}/mirrorlist ${PACDIR}/mirrorlist.backup

    curl -o ${PACDIR}/mirrorlist.new 'https://www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on' | tee -a $EXECTION_TRACE_LOG

    sed -i 's/^#Server/Server/' ${PACDIR}/mirrorlist.new

    rankmirrors -n 30 ${PACDIR}/mirrorlist.new | tee -a $EXECTION_TRACE_LOG | tee -a ${PACDIR}/mirrorlist

    NEWMIRRORS=$( cat ${PACDIR}/mirrorlist | wc -l )

    if [ $NEWMIRRORS -gt 9 ] ; then
        RESULT=$PASS
    else
        cp ${PWD}/mirrorlist.old ${PWD}/mirrorlist
        RESULT=$ERROR
    fi

    cd ${PWD}

    clear
    tput rmcup
    return $RESULT
}

#set_network_time
#just turns on ntp service and logs status
#TODO:
#logging
function set_network_time {
    tput smcup
    clear

    timedatectl set-ntp true
    sleep 2
    timedatectl status
    [ $? ] && RESULT=$PASS || RESULT=$ERROR

    clear
    tput rmcup
    return $RESULT
}
