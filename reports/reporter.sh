#!/bin/sh

# Grab report name from SQL filename.
report_name=`echo $@ | rev | cut -d '/' -f 1  | rev | cut -d '.' -f 1`
report_verbose_name=`echo $report_name | tr '_' ' '`
report_capital_name=`echo $report_verbose_name | awk '{ print toupper($0) }'`

# Set/Fetch env. vars on both dev and live
# Dev
if [[ "$OSTYPE" == "darwin13" ]]; then
    export FABRICE_DEBUG="true"
    export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice/"
    . ~/.profile
# Live
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    export FABRICE_DEBUG="false"
    export FABRICE_PATH="/home/pm_client/fabrice/"
    . ~/.bash_profile
fi

# Source config file
. ${FABRICE_PATH}reports/reports.cfg.sh

# Output files
if [[ "$report_name" == "sms_queue" ]]; then
    sql_results=$results_dir/${report_name}.out
    email=$emails_dir/${report_name}.mail
else
    sql_results=$results_dir/${report_name}_${month_name}_${year}.csv
    email=$emails_dir/template.mail
fi

# Fetch data
if [[ "$report_name" != "sms_queue" ]]; then
    value=101000001${year}${month_number}0
    sqlplus -S $conn_string @${reports_sql_path}${report_name}.sql $value > $sql_results
fi

if [[ "$report_name" == "data_offer_rental" ]]; then
    sqlplus -S $conn_string @${reports_sql_path}${report_name}_count.sql $bill_cycle_code >> $sql_results
fi

if [[ "$report_name" == "sms_queue" ]]; then
    sqlplus -S $conn_string @${reports_sql_path}${report_name}.sql > $sql_results
    count=`cat $sql_results | sed 's/COUNT(1)//' | sed 's/-*$//' | grep -v "^$" | grep -v "rows" | awk '{print $1}'`
fi

# Compose email
if [[ "$report_name" != "sms_queue" ]]; then
    cat << EOF > $email
    Hello,

    Please find attached the $report_verbose_name report for $month_name $year.

    Thanks,
    Tecnotree MSO Team.
EOF
fi

if [[ "$FABRICE_DEBUG" == "false" ]]; then
    recipients="$allreports;rjmalm@mtn.com.gh;dtenartey@mtn.com.gh;soakoto@mtn.com.gh;msali@mtn.com.gh;titani@mtn.com.gh;abfaisal@mtn.com.gh;dannan@mtn    .com.gh;sannan@mtn.com.gh;doseiboateng@mtn.com.gh"
    cc=$live_cc
    if [[ "$report_name" == "sms_queue" ]]; then
	recipients=$live_cc
	cc="ganesh.giri@tecnotree.com"
    fi
fi

# Send email
if [[ "$report_name" == "sms_queue" ]]; then
    if [[ "$count" -ge "500" ]]; then
	mutt -s "${report_capital_name} for `date`" -c $cc $recipients < $email
    fi
else
    mutt -s "${report_capital_name} Report For $month_name $year" -c $cc -a $sql_results -- $recipients < $email
fi
