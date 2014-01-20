#!/bin/sh

# Set/Fetch env. vars on both dev and live
# Dev
if [ "$OSTYPE" == "darwin13" ]; then
    export FABRICE_DEBUG="true"
    export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice/"
    . ~/.profile
# Live
elif [ "$OSTYPE" == "linux-gnu" ]; then
    export FABRICE_DEBUG="false"
    export FABRICE_PATH="/home/pm_client/fabrice/"
    . ~/.bash_profile
fi

# Load config
. ${FABRICE_PATH}reports/reports.cfg.sh

# Output files
sql_results=$results_dir/offer_rental_${month_name}_${year}.csv
email=$emails_dir/offer_rental.mail

echo "Mobile Number, Rental Amount - Offer" > $sql_results

# Fetch data
sqlplus -s $conn_string >> $sql_results << EOF

EOF

# Compose email
cat << EOF > $email
Hello,

Please find attached the offer rental report for $month_name $year.

Thanks,
Tecnotree MSO Team.
EOF

if [ "$FABRICE_DEBUG" == "false" ]; then
    recipients="$allreports;rjmalm@mtn.com.gh;dtenartey@mtn.com.gh;soakoto@mtn.com.gh;msali@mtn.com.gh;titani@mtn.com.gh;abfaisal@mtn.com.gh;dannan@mtn    .com.gh;sannan@mtn.com.gh;doseiboateng@mtn.com.gh"
    cc=$live_cc
fi

# Send email
mutt -s "Offer Rental Report For $month_name $year" -c $cc -a $sql_results -- $recipients < $email
