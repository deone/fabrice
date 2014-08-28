#!/bin/bash

# 1. Select numbers from db.
# 2. Generate EMA commands by running them through the MUL mismatch script.
# 3. Fire commands to EMA endpoint.
# 4. Update numbers as fixed in db.

# Load config
. ${FABRICE_PATH}/mul/mul.cfg.sh

# Fetch numbers from either file or DB as source.
if [[ -n "$@" ]]; then
  if [[ "$@" == "--source=db" ]]; then
    sqlplus -S $conn_string @${FABRICE_PATH}/mul/sql/numbers.sql > $numbers
  else
    echo "Invalid option. Please use --source=db"
    exit
  fi
fi

# Create CSV file 
cat $numbers | awk -v a="'" -v b="'," '{ print a $1 b }' > $csv
    
sqlplus -S $conn_string @${FABRICE_PATH}/mul/sql/truncate.sql

while read line
do
  value="${line:0:${#line}-1}"
  sqlplus -S $conn_string @${FABRICE_PATH}/mul/sql/mul.sql $value
done < $csv

echo "commit;" | sqlplus -S $conn_string

sqlplus -S $conn_string @${FABRICE_PATH}/mul/sql/commands.sql > $commands
