#!/bin/sh

# DB
conn_string="abillity_view/abillity_view@TTPROD"

# files
fabrice_out_path="${FABRICE_PATH}out/"

emails_dir="${fabrice_out_path}emails"
results_dir="${fabrice_out_path}results"
files_dir="${fabrice_out_path}files"

# email
recipients="osikoya.oladayo@tecnotree.com"
cc=""

if [ "$FABRICE_DEBUG" == "false" ]; then
    recipients="rjmalm@mtn.com.gh;dtenartey@mtn.com.gh;soakoto@mtn.com.gh;msali@mtn.com.gh;titani@mtn.com.gh;jkbam@mtn.com.gh;abfaisal@mtn.com.gh;dannan@mtn.com.gh;sannan@mtn.com.gh;doseiboateng@mtn.com.gh"
    cc="jegadeesan.velusamy@tecnotree.com;osikoya.oladayo@tecnotree.com;adetimilehin.hammed@tecnotree.com;Chandra.Mohan@tecnotree.com"
fi
