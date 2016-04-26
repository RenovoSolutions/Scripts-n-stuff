### Creating a server bridge in pfSense

1. Log in to pfSense
2. Go to VPN > OpenVPN
3. Create a new server
..* **Server Mode:** Remote Access (SSL/TLS)
..* **Protocol:** UDP
..* **Deive Mode:** tap
..* **Interface:** WAN (or whatever your wan interface is called)
..* **Local port:** Your next available port after 1194
..* **Description:** Remote Server Bridge
..* Check the box for **Bridge DHCP**
..* Crytographic settings should be the same as any other OpenVPN server
..* **Bridge Interface:** LAN
..* Your server bridge DHCP start and end should be outside your regular scope. The server will be statically assigned within this.
..* In the advanced section add a line like client-config-dir /var/etc/openvpn/staticclients, you'll need to create this directory and it should contain a single file for each static calient
..* These static files should be named to match the pfSense user (for example if the user the server will use is named printserver then the file should be named printserver) and contain a line like ifconfig-push 10.190.1.234 255.255.255.0 with the ip you'd like to assign to your remote server.
4. Backup these static files as they may not persist.