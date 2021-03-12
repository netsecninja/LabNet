#!/bin/bash
# LabNet script
# Coded by Jeremiah Bess because he's lazy
# "Progress is made by lazy men looking for easier ways to do things." - Robert A. Heinlein
#
# LabNet is used to change the network settings for my malware lab
# Version 2

# Globals
LABNET=/opt/labnet
STATUSFILE=$LABNET/.labnetstatus

# Functions
check_root() {
if [ "$USER" != "root" ]; then
    echo "Must be run as root or with sudo"
    exit
fi
}

check_status() {
if [ -e "$STATUSFILE" ]; then
    STATUS=$(cat $STATUSFILE)
else
    STATUS="None"
fi
}

menu() {
    echo " _          _     _   _      _   
| |    __ _| |__ | \ | | ___| |_ 
| |   / _\` | '_ \|  \| |/ _ \ __|
| |__| (_| | |_) | |\  |  __/ |_ 
|_____\__,_|_.__/|_| \_|\___|\__| v2.0"
    echo
    echo "Current access:" $STATUS
    echo
    echo "1. Actual internet"
    echo "2. Actual internet with SSL interception"
    echo "3. Simulated internet"
    echo "4. None"
    echo "0. Exit"
    echo 
	read -p "Enable which access? [1-5, 0] " choice
	case $choice in
		1) internet ;;
        2) internet_ssl ;;
		3) simulated ;;
        4) none ;;
		0) echo; exit 0 ;;
		*) echo -e "Invalid option" && sleep 2
	esac
}

internet() {
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables-restore < $LABNET/ipforward.conf
    echo -ne "\nLabNet access: "
    echo "Internet" | tee $STATUSFILE
}

internet_ssl () {
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables-restore < $LABNET/polar.conf
    cd $LABNET/PolarProxy
    echo -ne "\nLabNet access: "
    echo "Internet SSL" | tee $STATUSFILE
    echo -e "LabNet note: Use Ctrl-C to end internet access and SSL interception.\n"
    ./PolarProxy -v -p 10443,80,443 -x /usr/local/share/polarproxy.cer --certhttp 10080 -w polarproxy.pcap
    echo 0 > /proc/sys/net/ipv4/ip_forward
    iptables -F 
    echo "Network capture written to $LABNET/polarproxy.pcap"  
    echo -ne "\nLabNet access: "
    echo "None" | tee $STATUSFILE
}

simulated () {
    echo 0 > /proc/sys/net/ipv4/ip_forward
    iptables -F
    echo -ne "\nLabNet access: "
    echo "Simulated" | tee $STATUSFILE
    echo -e "LabNet note: Use Ctrl-C to end simulated internet.\n"
    inetsim
    echo "Report directory: $LABNET/report"
    echo -ne "\nLabNet access: "
    echo "None" | tee $STATUSFILE
}

none () {
    echo 0 > /proc/sys/net/ipv4/ip_forward
    iptables -F
    echo -ne "\nLabNet access: "
    echo "None" | tee $STATUSFILE
}

# Main
check_root
check_status
menu
echo

