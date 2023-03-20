#!/bin/bash

echo "Which command would you like to run?"
select cmd in "date" "uptime" "uname" "vmstat" "netstat" "last" "who" "w" "ifconfig"; do
    case $cmd in
        "date")
            echo "Running 'date'"
            date
            ;;
        "uptime")
            echo "Running 'uptime'"
            uptime
            ;;
        "uname")
            echo "Running 'uname'"
            uname
            ;;
        "vmstat")
            echo "Running 'vmstat'"
            vmstat -s
            ;;
        "netstat")
            echo "Running 'netstat'"
            netstat -a
            ;;
        "last")
            echo "Running 'last'"
            last
            ;;
        "who")
            echo "Running 'who'"
            who
            ;;
        "w")
            echo "Running 'w'"
            w
            ;;
        "ifconfig")
            echo "Running 'ifconfig'"
            ifconfig
            ;;
        *)
            echo "Invalid selection."
            ;;
    esac
    break
done
