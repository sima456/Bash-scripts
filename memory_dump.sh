#!/bin/bash

# Define default values for command line options
output_file="memory_dump.img"
block_size="512"
num_blocks="100"

# Parse command line options
while getopts ":o:b:n:h" option; do
  case "${option}" in
    o) output_file=${OPTARG} ;;
    b) block_size=${OPTARG} ;;
    n) num_blocks=${OPTARG} ;;
    h) 
      echo "Usage: memory_dump.sh [-o output_file] [-b block_size] [-n num_blocks] [-h]"
      echo "Options:"
      echo "  -o output_file: Specify the name of the output file (default: memory_dump.img)"
      echo "  -b block_size: Specify the block size in bytes (default: 512)"
      echo "  -n num_blocks: Specify the number of blocks to read (default: 100)"
      echo "  -h: Display this help message"
      exit 0
      ;;
    :) echo "Error: Option -${OPTARG} requires an argument." >&2; exit 1 ;;
    \?) echo "Error: Invalid option -${OPTARG}" >&2; exit 1 ;;
  esac
done

# Shift command line arguments to skip over options
shift $((OPTIND-1))

# Check that the dc3dd tool is installed
if ! command -v dc3dd &> /dev/null; then
  echo "Error: dc3dd tool is not installed." >&2
  exit 1
fi

# Check that the output file does not already exist
if [[ -f $output_file ]]; then
  echo "Error: Output file $output_file already exists." >&2
  exit 1
fi

# Run the dc3dd tool to create the memory dump
dc3dd if=/dev/mem of="$output_file" bs="$block_size" count="$num_blocks"

echo "Memory dump saved to $output_file."
