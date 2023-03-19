#!/bin/bash

# Prompt for input and output file names
echo -n "What is the name of your PCAP input file? "
read in_pcap
echo -n "What is the name of your CSV output file? "
read out_csv

# Extract hostnames for HTTP, HTTPS, and DNS traffic
tshark -r "$in_pcap" \
  -T fields -e ip.src -e ip.dst \
  -Y "http or https or dns" \
  -e http.host -e ssl.handshake.extensions_server_name -e dns.qry.name -e dns.resp.name \
  -E separator=, -E quote=d \
  > "$out_csv"

echo "Done!"
