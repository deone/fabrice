#!/bin/sh

# Send notification if there are more than 500 messages with STATUS_V 'Q' in table SMS_MESSAGE_QUEUE

# Fetch environment variables
if [ "$OSTYPE" == "linux-gnu" ]; then
    . ~/.bash_profile
else
    . ~/.profile
fi

# Source config file
. $(dirname $0)/reports.cfg

sql_results=$results_dir/sms_queue.out
email=$emails_dir/sms_queue.mail

# Email only me in development mode
if [ "$HOSTNAME" == "Oladayos-MacBook-Pro.local" ]; then
    addresses="$culprits"
else
    addresses="$culprits;ganesh.giri@tecnotree.com"
fi

sqlplus -s $conn_string > $sql_results << EOF
SELECT COUNT(1) FROM SMS_MESSAGE_QUEUE WHERE STATUS_V ='Q';
EXIT;
EOF

count=`cat $sql_results|sed 's/COUNT(1)//'|sed 's/-*$//'|grep -v "^$"|grep -v "rows"|awk '{print $1}'`

cat << EOF > $email
Hi Team,

Please check SMS QUEUE count is now more than 500.

Thanks,
Tecnotree MSO Team.
EOF

if [ "$count" -ge "500" ]; then
    mutt -s "SMS Queue for `date`" -- $addresses < $email
fi
