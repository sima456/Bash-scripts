#!/bin/bash

# Define the usage message
function usage {
    echo "Usage: $0 [-d | -c] <output file>"
    echo "  -d  use dd"
    echo "  -c  use dc3dd"
}

# Parse the command-line arguments
while getopts "dc" opt; do
    case ${opt} in
        d )
            dd=true
            ;;
        c )
            dc3dd=true
            ;;
        * )
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))
output_file=$1

# Check that the user specified either dd or dc3dd
if [ ! $dd ] && [ ! $dc3dd ]; then
    usage
    exit 1
fi

# Check that the output file was specified
if [ -z "$output_file" ]; then
    usage
    exit 1
fi

# Take the system image using dd
if [ $dd ]; then
    sudo dd if=/dev/sda of="$output_file" bs=4M conv=sync,noerror status=progress
fi

# Take the system image using dc3dd
if [ $dc3dd ]; then
    sudo dc3dd if=/dev/sda of="$output_file" hash=md5 log="$output_file.log" conv=noerror,sync
fi
