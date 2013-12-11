#!/bin/sh

# Fetch environment variables
if [ "$OSTYPE" == "linux-gnu" ]; then
    . ~/.bash_profile
else
    . ~/.profile
fi

year=`date +%Y`

# Source config file
. $(dirname $0)/include/reports.cfg

# Source SQL statements
. $(dirname $0)/include/sql_statements.sh
