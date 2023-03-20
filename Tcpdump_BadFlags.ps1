# Prompt user for flag type or Xmas scan
$flag = Read-Host "Enter flag type (URG/ACK/PSH/RST/SYN/FIN) or Xmas"

# Validate flag input
switch ($flag) {
    "URG", "ACK", "PSH", "RST", "SYN", "FIN" {
        # Prompt user for pcap file, if specified
        if ($args.Count -gt 0) {
            & tcpdump.exe "tcp[13] & $($_.ToUpper())!=0" -r $args[0]
        } else {
            & tcpdump.exe "tcp[13] & $($_.ToUpper())!=0"
        }
    }
    "Xmas" {
        # Prompt user for pcap file, if specified
        if ($args.Count -gt 0) {
            & tcpdump.exe "tcp[13] & 1!=0 and tcp[13] & 2!=0 and tcp[13] & 4!=0" -r $args[0]
        } else {
            & tcpdump.exe "tcp[13] & 1!=0 and tcp[13] & 2!=0 and tcp[13] & 4!=0"
        }
    }
    default {
        Write-Host "Invalid flag type. Please enter one of the following: URG, ACK, PSH, RST, SYN, FIN, or Xmas"
    }
}
