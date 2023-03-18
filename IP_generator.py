#! /usr/bin/python
"""This script is used to generate random IP addresses to be used as decoy IPs for nmap scans."""

from random import randrange
import argparse
import ipaddr


def get_arguments():
    """Get user supplied arguments from terminal."""
    parser = argparse.ArgumentParser()
    # arguments
    parser.add_argument('-n', '--network', dest='network', help='Enter network using CIDR notation.  (e.g. 192.168.1.1/24)')
    parser.add_argument('-c', '--count', dest='count', help='Enter the number of IP addresses to generate')
    # parser.add_argument('-h', '--help', dest='help', help='Specify new MAC address. Type "random" for random MAC.')

    (options) = parser.parse_args()
    return options


def generate_random_ip(network, ip_count = 1):
    """Generates the specified number of IPs in the supplied network block."""
    ip_list = []
    network = ipaddr.IPv4Network(network)

    for i in range(ip_count):
        network = ipaddr.IPv4Network(network)
        randmon_ip = ipaddr.IPv4Address(random.randrange(int(network.network) + 1, int(network.broadcast) - 1))

        ip_list.append(random_ip)

    return ip_list


options = get_arguments()
network = options.network
count = options.count

generate_random_ip(network, count)
