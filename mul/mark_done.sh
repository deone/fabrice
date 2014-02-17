#!/bin/sh

date

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
. ${FABRICE_PATH}mul/mul.cfg.sh

if [ -f $processed ]; then
    while read line
    do
	value="${line:0:${#line}-1}"
	sqlplus -S $conn_string @${FABRICE_PATH}mul/sql/update.sql $value
    done < $processed

    echo "commit;" | sqlplus -S $conn_string
    rm $processed
else
    echo "Exiting...Processed numbers file not found"
fi

exit
