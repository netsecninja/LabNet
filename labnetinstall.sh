#!/bin/bash
# LabNet installer

# Make script executable
chmod +x iptables
chmod +x labnet.sh

# Move labnet to user home
mv labnet.sh ~

# Create Polarproxy pcap link
ln -s ~/PolarProxy/polarproxy.pcap ~/polarproxy.pcap

# Create Inetsim report link
ln -s /var/log/inetsim/report ~/inetsim

# Move iptable profiles
sudo mkdir /etc/iptables
sudo mv ipforward /etc/iptables
sudo mv polar /etc/iptables
sudo mv empty /etc/iptables

# Move inetsim config
sudo mv inetsim.conf /etc/inetsim/

# Set default ipforward profile on startup
sudo mv iptables /etc/network/if-pre-up.d/
