# Hastily put together script for using GAM to assign user orgs appropriately in Google Apps

# Create a file (orgs.csv) with user org information like this per line:
# user,org
# jsmith,payroll
# dsmith,hr

# Run the script using ./assign_g_suite_org.bash <filename>

# Script reads the file, removes the column headers, splits on commas, gets both columns
# It then reads each row and gets the user (u) and the org (o) and uses gam to update the account

cat $1 | tail -n +2 | awk ' BEGIN { FS = "," } ; {print $1" "$2} ' | while read u o; do
  gam update user ${u} org "${o}"
done
