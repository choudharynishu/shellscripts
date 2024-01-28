#!/bin/bash

# This is a shell script to create Linux users using the provided username, name, and password
# The script also forces the user to update password after first login

# Check if the script is being executed with root previliges

if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run with sudo or as root'
  exit 1 
fi

# Prompt the user to provide a username
read -p "Enter the username to create: " USERNAME

# Prompt the user to enter the name of the user or the application who will be using this account
read -p "Enter the name of the person or the application using this account: " NAME

# Prompt the user to enter a Password
read -p "Enter the password to use for the account: " PASSWORD

useradd -c "${NAME}" -m ${USERNAME}

if [[ "${?}" -eq 0 ]]
then
 echo 'User account creation successful!'
else
 echo 'Account couldnt be created'
 exit 1
fi

echo ${PASSWORD} | passwd --stdin ${USERNAME}

if [[ "${?}" -eq 0 ]]
then 
 echo 'Password assigned successfully'
else
 echo 'Password creation unsuccessful'
 exit 1
fi

passwd -e ${USERNAME}
echo
echo "Username: ${USERNAME}"
echo
echo "Password: ${PASSWORD}"
echo
echo ${HOSTNAME}
exit 0
