#!/bin/sh

# DB
conn_string="abillity_view/abillity_view@TTPROD"

# files
fabrice_out_path="${FABRICE_PATH}reports/out/"

emails_dir="${fabrice_out_path}emails"
results_dir="${fabrice_out_path}results"
files_dir="${fabrice_out_path}files"

# date
year=`date +%Y`
if [ "$FABRICE_DEBUG" == "true" ]; then
    month_number=`date -v -1m +%m`
    month_name=`date -v -1m +%B`
else
    month_number=`date +%m -d last-month`
    month_name=`date +%B -d last-month`
fi

# email
