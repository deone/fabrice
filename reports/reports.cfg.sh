#!/bin/sh

# DB
if [[ "$report_name" == "concierge_performance" ]]; then
    conn_string="concierge_app_gha/concierge_app_gha@TTPROD"
else
    conn_string="abillity_view/abillity_view@TTPROD"
fi

# files
reports_out_path="${FABRICE_PATH}reports/out/"
reports_sql_path="${FABRICE_PATH}reports/sql/"

emails_dir="${reports_out_path}emails"
results_dir="${reports_out_path}results"
files_dir="${reports_out_path}files"

# date
if [ "$FABRICE_DEBUG" == "true" ]; then
    query_date=`date -v -1m +"%Y%m"`
    if [[ "$report_name" == "concierge_performance" || "$report_name" == "total_uploaded_files" ]]; then
	text_date=`date -v -1d +"%d %B %Y"`
	_text_date_=`date -v -1d +"%d_%B_%Y"`
    else
	text_date=`date -v -1m +"%B %Y"`
	_text_date_=`date -v -1m +"%B_%Y"`
    fi
else
    query_date=`date +"%Y%m" -d last-month`
    if [[ "$report_name" == "concierge_performance" || "$report_name" == "total_uploaded_files" ]]; then
	text_date=`date +"%d %B %Y" -d yesterday`
	_text_date_=`date +"%d_%B_%Y" -d yesterday`
    else
	text_date=`date +"%B %Y" -d last-month`
	_text_date_=`date +"%B_%Y" -d last-month`
    fi
fi

# email
recipients="osikoya.oladayo@tecnotree.com"
cc="alwaysdeone@gmail.com"

all_reports="jkbam@mtn.com.gh"
live_cc="jegadeesan.velusamy@tecnotree.com;osikoya.oladayo@tecnotree.com;adetimilehin.hammed@tecnotree.com;Chandra.Mohan@tecnotree.com;eeswar.jagadisan@tecnotree.com;solomon.annan@tecnotree.com"
