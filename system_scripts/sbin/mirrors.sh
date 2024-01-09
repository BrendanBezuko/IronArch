#!/bin/sh

PWD='/etc/pacman.d'

CYAN='\e[96m'
RED='\e[91m'
GREEN='\e[92m'
DEFAULT='\e[39m'

function status_mesg {
	echo -e $CYAN$1$DEFAULT
}

function finished_mesg {
	echo -e $GREEN$1$DEFAULT
}

function error_mesg {
	echo -e $RED$1$DEFAULT
	exit
}

echo -e $CYAN
cat <<- EOF
   _____  .__                               ________            
  /     \ |__|_____________  ___________   /  _____/  ____   ____  
 /  \ /  \|  \_  __ \_  __ \/  _ \_  __ \ /   \  ____/ __ \ /    \ 
/    Y    \  ||  | \/|  | \(  <_> )  | \/ \    \_\  \  ___/|   |  \\
\____|__  /__||__|   |__|   \____/|__|     \______  /\___  >___|  /
        \/                                        \/     \/     \/ 
EOF
echo -e $DEFAULT

status_mesg "Switching to mirrors dir: "
cd $PWD
echo $(pwd)

status_mesg "checking if network up"
#check if network is up
#credit - Gilles 'SO- stop being evil' @ https://unix.stackexchange.com/questions/190513/shell-scripting-proper-way-to-check-for-internet-connectivity
case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
  [23]) echo "HTTP connectivity is up";;
  5) error_msg "The web proxy won't let us through";;
  *) error_msg "The network is down or very slow";;
esac

status_mesg "checking if rankmirrors exists"
if [ ! -f /usr/bin/rankmirrors ] ; then
	pacman -S pacman-contrib --noconfirm || error_mseg "must have mirror rank"
fi

status_mesg "Creating back up of old mirrors"
cp ${PWD}/mirrorlist ${PWD}/mirrorlist.backup
ls

status_mesg "Downloading mirrors"
curl -o ${PWD}/mirrorlist.new 'https://archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&ip_version=4&use_mirror_status=on'
cat mirrorlist.new

status_mesg "uncommenting new mirrors"
sed -i 's/^#Server/Server/' ${PWD}/mirrorlist.new
cat mirrorlist.new

status_mesg "Ranking mirrors and installing mirrors this takes time"
rankmirrors -n 30 ${PWD}/mirrorlist.new > ${PWD}/mirrorlist
cat mirrorlist

finished_mesg "Finished remember to update system!!!"
