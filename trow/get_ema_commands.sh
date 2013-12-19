#!/bin/sh

# 1. Select numbers from db.
# 2. Generate EMA commands by running them through the MUL mismatch script.
# 3. Fire commands to EMA endpoint.
# 4. Update numbers as fixed in db.

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
. ${FABRICE_PATH}trow/trow.cfg.sh

# Fetch data
sqlplus -s $conn_string > $numbers << EOF
set linesize 1000
set colsep ,
set pagesize 0
set feedback off

select mobile_number_v from (select distinct mobile_number_v, action_date from tmp_trow_mul_check where update_flg_v = 'N' order by action_date);

EXIT;
EOF

# Create CSV file 
cat $numbers | awk -v a="'" -v b="'," '{ print a $1 b }' > $csv
    
sqlplus -S $conn_string @${FABRICE_PATH}trow/sql/truncate.sql

while read line
do
    value="${line:0:${#line}-1}"
    sqlplus -S $conn_string @${FABRICE_PATH}trow/sql/mul.sql $value
done < $csv

sqlplus -S $conn_string @${FABRICE_PATH}trow/sql/select.sql > $commands
