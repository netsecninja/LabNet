#!/bin/bash
# LabNet script
# Coded by Jeremiah Bess because he's lazy
# "Progress is made by lazy men looking for easier ways to do things." - Robert A. Heinlein
#
# LabNet is used to change the network settings for my malware lab

# Check if root
if [ "$USERNAME" != "root" ]; then
    echo "Must be run as root"
    exit
fi

# Check option and run, or print help
if [ "$1" = "default" ]; then
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables-restore < /etc/iptables/ipforward
elif [ "$1" = "polar" ]; then
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables-restore < /etc/iptables/polar
    cd PolarProxy
    ./PolarProxy -v -p 10443,80,443 -x /usr/local/share/polarproxy.cer --certhttp 10080 -w polarproxy.pcap
    cd ..
    iptables-restore < /etc/iptables/default
elif [ "$1" = "inetsim" ]; then
    echo 0 > /proc/sys/net/ipv4/ip_forward
    iptables-restore < /etc/iptables/empty
    inetsim
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables-restore < /etc/iptables/default
elif [ "$1" = "clear" ]; then
    echo 0 > /proc/sys/net/ipv4/ip_forward
    iptables-restore < /etc/iptables/empty
    exit
else
    echo "LabNet"    
    echo "Sets networking options for malware lab"    
    echo "Usage: labnet.sh [command]"
    echo
    echo "Commands:"
    echo "default - Reverts to forwarded internet access"
    echo "polar - Starts Polar Proxy session (internet with SSL/TLS capture)"     
    echo "inetsim - Starts InetSim (no internet access)"
    echo "clear - Clears all iptable rules and disables ip forwarding"
    echo
    echo "Use Ctrl-C to end Polar Proxy or InetSim. The default internet access will be restored."    
    echo "Polar Proxy pcaps are saved in ~/PolarProxy/polarproxy.pcap"
    echo "InetSim logs are saved in /var/log/inetsim/report"
    exit
fi
