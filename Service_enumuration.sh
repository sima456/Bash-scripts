#!/bin/bash

# This script discovers hosts running specific servers and outputs a host list to a file for each service
# This all relies on standard nmap discovery

# free for use and modificatiion

bashversion=$(printf "$BASH_VERSION" | cut -d "." -f1)

# check that we are running in bash 4 so that associative arrays work
if (($bashversion != "4")); then
	printf "Must be running BASH >= 4.0"
	exit
fi

#Check arguments
if (($# != 1)); then
	printf "Usage: %s 10.1.1.0/24" "$0"
	exit
fi

# Check Privs
if (($EUID != 0)); then
	printf "Run me as Root"
	exit
fi

# declare an associative array
declare -A servicesTCP
declare -A servicesUDP

# declare services in the arrays
###
# DECLARE TCP services
###
# scan for http port 80
servicesTCP[http80]=80
# scan for http port 8080
servicesTCP[http8080]=8080
# scan for https port 443
servicesTCP[https443]=443
# scan for https port 8443
servicesTCP[http8443]=8443
# scan for ftp
servicesTCP[ftp]=21
# scan for ssh
servicesTCP[ssh]=22
# scan for telnet
servicesTCP[telnet]=23
# scan for smtp
servicesTCP[smtp]=25
# scan for smtp using ssl
servicesTCP[smtpssl]=465
# scan for POP
servicesTCP[pop3]=110
# scan for SMB
servicesTCP[smb]=445

###
# DECLARE UDP services
###
# scan for snmp
servicesUDP[snmp]=161

# make the test directory in whatever folder you are in
# eventually i want to make this more elegant but for now it works.
mkdir -p ./HostServices/
workingpath="./HostServices/"

#Text Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
END='\033[0;0m'
BOLD='\033[0;1m'
ENDBOLD='\033[21m'

for service in "${!servicesTCP[@]}"; do
	printf $YELLOW"Testing the %s TCP service\n"$END "$service" 
	filetemp=$workingpath$service"_hosts.gnmap"
	filehosts=$workingpath$service"_hosts.txt"
	nmap -p ${servicesTCP[$service]} $1 --open -oG $filetemp
	cat $filehosts | cut -d " " -f2 | sort -u | grep -v "Nmap" >$filehosts
	printf $GREEN"Testing of the %s TCP service is Complete\n" "$service"
	printf "Check the file:"$BOLD" %s"$ENDBOLD$GREEN" for a list of hosts with the service active\n\n"$END "$filehosts"

done

for service in "${!servicesUDP[@]}"; do
	printf $YELLOW "Testing the %s UDP service\n"$END "$service"
	filetemp=$workingpath$service"_hosts.gnmap"
	filehosts=$workingpath$service"_hosts.txt"
	nmap -sU -p ${servicesUDP[$service]} $1 --open -oG $filetemp
	cat $filehosts | cut -d " " -f2 | sort -u | grep -v "Nmap" >$filehosts
	printf $GREEN"Testing of the %s UDP service is Complete\n" "$service"
	printf "Check the file: "$BOLD" %s"$ENDBOLD$GREEN" for a list of hosts with the service active\n\n"$END "$filehosts"
done
