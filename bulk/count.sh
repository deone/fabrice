#!/bin/sh

# Automate all items in checklist that give a count value as result.

export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice/"

# Config
. ${FABRICE_PATH}bulk/config.sh

# Source SQL file
. ${sql_dir}/count.sql.sh

out_dir="${FABRICE_PATH}bulk/out"

find ${out_dir} -name '*.txt' -mtime +1 -exec rm -f {} \;

out_file="${out_dir}/values.out"
sql_results="${out_dir}/count_${date_string}.txt"

results=`echo $no9 | sqlplus -S $conn_string`
echo "9." $results > $out_file

results=`echo $no10 | sqlplus -S $conn_string`
echo "10." $results >> $out_file

results=`echo $no12 | sqlplus -S $conn_string`
echo "12." $results >> $out_file

results=`echo $no16 | sqlplus -S $conn_string`
echo "16." $results >> $out_file

results=`echo $no25 | sqlplus -S $conn_string`
echo "25." $results >> $out_file

results=`echo $no26 | sqlplus -S $conn_string`
echo "26." $results >> $out_file

awk '{ print $1 " " $4 }' $out_file > $sql_results
rm $out_file
