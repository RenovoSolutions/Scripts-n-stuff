1) Copy dyndns.bash and update_record.json to the root user's home directory (/root)  
2) chmod 755 both the files  
3) chown root:root both the files  
4) Copy dyndns_route53.service to /usr/lib/systemd/system/  
5) chmod 644 /usr/lib/systemd/system/dyndns_route53.service  
6) vi /root/dyndns_route53.service  
7) Update the variables inside the script and save  
8) systemctl enable dyndns_route53  
9) Server should now update its A record every time it boots  