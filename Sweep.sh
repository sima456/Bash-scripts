#! /bin/bash

# printf "Available hosts\n\n" >> scan_results.txt

for i in {1..254}
do 
    echo "Scanning: 192.168.1.${i}"
    ping -c 1 192.168.1.${i} | grep "bytes from"  | cut -d " " -f 4 | sed 's/.$//' >> scan_results.txt
done

echo "Scan complete, check 'scan_results.txt' for live hosts."
echo "Use command 'namp -iL scan_results.txt' to scan live hosts."

# uses nmap to generate a list of live hosts
# nmap 192.168.1.1/24 -T4 -n -oX out.xml | grep "Nmap" | cut -d " " -f5 >> live-hosts.txt
