#!/bin/bash

# Automate all items in checklist that give a count value as result.

. $FABRICE_PATH/lib.sh

# Source SQL file
. ${sql_dir}/count.sql.sh

out_dir=$FABRICE_PATH/bulk/out

find ${out_dir} -name '*.txt' -mtime +1 -exec rm -f {} \;

file=${out_dir}/count_${date_string}.txt

results=`echo $no9 | sqlplus -S $db`
echo "9." $results > $temp_file

results=`echo $no10 | sqlplus -S $db`
echo "10." $results >> $temp_file

results=`echo $no12 | sqlplus -S $db`
echo "12." $results >> $temp_file

results=`echo $no16 | sqlplus -S $db`
echo "16." $results >> $temp_file

results=`echo $no25 | sqlplus -S $db`
echo "25." $results >> $temp_file

results=`echo $no26 | sqlplus -S $db`
echo "26." $results >> $temp_file

awk '{ print $1 " " $4 }' $temp_file > $file
