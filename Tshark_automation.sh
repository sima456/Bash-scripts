#!/bin/bash

# Prompt the user for input and output filenames
echo -n "Enter the name of the input PCAP file: "
read pcap_filename

echo -n "Enter the name of the output CSV file: "
read csv_filename

# Validate the input and output filenames
if [ ! -f "$pcap_filename" ]; then
    echo "Error: PCAP file $pcap_filename not found"
    exit 1
fi

if [ -f "$csv_filename" ]; then
    echo "Warning: CSV file $csv_filename already exists and will be overwritten"
fi

if [ ! -w "$csv_filename" ]; then
    echo "Error: you do not have write permission for the file $csv_filename"
    exit 1
fi

# Run tshark to extract network traffic information
tshark -r "$pcap_filename" \
    -T fields \
    -e frame.number -e frame.time_epoch \
    -e eth.src -e eth.dst \
    -e ip.src -e ip.dst -e ip.proto \
    -e vlan.id -e vlan.priority \
    -e dns.qry.name -e dns.qry.type \
    -e dns.resp.name -e dns.resp.type \
    -e tcp.srcport -e tcp.dstport -e tcp.seq -e tcp.ack -e tcp.flags \
    -e udp.srcport -e udp.dstport -e udp.length \
    -e icmp.type -e icmp.code \
    -E separator=, -E quote=d -E occurrence=f \
    > "$csv_filename"

# Print the number of packets to the console
num_packets=$(wc -l < "$csv_filename")
echo "Number of packets: $num_packets"
