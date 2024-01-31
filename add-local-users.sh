#!/bin/bash

# This is a shell script to create Linux users using the provided username, name, and password
# The script also forces the user to update password after first login

# Check if the script is being executed with root previliges

if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run with sudo or as root'
  exit 1 
fi

# Check if there is atleast one argument provided in the input. If not, tell user about usage
if [[ "${#}" -eq 0 ]]
then
  echo "Usage: #{0} USERNAME [USERNAME]..."
  echo "Create an account on the local system with the name of USER_NAME and NAME field for COMMENT"
  exit 1
fi
# Extract the username and name
USERNAME=${1}
NAME=${2}

# Add the user of specified name and username
useradd -c "${NAME}" -m ${USERNAME}

# Check if the user was created successfully
if [[ "${?}" -eq 0 ]]
then
 echo 'User account creation successful!'
else
 echo 'Account couldnt be created'
 exit 1
fi

# Generate the special character to be attached to the generated number
ALPHANUMERIC='~!@#$%^&*()_+-=`'
SPECIAL_CHAR=$(echo ${ALPHANUMERIC} | fold -w1 | shuf)

# Generate the password
PASSWORD=$(date +%s%N | sha256sum | head -c27 )${RANDOM}${SPECIAL_CHAR}

# Assign the generated password
echo ${PASSWORD} | passwd --stdin ${USERNAME}

if [[ "${?}" -eq 0 ]]
then 
 echo 'Password assigned successfully'
else
 echo 'Password creation unsuccessful'
 exit 1
fi

# Force the user to change the password after first login
passwd -e ${USERNAME}

echo
echo "Username: ${USERNAME}"
echo
echo "Password: ${PASSWORD}"
echo
echo ${HOSTNAME}
exit 0
