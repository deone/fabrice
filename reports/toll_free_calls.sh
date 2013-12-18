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
sql_results=$results_dir/toll_free_calls_${month_name}_${year}.csv
email=$emails_dir/toll_free_calls.mail

echo "Called Number, Calling Number, Date, Duration, Charge" > $sql_results

# Fetch data
sqlplus -s $conn_string >> $sql_results << EOF
set linesize 1000
set colsep ,
set pagesize 0

SELECT mobile_number_v, called_calling_number_v, 
call_date_time_dt, duration_n, charge_amount_n / 1000 
FROM cb_upload_all_cdrs
WHERE mobile_number_v LIKE '540118%'
AND bill_cycl_full_code_n = 101000001${year}${month_number}0;

EXIT;
EOF

# Compose email
cat << EOF > $email
Hello,

Please find attached the toll free call report for $month_name $year.

Thanks,
Tecnotree MSO Team.
EOF

if [ "$FABRICE_DEBUG" == "false" ]; then
    recipients="$allreports;sayador@mtn.com.gh"
    cc=$live_cc
fi

# Send email
mutt -s "Toll-free Calls Report For $month_name $year" -c $cc -a $sql_results -- $recipients < $email
