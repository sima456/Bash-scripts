#! /bin/bash

DATE=$(date +%F)

echo Enter system name
read $SYSTEM

echo Creating environment
mkdir ${SYSTEM}_Scan_${DATE}

# update apt
sudo apt-get update && apt-get dist-upgrade

if pip3 -V
then
    # upgrade pip
    pip3 install --upgrade pip
    
    # update all outdated pip files
    pip3 list -o | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip3 install -U

    echo "[+] pip and outdated libraries updated"
else echo "[-] pip not found."
fi;


if python -V | python3 -V
    then echo "[+] Python available"
    else echo "[-] Python not available.  You will have to install if needed"
fi;

mkdir Results; cd Results

# create directories
mkdir Reconnaissance; cd Reconnaissance; mkdir Nmap
cd ../
mkdir Scanning; cd Scanning; mkdir Nessus
cd ../


echo Environment setup complete:

# display tree
tree
