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
sql_results=$results_dir/package_rental_${month_name}_${year}.csv
email=$emails_dir/package_rental.mail

echo "Mobile Number, Rental Amount - Package" > $sql_results

# Fetch data
sqlplus -s $conn_string >> $sql_results << EOF
set linesize 1000
set colsep ,
set pagesize 0

SELECT '233'||b.SERVICE_INFO_V, SUM(a.TRANS_AMT_N)/100 
FROM cb_invoice_details a, cb_account_Service_list b
WHERE bill_cycle_full_Code_n=101000001${year}${month_number}0
AND a.serv_acc_link_code_n=b.account_link_code_n
AND (article_code_V,scheme_Ref_code_n) IN (
SELECT article_code_v, cs.scheme_ref_code_n
FROM cb_subscription_articles cs, cb_package cp WHERE cs.scheme_ref_code_n=cp.scheme_Ref_code_n)
AND trans_amt_n >0
GROUP BY '233'||b.SERVICE_INFO_V;

EXIT;
EOF

# Compose email
cat << EOF > $email
Hello,

Please find attached the package rental report for $month_name $year.

Thanks,
Tecnotree MSO Team.
EOF

if [ "$FABRICE_DEBUG" == "false" ]; then
    recipients="$allreports;rjmalm@mtn.com.gh;dtenartey@mtn.com.gh;soakoto@mtn.com.gh;msali@mtn.com.gh;titani@mtn.com.gh;abfaisal@mtn.com.gh;dannan@mtn    .com.gh;sannan@mtn.com.gh;doseiboateng@mtn.com.gh"
    cc=$live_cc
fi

# Send email
mutt -s "Package Rental Report For $month_name $year" -c $cc -a $sql_results -- $recipients < $email
