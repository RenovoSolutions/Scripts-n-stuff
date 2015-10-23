Vault setup is pretty straight forward to start  

*Update packages  
yum -y update  
yum -y upgrade  
yum -y install wget unzip vim  

*Get zip files  
Grab 64-bit linux URL from https://vaultproject.io/downloads.html  
wget URL  
Grab 64-bit linux URL from  https://www.consul.io/downloads.html  
wget URL  

*Unzip and move  
unzip *.zip  
mv consul /usr/bin  
mv vault /usr/bin 

*Start consul   
consul agent -server -bootstrap-expect 1 -date-dir /tmp/consul  

*Create config.hcl file for vault  similar to the following (you need the 127 ip to run vault commands locally):  

backend "consul" {  
  address = "127.0.0.1:8500"  
  path = "vault"  
}  

listener "tcp" {  
 address = "10.0.1.82:8200"  
 tls_disable = 0  
}  

listener "tcp" {  
 address = "127.0.0.1:8200"  
 tls_disable = 0  
}  


*Start vault  
vault server -config=config.hcl  
vault init -key-shares=8 -key-threshold=1  

Vault will initialize and spit out the sharded master key and the root token. Save these in a safe place and distribute accordingly.  