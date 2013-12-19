#!/bin/sh

# DB
conn_string="abillity_view/abillity_view@TTPROD"

# files
reports_out_path="${FABRICE_PATH}reports/out/"

emails_dir="${reports_out_path}emails"
results_dir="${reports_out_path}results"
files_dir="${reports_out_path}files"

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
recipients="osikoya.oladayo@tecnotree.com"
cc="alwaysdeone@gmail.com"

all_reports="jkbam@mtn.com.gh"
live_cc="jegadeesan.velusamy@tecnotree.com;osikoya.oladayo@tecnotree.com;adetimilehin.hammed@tecnotree.com;Chandra.Mohan@tecnotree.com"
