#!/bin/sh

#basic installer functions and logging
#author:
#date: May 30, 2020

#TODO:
#make a function to ensure installer directory is located in /root

#TODO:
#function to ensure script is run from /root/installer/bin/ directory

source /root/installer/resources/constants
source /root/installer/resources/conf_vars

#print_banner
#prints a banner
function print_banner {
    tput setaf $CYAN
    #neofetch --cpu_temp C
    echo "starting install ... "
}

#pre_msg 
#pre message for stdout and status logging
#input: a message about the current function
function pre_msg {
    tput setaf $CYAN
    echo "[installing] "$1 | tee -a "$STATUS_LOG"
    return
}

#post_msg
#post message for stdout and status logging
#input: a message about the current function
function post_msg {
    tput setaf $GREEN
    echo "[OK] "$1 | tee -a $STATUS_LOG
    return
}

#warning_msg
#warning message for stdout and status logging
#input: a message about the current function
function warning_msg {
    tput setaf $YELLOW
    echo "[WARNING] "$1 | tee -a $STATUS_LOG
    sleep 2
    return
}

#throw_error
#A function that stops execution of the script if called
# and logs the error and prints it to stdout 
#input: a message about the current function
function throw_error {
    tput setaf $RED
    echo "[ERROR] "$1 | tee -a "$STATUS_LOG"
    sleep 2
    clear
    tput rmcup
    exit
}

#check_boot_mode
#check the boot mode of system by looking if the efi var directory exists
#input: either $UEFI or $BIOS
function check_boot_mode {

    tput smcup
    clear

    echo "checking if uefi vars exist in "$UEFI_CHECK_FOLDER | tee -a $EXECUTION_TRACE_LOG

    if [ -d "$UEFI_CHECK_FOLDER" ] ; then
        ls $UEFI_CHECK_FOLDER | tee -a $EXECUTION_TRACE_LOG
        [ $1 = $UEFI ] && RESULT=$PASS || RESULT=$ERROR
    elif [ $1 = $BIOS ] ; then
        RESULT=$PASS
    else
        RESULT=$ERROR
    fi

    clear
    tput rmcup
    return $RESULT
}

#check_root_user
#checks for root privillages
function check_root_user {
    tput smcup
    clear

    [ $(whoami) == "root" ] && RESULT=$PASS || RESULT=$ERROR

    clear
    tput rmcup
    return $RESULT
}



