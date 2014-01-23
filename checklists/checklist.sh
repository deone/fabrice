#!/bin/sh

# Automate all items in checklist that give a count value as result.

export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice/"

# Config
conn_string="abillity_view/abillity_view@TTPROD"

date_string=`date +'%d%m%Y'`

# Source SQL file
. ${FABRICE_PATH}checklists/sql/checklist/count.sql.sh

out_file=${FABRICE_PATH}checklists/out/results/values.out
sql_results=${FABRICE_PATH}checklists/out/checklist_${date_string}.txt

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
