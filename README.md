# LabNet

LabNet is a collection of scripts and configurations I use to switch networking options in my malware lab.
* Please see my post on https://netsecninja.github.io/malware-lab for a step-by-step build out of my lab.
* Follow these installation steps below once you have your Linux gateway VM set up.

1. Copy all files to your lab gateway VM by downloading the zip from github or using the git command line
2. Unzip the file
3. Open terminal and navigate to folder with unzipped files
4. Run ```chmod +x install.sh```
5. Run ```sudo ./install.sh``` and follow the prompts to install
6. When complete, navigate to the root of your normal user directory ```cd ~```
7. Run ```ln -s /opt/labnet``` to create a shortcut to the labnet folder

