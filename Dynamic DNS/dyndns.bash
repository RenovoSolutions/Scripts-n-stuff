#Update all the information below:
zone_id="route53zoneid"
COMMENT_TXT="Update record"
NAME_FQDN="example.renovo1.com"
#These three settings probably shouldn't change
template_json="update_record.json"
TTL_NUM_SEC="300"
PUB_IP=$( curl http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null )

#Create tmp JSON file for aws cli
cat update_record.json | sed -e "s/PUB_IP/${PUB_IP}/g" -e "s/COMMENT_TXT/${COMMENT_TXT}/g" -e "s/NAME_FQDN/${NAME_FQDN}/g" -e "s/TTL_NUM_SEC/${TTL_NUM_SEC}/g" > tmp_record.json
#Update the record
aws route53 change-resource-record-sets --hosted-zone-id ${zone_id} --change-batch file:///root/tmp_record.json
#Remove the tmp JSON file
rm -rf tmp_record.json