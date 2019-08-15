# LabNet

LabNet is a collection of scripts and configurations I use to switch networking options in my malware lab. Please see my post on https://netsecninja.github.io/malware-lab for a step-by-step build out of my lab. Follow these installation steps below once you have your Linux gateway VM set up.

1. Copy all files to your lab gateway VM
2. Edit the "ipforward" file as follows:
    1. Replace all occurances of "enp0s3" with the internet-facing interface name
    2. Replace all occurances of "enp0s8" with the host-only NIC name
    3. Replace "192.168.56.0/24" with whatever subnet is set in Virtualbox Host Network Manager
3. Edit the "polar" file as follows:
    1. Replace all occurances of "enp0s3" with the internet-facing interface name
    2. Replace all occurances of "enp0s8" with the host-only NIC name
4. Make an /etc/iptables folder: ```sudo mkdir /etc/iptables```
5. Move the "ipforward", "polar", and "empty" files to /etc/iptables
6. Move the "inetsim.conf" to /etc/inetconf: ```sudo mv inetsim.conf /etc/inetsim/```
7. Make "iptables" file executable: ```chmod +x iptables```
8. Move "iptables" to /etc/network/if-pre-up.d: ```sudo mv iptables /etc/network/if-pre-up.d/```
9. Make "labnet.sh" file executable: ```chmod +x labnet.sh```

Run the labnet script to see help on how to use it: ```sudo ./labnet.sh```
