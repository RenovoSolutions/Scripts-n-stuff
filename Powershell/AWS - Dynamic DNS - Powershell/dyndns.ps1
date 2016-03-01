#Change these two values as needed
$HOSTED_ZONE_ID="zone_id"
$NAME="fqdn"
#Public ip get
$pub_ip=(Invoke-WebRequest http://169.254.169.254/latest/meta-data/public-ipv4).Content
#Get the AWS PowerShell module
Import-Module AWSPowerShell
#Define change values
$change = New-Object Amazon.Route53.Model.Change
$change.Action = "UPSERT"
$change.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
$change.ResourceRecordSet.Name = "$NAME"
$change.ResourceRecordSet.Type = "A"
$change.ResourceRecordSet.TTL = "300"
$change.ResourceRecordSet.ResourceRecords.Add(@{Value="$pub_ip"})

$params = @{
    HostedZoneId="$HOSTED_ZONE_ID"
        ChangeBatch_Comment="Update record"
        ChangeBatch_Change=$change
}
#Perform change
Edit-R53ResourceRecordSet @params