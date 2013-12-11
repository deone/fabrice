#!/bin/sh

# Fetch environment variables and load appropriate config file
if [ "$OSTYPE" == "darwin13" ]; then
    export FABRICE_DEBUG="true"
elif [ "$OSTYPE" == "linux-gnu" ]; then
    export FABRICE_DEBUG="false"
fi

year=`date +%Y`

dev_path="/Users/deone/.virtualenvs/fabrice/fabrice/reports/"
prod_path="/home/pm_client/"

if [ "$FABRICE_DEBUG" == "true" ]; then
    . ${dev_path}reports.dev.cfg.sh
    . ${dev_path}include/sql_statements.sh
else
    . ${prod_path}fabrice/reports/reports.cfg.sh
    . ${prod_path}fabrice/reports/include/sql_statements.sh
fi

if [ "$FABRICE_DEBUG" == "true" ]; then
    month=`date -v -1m +%B`
else
    month=`date +%B -d last-month`
fi

# Files
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
mutt -a $sql_results -s "Data Offer Rental Report For $month $year" -- $recipients -c $cc < $email
