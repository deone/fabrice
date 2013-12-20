#!/bin/sh

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
. ${FABRICE_PATH}trow/trow.cfg.sh

while read line
do
    value="${line:0:${#line}-1}"
    sqlplus -S $conn_string @${FABRICE_PATH}trow/sql/update.sql $value
done < $csv

echo "commit;" | sqlplus -S $conn_string
