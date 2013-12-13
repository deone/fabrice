#!/bin/sh

# Set env. var to differentiate between dev and production
if [ "$OSTYPE" == "darwin13" ]; then
    export FABRICE_DEBUG="true"
    export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice/"
elif [ "$OSTYPE" == "linux-gnu" ]; then
    export FABRICE_DEBUG="false"
    export FABRICE_PATH="/home/pm_client/fabrice/"
fi

year=`date +%Y`

# Load config and SQL library
. ${FABRICE_PATH}reports/reports.cfg.sh
. ${FABRICE_PATH}reports/include/queries.sh

if [ "$FABRICE_DEBUG" == "true" ]; then
    month=`date -v -1m +%B`
else
    month=`date +%B -d last-month`
fi

# Output files
sql_results=$results_dir/data_offer_rental_${month}_${year}.csv
email=$emails_dir/data_offer_rental.mail

echo "Offer Code, Offer Description, Rental Amount" > $sql_results

# Fetch data
sqlplus -s $conn_string >> $sql_results << EOF
set linesize 1000
set colsep ,
set pagesize 0

$data_offer_rental_items

EXIT;
EOF

sqlplus -s $conn_string >> $sql_results << EOF
$data_offer_rental_count

EXIT;
EOF

# Compose email
cat << EOF > $email
Hello,

Please find attached the data offer rental report for $month $year.

Thanks,
Tecnotree MSO Team.
EOF

# Send email
# This will blow up if cc is an empty string.
mutt -s "Data Offer Rental Report For $month $year" -c $cc -a $sql_results -- $recipients < $email
