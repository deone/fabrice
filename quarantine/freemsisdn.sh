#!/bin/sh

export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice"

numbers="${FABRICE_PATH}/quarantine/numbers.txt"
verify="${FABRICE_PATH}/quarantine/verify.txt"
conn_string="tt_mso/ttmso1@TTPROD"

while read line
do
  value="${line:0:${#line}-1}"
  sqlplus -S $conn_string @${FABRICE_PATH}/quarantine/sql/quarantine.sql $value
  echo "commit;" | sqlplus -S $conn_string

  sqlplus -S $conn_string @${FABRICE_PATH}/quarantine/sql/verify.sql $value >> $verify
done < $numbers

cat $verify

rm $verify
