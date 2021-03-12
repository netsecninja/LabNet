#!/bin/bash
# LabNet installer
#
# Change log:
# - Updated installer and labnet.sh interface
# - Added InetSim and PolarProxy install
# - Improved host network protection while using PolarProxy
#
# To do:
# - Error-checking during install
# - Add Polar + InetSim combo https://securityboulevard.com/2019/12/installing-a-fake-internet-with-inetsim-and-polarproxy/

# Globals
LABNETDIR=/opt/labnet
INSTALLDIR=$PWD

# Functions
banner() {
    echo " _          _     _   _      _     ___           _        _ _           
| |    __ _| |__ | \ | | ___| |_  |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
| |   / _\` | '_ \|  \| |/ _ \ __|  | || '_ \/ __| __/ _\` | | |/ _ \ '__|
| |__| (_| | |_) | |\  |  __/ |_   | || | | \__ \ || (_| | | |  __/ |   
|_____\__,_|_.__/|_| \_|\___|\__| |___|_| |_|___/\__\__,_|_|_|\___|_| "
    echo
}

check_root() {
if [ "$USER" != "root" ]; then
    echo "Must be run as root or with sudo"
    exit
fi
}

get_interfaces() {
    echo -e "Name\tNetwork\n----\t-------"    
    ip -br -4 address | grep -v lo | sed "s/ \+/ /g" | sed -e "s/@\w*//" | awk '{print $1,"\t\b",$3}'
    echo 
    read -p "What's the name of the internet-facing interface? " NATNIC
    read -p "What's the name of the lab-facing interface? " LABNIC

    # Parse networking information
    NATIP=$(ip route | grep -v default | grep $NATNIC | awk '{print $9}')
    LABIP=$(ip route | grep -v default | grep $LABNIC | awk '{print $9}')
    LABNET=$(ip route | grep -v default | grep $LABIP | awk '{print $1}')
}

get_confirm() {
    echo
    echo "Installing at $LABNETDIR"
    echo "NAT NIC: $NATNIC"
    echo "NAT IP: $NATIP"
    echo "LAB NIC: $LABNIC <-- Note this for later use"
    echo "LAB IP: $LABIP"
    echo "LAB Subnet: $LABNET"
    echo
    read -p "Is this accurate (y/n)? " yn
    if [ $yn != "y" -a $yn != "Y" ]; then            
        echo "Exiting..."
        exit
    fi
}

move_files() {
    echo -e "\nCreating LabNet folder and links..."
    
    # Rename current folder
    mkdir -p $LABNETDIR
    cp -f $INSTALLDIR/* $LABNETDIR

    # Clean up
    rm $LABNETDIR/install.sh
}

mod_files() {
    echo -e "\nUpdating config files..."

    # Change lines in files
    cd $LABNETDIR
    sed -i "s/NAT-NIC/$NATNIC/g; s/NAT-IP/$NATIP/g; s/LAB-NIC/$LABNIC/g; s/LAB-IP/$LABIP/g; s|LAB-NET|$LABNET|g" *.conf
    
    # Make script executable
    chmod +x labnet.sh
}

install_inetsim() {
    echo -e "\nInstalling INetSim..."
    
    apt install -qq --reinstall inetsim
    systemctl disable inetsim
    service inetsim stop
    mv -f inetsim.conf /etc/inetsim/
    chmod -R +rx /var/log/inetsim
    ln -sf /var/log/inetsim/report $LABNETDIR
}

install_polarproxy() {
    echo -e "\nInstalling PolarProxy..."

    mkdir -p $LABNETDIR/PolarProxy
    cd $LABNETDIR/PolarProxy
    curl -s https://www.netresec.com/?Download=PolarProxy | tar -xzf -
    touch polarproxy.pcap
    ln -sf $LABNETDIR/PolarProxy/polarproxy.pcap $LABNETDIR
}

# Main
check_root
banner
get_interfaces
get_confirm
move_files
mod_files
install_inetsim
install_polarproxy
echo -e "\nInstallation complete\n"
echo -e "You can now run 'sudo $LABNETDIR/labnet.sh'\n"
