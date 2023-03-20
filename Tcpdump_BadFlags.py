import subprocess
import sys

# Prompt user for flag type or Xmas scan
flag = input("Enter flag type (URG/ACK/PSH/RST/SYN/FIN) or Xmas: ")

# Validate flag input
if flag.upper() in ["URG", "ACK", "PSH", "RST", "SYN", "FIN"]:
    # Prompt user for pcap file, if specified
    if len(sys.argv) > 1:
        subprocess.run(["tcpdump", f"tcp[13] & {flag.upper()}!=0", "-r", sys.argv[1]])
    else:
        subprocess.run(["tcpdump", f"tcp[13] & {flag.upper()}!=0"])
elif flag.upper() == "XMAS":
    # Prompt user for pcap file, if specified
    if len(sys.argv) > 1:
        subprocess.run(["tcpdump", "tcp[13] & 1!=0 and tcp[13] & 2!=0 and tcp[13] & 4!=0", "-r", sys.argv[1]])
    else:
        subprocess.run(["tcpdump", "tcp[13] & 1!=0 and tcp[13] & 2!=0 and tcp[13] & 4!=0"])
else:
    print("Invalid flag type. Please enter one of the following: URG, ACK, PSH, RST, SYN, FIN, or Xmas")
