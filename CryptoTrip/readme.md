Setup:  
*Requires that samba is running with full_audit configured to log to /var/log/samba/audit.log  
*Full audit must be logging pwrite (for writes) and chmod (when files are created, in case the file is encrypted then replaced)
*You don't need any other success options for full_audit in order for this to work  
*Modify cryptotrip.bash and make sure the file share location is correct  
*Run cryptotrip_setup.bash to setup cron jobs and cryptotrip service  
  
Notes:  
*Service will run at startup every time  
*Cron runs a job every minute to verify the trip service is running  
*CryptoTrip checks all share directories every 5 minutes for existing crypt.txt files  
*crypt.txt files are hidden from Windows users if hidden is mapped in the smb config  
*Creates them if they do not exist  
*Service watches full_audit log for pwrite or chmod  
*After detection; does a hash compare on the detected file and blacklists the user if it fails  
*User is blacklisted via the smb.conf, remove from invalid users and restart to un-blacklist  

Performance:  
*Currently not clear how much cpu usage the log_wait function will use if a large amount of traffic is writing to the audit log  
*I expect that anywhere from 1-5% total cpu usage for the whole instance will belong to cryptotrip  