#!/bin/bash

echo "[+] Bash script to pull useful artefacts from a linux machine"
echo "Enter the path of your working directory: "

read workDir

mkdir -p $workDir/UserArtefacts
echo "[+] Created directory UserArtefacts"

IFS=$'\n'
declare -a usernamesArray=( $(sudo cat /etc/passwd | cut -d':' -f1) )
touch extractedUsers.txt
for i in "${usernamesArray[@]}"
do
	#echo "$i"
	mkdir -p "$workDir"/UserArtefacts/"$i"
	lastLogin=$(lastlog -u "$i"| cut -d" " -f50-75)
	echo "Username:" "$i" "Last Login:" "$lastLogin" >> extractedUsers.txt  
done

echo "[+] Extracted users and last logins"

mkdir -p $workDir/ExtractedLogFiles

echo "[+] Created directory ExtractedLogFiles"

cp /var/log/auth.log* $workDir/ExtractedLogFiles
cp /var/log/syslog* $workDir/ExtractedLogFiles
cp /var/log/btmp* $workDir/ExtractedLogFiles
cp /var/log/wtmp* $workDir/ExtractedLogFiles
cp /var/log/messages* $workDir/ExtractedLogFiles
cp /var/log/lastlog* $workDir/ExtractedLogFiles
cp /var/log/kern.log* $workDir/ExtractedLogFiles

echo "[+] Extracted log files"

IFS=$'\n'
declare -a homeDirs=( $(find /home -maxdepth 1 -mindepth 1 -type d) )
for i in "${homeDirs[@]}"
do
	user=$(echo "$i" | cut -d"/" -f3)
	cp "$i"/.*_history "$workDir"/UserArtefacts/"$user"
	cp "$i"/.mozilla/firefox/*.default-esr/*.sqlite "$workDir"/UserArtefacts/"$user"
done

cp /root/.*_history $workDir/UserArtefacts/root
cp /root/.mozilla/firefox/*.default-esr/*.sqlite $workDir/UserArtefacts/root

echo "[+] Extracted user artefacts including bash history and browser artefacts"
echo "[=] Finished"
