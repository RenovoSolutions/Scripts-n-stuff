#!/bin/bash

#1) run_once function
#Checks complete share tree for crypt.txt trip files.
#Creates them if they don't exist.
#Checks the hash on all existing files.

#2) log_wait function
#Requires full_audit to be configured to watch for successful pwrite or chmod in smb.conf
#Requires that full_audit logs to /var/log/samba/audit.log
#Watches logs for writes to crypt.txt
#If it detects a write it performs a hash comparison
#Restarts samba in the event of a changed crypt.txt file
#Logs failed hash location
#Blacklists the infected user in smb.conf
#Finds files even if text has been appended to the end of the file.
#       Could not find any confirmation that file names are changed, or text is appended to the front
#       Maintainer should regularly maintain good information on crypto-variants and how they modify files

#Share location
sharel="/share/renovo/files"

#Master hash
master_md5=$( md5sum "/root/crypt.txt" )
#Hash compare function
function hash_compare {
 #Hash script compares the master to
 filen=$( ls "${d}"/crypt.txt* | head -1 )
 compare_md5=$( md5sum "${filen}" )
  #Check if they do NOT match
  if [[ "${master_md5:0:32}" != "${compare_md5:0:32}" ]]; then
   echo "Hash failed for ${filen}"
   echo "$( TZ=AMerica/New_York date +%Y%m%d_%H%M%S ): FAILED COMPARE: ${master_md5} ${compare_md5}" >> crypttrip.log
   #Replace the file
   rm -rf "${filen}"
   cp "/root/crypt.txt" "${d}/crypt.txt"
   chmod 0771 "${d}/crypt.txt"
   chown root:samba "${d}/crypt.txt"
   #Quarantine the user
   quarantine
   #Restart samba server
   systemctl restart smb
   systemctl restart nmb
  fi
}
#Quarantine function
function quarantine {
 #Gets the specific user who wrote new data to the file
 #This is the last write to crypt.txt in samba audit log file
 iuser=$( sed '1!G;h;$!d' /var/log/samba/audit.log | grep "pwrite.*crypt.txt.*" | head -1 | awk ' { print $6 } ' | awk 'BEGIN { FS = "|" } ; { print $1 } ' )
 #Gets global invalid users line from config
 qcurrent=$( cat /etc/samba/smb.conf | grep "invalid users =" )
 #Appends infected user to the line
 qnew=$( echo "${qcurrent} ${iuser}" )
 #Replaces the line in the configuration
 sed -i "s/${qcurrent}/${qnew}/g" /etc/samba/smb.conf
 echo "$( TZ=AMerica/New_York date +%Y%m%d_%H%M%S ): FAILED COMPARE: BLACKLISTED ${iuser}" >> crypttrip.log
}

function run_once {
 #Find all directories in corp share
 find ${sharel} -type d -exec echo {} \; | while read d; do
  #Check if any matching files exist
  oldIFS=${IFS}
  if ls "${d}"/crypt.txt*; then
    :
    hash_compare
   else
   #Create the file if it doesn't exist
    cp "/root/crypt.txt" "${d}/crypt.txt"
   #Apply permissions and flag for hidden
    chmod 0771 "${d}/crypt.txt"
    chown root:samba "${d}/crypt.txt"
  fi
 done
}
#Watches logs for writes to crypt files, if detected, runs a hash compare
function log_wait {
 tail -f /var/log/samba/audit.log | while read line; do
  echo ${line}
  filen=$( echo ${line} | awk 'BEGIN { FS = "|" } ; { print $NF }' | awk 'BEGIN { FS = "/" } ; { print $NF }' )
  filed=$( echo ${line} | awk 'BEGIN { FS = "|" } ; { print $NF }' | sed "s/${filen}//g" )
  d=$( echo ${sharel}/${filed} )
  [[ "${line}" == *pwrite*crypt.txt* || "${line}" == *chmod*crypt.txt* ]] && hash_compare
 done
}
if [[ $# -eq 0 ]]; then
 echo "To make sure all directories have a crypt file run:"
 echo "     cryptotrip.bash run_once
"
 echo "Recommend adding cronjob as follows (adjust time depending on size of directory tree):"
 echo "     */5 * * * * /root/cryptotrip.bash run_once &>/dev/null"
 echo "
To watch log for writes to crypt.txt run as follows:"
 echo "     cryptotrip.bash log_wait &
"
 echo "Recommend running at start up or creating a service to run."
else
 $1
fi

