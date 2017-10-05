#!/bin/bash

# Reference:
# https://doc.pfsense.org/index.php/Remote_Config_Backup

# Cleanup
function cleanup {
  rm $( echo ${target_firewall} | sed 's/\./_/g' ).pem
  rm cookies.txt
  rm csrf.txt
  rm csrf2.txt
}

# If arguments aren't passed, get them from the user
if [[ ! -z "$1" ]]; then
  target_firewall=$1
else
  echo "INPUT: Enter the target firewalls IP or FQDN name:"
  read target_firewall
fi

if [[ ! -z "$2" ]]; then
  user=$2
else
  echo "INPUT: Enter your username:"
  read -s user
fi

if [[ ! -z "$3" ]]; then
  password=$3
else
  echo "INPUT: Enter your password:"
  read -s password
fi

# Get the login form and save the appropriate cookie and token
echo "INFO: Getting login form"

wget -qO- --keep-session-cookies --save-cookies cookies.txt --no-check-certificate https://${target_firewall}/diag_backup.php | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' > csrf.txt

# Submit the login using the provided credentials and the token we saved previously
echo "INFO: Submitting login form"

wget -qO- --keep-session-cookies --load-cookies cookies.txt --save-cookies cookies.txt --no-check-certificate --post-data "login=Login&usernamefld=${user}&passwordfld=${password}&__csrf_magic=$(cat csrf.txt)" https://${target_firewall}/diag_backup.php  | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' > csrf2.txt

# Submit the download form to get the backup, optionally we can get RRD information by removing the portion that sets the donotbackuprrd to yes
echo "INFO: Downloading backup"

wget --keep-session-cookies --load-cookies cookies.txt --no-check-certificate --post-data "download=download&donotbackuprrd=yes&__csrf_magic=$(head -n 1 csrf2.txt)" https://${target_firewall}/diag_backup.php -O config-router-`date +%Y%m%d%H%M%S`.xml

cleanup
