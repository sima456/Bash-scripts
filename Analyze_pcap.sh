#!/bin/bash

# Define the command line arguments
while getopts ":f:" opt; do
  case $opt in
    f)
      pcap_file="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check if the pcap file exists
if [ ! -f "$pcap_file" ]; then
  echo "Error: File $pcap_file not found"
  exit 1
fi

# Extract the hostnames from the pcap file
hostnames=$(tshark -r "$pcap_file" -T fields -e http.host | sort | uniq)

# Set up VirusTotal API variables
API_KEY="YOUR_API_KEY"
API_URL="https://www.virustotal.com/api/v3/domains"

# Define function to check a single hostname with VirusTotal
function check_hostname() {
  local hostname=$1
  echo "Checking $hostname with VirusTotal..."
  response=$(curl --retry 5 --retry-delay 5 -s -H "x-apikey: $API_KEY" "$API_URL/$hostname")
  malicious=$(echo $response | jq -r '.data.attributes.last_analysis_stats.malicious')
  if [ $malicious -gt 0 ]; then
    echo "Warning: $hostname is associated with malicious activity"
  fi
}

# Define function to process hostnames in parallel
function process_hostnames() {
  local hostnames="$1"
  for hostname in $hostnames; do
    check_hostname $hostname &
  done
  wait
}

# Split the hostnames into chunks and process them in parallel
chunk_size=100
for i in $(seq 0 $chunk_size ${#hostnames}); do
  chunk=("${hostnames[@]:i:chunk_size}")
  process_hostnames "${chunk[@]}"
done
