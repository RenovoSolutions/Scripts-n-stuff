# Script to get the current Vonage status
# If its yellow or red it will send a warning email
# If an email is sent to creates a lock file to prevent spamming
# Run this from cron however often you want
# Run another cron job to clear the lock as often as you want

# curl their crappy status page
# get the line with current status
# remove the garbage
# find out if the status color is yellow or red
# this isn't fool proof because sometimes they have issues posted and its green
curl -s vonagebusiness.force.com/trust | grep "Current Status" | sed -e 's/<[^>]*>//g' | sed -e 's/[ \t]*//' -e 's/[ \t]*$//' | grep "Yellow\|Red"

# if its red or yellow and there is no lock file send an email
if [[ $? == 0 ]]; then
        ls -l /root/vonage.lock &>/dev/null
        if [[ $? == 2 ]]; then
                echo "Vonage is currently in a degraded or down status. View http://vonagebusiness.force.com/trust for full details." | mailx -s "WARNING: Vonage Issues" -r noreply@renovo1.com support@renovo1.com
        fi
        echo "warn" > /root/vonage.lock
fi
