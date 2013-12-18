#!/bin/sh

# Send notification if there are more than 500 messages with STATUS_V 'Q' in table SMS_MESSAGE_QUEUE

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

sql_results=$results_dir/sms_queue.out
email=$emails_dir/sms_queue.mail

sqlplus -s $conn_string > $sql_results << EOF

SELECT COUNT(1) FROM SMS_MESSAGE_QUEUE WHERE STATUS_V ='Q';

EXIT;
EOF

count=`cat $sql_results | sed 's/COUNT(1)//' | sed 's/-*$//' | grep -v "^$" | grep -v "rows" | awk '{print $1}'`

cat << EOF > $email
Hi Team,

Please check SMS QUEUE count is now more than 500.

Thanks,
Tecnotree MSO Team.
EOF

if [ "$FABRICE_DEBUG" == "false" ]; then
    recipients=$live_cc
    cc="ganesh.giri@tecnotree.com"
fi

# Send email
if [ "$count" -ge "500" ]; then
    mutt -s "SMS Queue for `date`" -c $cc $recipients < $email
fi
