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
sql_results=$results_dir/toll_free_invoice_${month_name}_${year}.csv
email=$emails_dir/toll_free_invoice.mail

echo "MSISDN, Invoice" > $sql_results

# Fetch data
sqlplus -s $conn_string >> $sql_results << EOF
set linesize 1000
set colsep ,
set pagesize 0

SELECT service_info_v, (invoice_amt_n + tax_amt_n) / 100 
FROM cb_account_service_list a, cb_sub_invoice b
WHERE service_info_v LIKE '540118%'
AND b.account_link_code_n = a.account_link_code_n
AND bill_cycl_full_code_n = 101000001${year}${month_number}0;

EXIT;
EOF

# Compose email
cat << EOF > $email
Hello,

Please find attached the toll free invoice report for $month_name $year.

Thanks,
Tecnotree MSO Team.
EOF

if [ "$FABRICE_DEBUG" == "false" ]; then
    recipients="$allreports;sayador@mtn.com.gh"
    cc=$live_cc
fi

# Send email
mutt -s "Toll-free Invoice Report For $month_name $year" -c $cc -a $sql_results -- $recipients < $email
