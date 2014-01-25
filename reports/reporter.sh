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
    if [[ "$report_name" == "concierge_performance" ]]; then
	sql_results=$results_dir/${report_name}.csv
    else
	sql_results=$results_dir/${report_name}_${text_date}.csv
    fi
    email=$emails_dir/template.mail
fi

# Fetch data
if [[ "$report_name" != "sms_queue" ]]; then
    if [[ "$report_name" == "concierge_performance" ]]; then
	sqlplus -S $conn_string @${reports_sql_path}${report_name}.sql > $sql_results
    else
	value=101000001${query_date}0
	sqlplus -S $conn_string @${reports_sql_path}${report_name}.sql $value > $sql_results
	if [[ "$report_name" == "data_offer_rental" ]]; then
	    sqlplus -S $conn_string @${reports_sql_path}${report_name}_count.sql $value >> $sql_results
	fi
    fi
fi

if [[ "$report_name" == "sms_queue" ]]; then
    sqlplus -S $conn_string @${reports_sql_path}${report_name}.sql > $sql_results
    count=`cat $sql_results | sed 's/COUNT(1)//' | sed 's/-*$//' | grep -v "^$" | grep -v "rows" | awk '{print $1}'`
fi

# Compose email
if [[ "$report_name" != "sms_queue" ]]; then
cat << EOF > $email
Hello,

Please find attached the $report_verbose_name report for $text_date.

Thanks,
Tecnotree MSO Team.
EOF
fi

if [[ "$FABRICE_DEBUG" == "false" ]]; then
    cc=$live_cc
    if [[ "$report_name" == "sms_queue" ]]; then
	recipients="ganesh.giri@tecnotree.com"
    elif [[ "$report_name" == "concierge_performance" ]]; then
	recipients="balamurugan.palaniswamy@tecnotree.com;umesh.nanjundaiah@tecnotree.com"
    else
	recipients="$all_reports;rjmalm@mtn.com.gh;dtenartey@mtn.com.gh;soakoto@mtn.com.gh;msali@mtn.com.gh;titani@mtn.com.gh;abfaisal@mtn.com.gh;dannan@mtn.com.gh;sannan@mtn.com.gh;doseiboateng@mtn.com.gh"
    fi
fi

# Send email
if [[ "$report_name" == "sms_queue" ]]; then
    if [[ "$count" -ge "500" ]]; then
	mutt -s "${report_capital_name} for `date`" -c $cc $recipients < $email
    fi
else
    if [[ "$report_name" == "concierge_performance" ]]; then
	mutt -s "${report_capital_name} Report For $text_date" -c $cc -a $sql_results -- $recipients < $email
    else
	mutt -s "${report_capital_name} Report For $text_date" -c $cc -a $sql_results -- $recipients < $email
    fi
fi
