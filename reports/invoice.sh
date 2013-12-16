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
sql_results=$results_dir/invoice_${month_name}_${year}.csv
email=$emails_dir/invoice.mail

echo "Account Code, Account Name, Invoice Amt Inc. Tax, Subscriber Category, Subscriber Sub Category" > $sql_results

# Fetch data
sqlplus -s $conn_string >> $sql_results << EOF
set linesize 1000
set colsep ,
set pagesize 0

SELECT ACCOUNT_CODE_N, ACCOUNT_NAME_V, 
INVOICE_AMT_N/100+INVOICE_TAX_N/100, B.SUBSCRIBER_CATEGORY_V, 
B.SUBSCRIBER_SUB_CATEGORY_V 
FROM CB_INVOICE A, CB_ACCOUNT_MASTER B 
WHERE A.ACCOUNT_LINK_CODE_N=B.ACCOUNT_LINK_CODE_N 
AND SUBSCRIBER_CATEGORY_V='CORP' 
AND BILL_CYCL_FULL_CODE_N=101000001${year}${month_number}0;

EXIT;
EOF

# Compose email
cat << EOF > $email
Hello,

Please find attached the invoice report for $month_name $year.

Thanks,
Tecnotree MSO Team.
EOF

# Send email
mutt -s "Invoice Report For $month_name $year" -c $cc -a $sql_results -- $recipients < $email
