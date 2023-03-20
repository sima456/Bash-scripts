Write-Host "Welcome to the interactive system information script!"
Write-Host ""

# Display menu and prompt user for selection
$cmd = Read-Host -Prompt @"
Please select a command to run:
1) echo %date% %time%
2) ipconfig /all
3) net user
4) net localgroup
5) net share
6) wevtutil qe Application
7) wevtutil qe Security
8) wevtutil qe System
9) tasklist
"@

# Run selected command
switch ($cmd) {
    "1") { # echo %date% %time% command
        Write-Host "Running 'echo %date% %time%' command:"
        echo "$(Get-Date) $(Get-Time)"
        break
    }
    "2") { # ipconfig /all command
        Write-Host "Running 'ipconfig /all' command:"
        ipconfig /all
        break
    }
    "3") { # net user command
        Write-Host "Running 'net user' command:"
        net user
        break
    }
    "4") { # net localgroup command
        Write-Host "Running 'net localgroup' command:"
        net localgroup
        break
    }
    "5") { # net share command
        Write-Host "Running 'net share' command:"
        net share
        break
    }
    "6") { # wevtutil qe Application command
        Write-Host "Running 'wevtutil qe Application' command:"
        wevtutil qe Application
        break
    }
    "7") { # wevtutil qe Security command
        Write-Host "Running 'wevtutil qe Security' command:"
        wevtutil qe Security
        break
    }
    "8") { # wevtutil qe System command
        Write-Host "Running 'wevtutil qe System' command:"
        wevtutil qe System
        break
    }
    "9") { # tasklist command
        Write-Host "Running 'tasklist' command:"
        tasklist
        break
    }
    Default {
        Write-Host "Invalid selection. Please enter a number between 1 and 9."
        break
    }
}
