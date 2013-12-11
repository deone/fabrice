#!/bin/sh

. $(dirname $0)/prereqs.sh

if date -v -1m > /dev/null 2>&1; then
    month=`date -v -1m +%B`
else
    month=`date +%B -d last-month`
fi

# Files
sql_results=$results_dir/offer_rental_${month}_${year}.csv
email=$emails_dir/offer_rental.mail

echo "Mobile Number, Rental Amount - Offer" > $sql_results

# Fetch data
sqlplus -s $conn_string >> $sql_results << EOF
set linesize 1000
set colsep ,
set pagesize 0

$offer_rental

EXIT;
EOF

# Compose email
cat << EOF > $email
Hello,

Please find attached the offer rental report for $month $year.

Thanks,
Tecnotree MSO Team.
EOF

# Send email
mutt -a $sql_results -s "Offer Rental Report For $month $year" -- $recipients -c $culprits < $email
