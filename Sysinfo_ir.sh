#!/bin/bash

echo "Which command would you like to run?"
select cmd in "date" "uptime" "uname" "vmstat" "netstat" "last" "who" "w" "ifconfig"; do
    case $cmd in
        "date")
            echo "Running 'date'"
            date --help
            date
            ;;
        "uptime")
            echo "Running 'uptime'"
            uptime --help
            uptime
            ;;
        "uname")
            echo "Running 'uname'"
            uname --help
            uname -a
            ;;
        "vmstat")
            echo "Running 'vmstat'"
            vmstat --help
            vmstat -s
            ;;
        "netstat")
            echo "Running 'netstat'"
            netstat --help
            netstat -a
            ;;
        "last")
            echo "Running 'last'"
            last --help
            last
            ;;
        "who")
            echo "Running 'who'"
            who --help
            who
            ;;
        "w")
            echo "Running 'w'"
            w --help
            w
            ;;
        "ifconfig")
            echo "Running 'ifconfig'"
            ifconfig --help
            ifconfig
            ;;
        *)
            echo "Invalid selection."
            ;;
    esac
    break
done
