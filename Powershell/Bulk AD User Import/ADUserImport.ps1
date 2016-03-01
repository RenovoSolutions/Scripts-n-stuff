<# Make sure to update the appropiate items, such as CSV name and domain name
CSV should be laid out like:

SAM,FN,LN,PASSWORD,GROUP
jsmith,John,Smith,password123,Managers
bsmith,Bob,Smith,password321,Admin

You should use strong-randomly-generated passphrases and make sure users change them.

Run with the AD module for Powershell #>

Import-Csv example.csv | foreach-object { 
$userprinicpalname = $_.SAM + "@example.come"
$fullname = $_.FN + " " + $_.LN 
New-ADUser -SamAccountName $_.SAM -UserPrincipalName $userprinicpalname -Name $fullname -DisplayName $fullname -GivenName $_.FN -SurName $_.LN -Path "CN=Users,DC=example,DC=com" -AccountPassword (ConvertTo-SecureString $_.PASSWORD -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru 
Add-ADGroupMember $_.GROUP $_.SAM 
}