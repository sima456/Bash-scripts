#!/bin/bash

# check if argument is provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <CIDR>"
    exit 1
fi

cidr=$1

# check if argument is a valid CIDR
if ! [[ $cidr =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$ ]]; then
    echo "Invalid CIDR argument."
    exit 1
fi

# console colors
rd=$(tput setaf 1)
gr=$(tput setaf 2)
bld=$(tput bold)
rst=$(tput sgr0)
ar="$bld→$rst"
ndr=$(tput smul)

# function to get gateway
gateway() {
    if [[ $(uname) == "Darwin" ]]; then
        route -n get default | awk '/gateway:/ { print $2 }'
    elif [[ $(uname) == "Linux" ]]; then
        ip route | awk '/default/ { print $3 }'
    elif [[ $(uname) == "MINGW"* ]]; then
        ipconfig | awk '/Gateway/ { gsub("\r",""); print $NF }'
    fi
}

# function to get MAC vendor
macvendor() {
    vendor=$(curl -s "https://api.macvendors.com/$1")
    if [[ -n $vendor ]]; then
        echo "$vendor"
    else
        echo "${rd}Unknown${rst}"
    fi
}

# scan network with nmap
ips=()
mapfile -t ips < <(nmap -sn "$cidr" | awk '/is up/ { print $2 }')

# get the gateway
gateway=$(gateway)

# dump ARP cache and get MAC vendors
while read -r line; do
    if [[ $line =~ ^($ip_regex).*$($mac_regex).*$ ]]; then
        ip=${BASH_REMATCH[1]}
        mac=${BASH_REMATCH[2]}
        if [[ $mac != "ff:ff:ff:ff:ff:ff" && "${ips[@]}" =~ $ip ]]; then
            if [[ $ip == $gateway ]]; then
                echo -e "${ndr}${ip}${rst} ${ar} ${mac} ${ar} $(macvendor "$mac") ${ar} ${gr}active${rst} (${rd}gateway${rst})"
            else
                echo -e "${ndr}${ip}${rst} ${ar} ${mac} ${ar} $(macvendor "$mac") ${ar} ${gr}active${rst}"
            fi
        else
            echo -e "${ndr}${ip}${rst} ${ar} ${mac} ${ar} $(macvendor "$mac")"
        fi
    fi
done < <(arp -a)
