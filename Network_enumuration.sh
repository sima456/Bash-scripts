#!/bin/bash
# network services script
# network_enum.sh <company name> <address x.x>

# this requires propecia.c: https://packetstormsecurity.com/files/14232/propecia.c.html

Make the directories
mkdir -p ~/$1/internal/scan/services/
mkdir -p ~/$1/internal/scan/nmap/hosts/



######################
# Find Windows Hosts #
######################
echo "Scanning for windows hosts."
WIN_SMB_COUNTER=0
         while [  $WIN_SMB_COUNTER -lt 254 ]; do
             propecia $2.$WIN_SMB_COUNTER 445 >> ~/$1/internal/scan/services/windows_SMB_hosts
             let WIN_SMB_COUNTER++
         done
echo "Done scanning for windows smb hosts. RDP is next."

######################
# Find Windows RDP Hosts #
######################
echo "Scanning for windows hosts."
WIN_RDP_COUNTER=0
         while [  $WIN_COUNTER -lt 254 ]; do
             propecia $2.$WIN_RDP_COUNTER 3389 >> ~/$1/internal/scan/services/windows_RDP_hosts
             let WIN_RDP_COUNTER++
         done
echo "Done scanning for windows RDP hosts. FTP is next."

##################
# Find FTP Hosts #
##################
FTP_COUNTER=0
         while [  $FTP_COUNTER -lt 254 ]; do
             propecia $2.$FTP_COUNTER 21 >> ~/$1/internal/scan/services/ftp_hosts
             let FTP_COUNTER++ 
         done
echo "Done scanning for FTP hosts. SunRPC is next."


#####################
# Find SunRPC Hosts #
#####################
SRPC_COUNTER=0
         while [  $SRPC_COUNTER -lt 254 ]; do
             propecia $2.$SRPC_COUNTER 111 >> ~/$1/internal/scan/services/sunrpc_hosts
             let SRPC_COUNTER++
         done

echo "Done scanning for SunRPC hosts. Telnet is next."


#####################
# Find Telnet Hosts #
#####################
TEL_COUNTER=0
         while [  $TEL_COUNTER -lt 254 ]; do
             propecia $2.$TEL_COUNTER 23 >> ~/$1/internal/scan/services/telnet_hosts
             let TEL_COUNTER++
         done
echo "Done scanning for Telnet hosts. Databases are next."


##################
# Find Databases #
##################
MSSQL_COUNTER=0
         while [  $MSSQL_COUNTER -lt 254 ]; do
             propecia $2.$MSSQL_COUNTER 1433 >> ~/$1/internal/scan/services/mssql_hosts
             let MSSQL_COUNTER++
         done

ORA_COUNTER=0
         while [  $ORA_COUNTER -lt 254 ]; do
             propecia $2.$ORA_COUNTER 1521 >> ~/$1/internal/scan/services/oracle_hosts
             let ORA_COUNTER+
         done


MY_COUNTER=0
         while [  $MY_COUNTER -lt 254 ]; do
             propecia $2.$MY_COUNTER 3306 >> ~/$1/internal/scan/services/mysql_hosts
             let MY_COUNTER++
         done
echo "Done scanning for Databases. Scanning for Web Servers Next"

################
# Find HTTP 80 #
################
HTTP_80_COUNTER=0
	while [ $HTTP_80_COUNTER -lt 254 ]; do
		propecia $2.$HTTP_80_COUNTER 80 >> ~/$1/internal/scan/services/http_80_hosts
		let HTTP_80_COUNTER++
	done
##################
# Find HTTP 8080 #
##################
HTTP_8080_COUNTER=0
	while [ $HTTP_8080_COUNTER -lt 254 ]; do
		propecia $2.$HTTP_8080_COUNTER 80 >> ~/$1/internal/scan/services/http_8080_hosts
		let HTTP_8080_COUNTER++
	done
#################
# Find HTTP 443 #
#################
HTTP_443_COUNTER=0
	while [ $HTTP_443_COUNTER -lt 254 ]; do
		propecia $2.$HTTP_443_COUNTER 80 >> ~/$1/internal/scan/services/http_443_hosts
		let HTTP_443_COUNTER++
	done
##################
# Find HTTP 8443 #
##################
HTTP_8443_COUNTER=0
	while [ $HTTP_8443_COUNTER -lt 254 ]; do
		propecia $2.$HTTP_8443_COUNTER 80 >> ~/$1/internal/scan/services/http_8443_hosts
		let HTTP_8443_COUNTER++
	done

######################
# Merge nmap targets #
######################
cat ~/$1/internal/scan/services/windows_hosts ~/$1/internal/scan/services/ftp_hosts ~/$1/internal/scan/services/sunrpc_hosts ~/$1/internal/scan/services/windows_RDP_hosts \
~/$1/internal/scan/services/mssql_hosts ~/$1/internal/scan/services/oracle_hosts ~/$1/internal/scan/services/mysql_hosts \
~/$1/internal/scan/services/http_80_hosts ~/$1/internal/scan/services/http_8080_hosts ~/$1/internal/scan/services/http_443_hosts ~/$1/internal/scan/services/http_8443_hosts >> ~/$1/internal/scan/nmap/nmap_targets_dup

############################
# Deduplicate nmap targets #
############################
sort ~/$1/internal/scan/nmap_targets/nmap_targets_dup | uniq > ~/$1/internal/scan/nmap/nmap_targets_deduplicated


###############################
# Ok, let's do the NMAP files #
###############################

for x in `cat ~/$1/internal/scan/nmap_targets/nmap_targets_deduplicated` ; do nmap -sV -O $x > ~/$1/internal/scan/nmap/hosts/$x ; done
echo "Done with Windows."
echo " "
echo " "
echo "Done, now check your results."
