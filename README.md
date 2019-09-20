# LabNet

LabNet is a collection of scripts and configurations I use to switch networking options in my malware lab. Please see my post on https://netsecninja.github.io/malware-lab for a step-by-step build out of my lab. Follow these installation steps below once you have your Linux gateway VM set up.

1. Copy all files to your lab gateway VM by downloading the zip from github or git command line
2. Open terminal and navigate to folder with unzipped files
3. Run ```chmod +x labnetinstall.sh``` as normal user
4. ```cd ~``` and run the labnet script without parameters to see how to use it: ```sudo ./labnet.sh```

* Note: If you didn't follow my lab setup steps exactly, you may need to go through all the files to look for applicable changes in network interface names or IP addresses before you run the install script.

