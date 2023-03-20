#!/bin/bash

# Prompt user for flag type
read -p "Enter flag type (URG/ACK/PSH/RST/SYN/FIN): " flag

# Validate flag input
case $flag in
    URG|ACK|PSH|RST|SYN|FIN)
        # Prompt user for pcap file, if specified
        if [ -n "$1" ]; then
            tcpdump "tcp[13] & ${flag}!=0" -r "$1"
        else
            tcpdump "tcp[13] & ${flag}!=0"
        fi
        ;;
    *)
        echo "Invalid flag type. Please enter one of the following: URG, ACK, PSH, RST, SYN, FIN"
        ;;
esac
