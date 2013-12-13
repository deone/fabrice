#!/bin/sh

# Set env. var to differentiate between dev and production
if [ "$OSTYPE" == "darwin13" ]; then
    export FABRICE_DEBUG="true"
    export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice/"
elif [ "$OSTYPE" == "linux-gnu" ]; then
    export FABRICE_DEBUG="false"
    export FABRICE_PATH="/home/pm_client/fabrice/"
fi

# Load config and SQL library
. ${FABRICE_PATH}reports/reports.cfg.sh

# Output files
sql_results=$results_dir/data_offer_rental_${month_name}_${year}.csv
email=$emails_dir/data_offer_rental.mail

echo "Offer Code, Offer Description, Rental Amount" > $sql_results

# Fetch data
sqlplus -s $conn_string >> $sql_results << EOF
set linesize 1000
set colsep ,
set pagesize 0

SELECT A.OFFER_CODE_V, A.OFFER_DESC_V, SUM(B.TRANS_AMT_N)/100 RENTAL_AMOUNT 
FROM CB_OFFERS A, CB_INVOICE_DETAILS B 
WHERE BILL_CYCLE_FULL_CODE_N =101000001${year}${month_number}0 
AND A.SCHEME_REF_CODE_N=B.SCHEME_REF_CODE_N 
AND DB_CR_V='C' 
AND (B.SCHEME_REF_CODE_N,ARTICLE_CODE_V) IN
(SELECT SCHEME_REF_CODE_N,ARTICLE_CODE_V FROM CB_SUBSCRIPTION_ARTICLES  WHERE SCHEME_REF_CODE_N IN (
SELECT SCHEME_REF_CODE_N FROM CB_OFFERS WHERE (OFFER_DESC_V LIKE '%DATA%' OR OFFER_DESC_V LIKE '%BB%' 
AND CONTRACT_TYPE_N ='N')))
GROUP BY A.OFFER_CODE_V, A.OFFER_DESC_V, DB_CR_V;

EXIT;
EOF

sqlplus -s $conn_string >> $sql_results << EOF
$data_offer_rental_count

EXIT;
EOF

# Compose email
cat << EOF > $email
Hello,

Please find attached the data offer rental report for $month_name $year.

Thanks,
Tecnotree MSO Team.
EOF

# Send email
# This will blow up if cc is an empty string.
mutt -s "Data Offer Rental Report For $month_name $year" -c $cc -a $sql_results -- $recipients < $email
