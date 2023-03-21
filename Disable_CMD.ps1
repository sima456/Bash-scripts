# Disable Command Prompt through Registry
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\System" -Name "DisableCMD" -Value 1

# Prompt for password when user wants to use Command Prompt
$validPassword = "YourPasswordHere"

do {
    $password = Read-Host "Enter the password to use Command Prompt" -AsSecureString
    $passwordText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
} until ($passwordText -eq $validPassword)

# Enable Command Prompt through Registry
Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\System" -Name "DisableCMD"
