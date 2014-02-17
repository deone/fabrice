#!/bin/sh

date

email="/Users/deone/.virtualenvs/fabrice/fabrice/mul/out/email.txt"

cat << EOF > $email
Hello,

Please modify credit limit for the attached numbers.

Regards,
Ramo :-)
EOF

clfile="/Users/deone/.virtualenvs/fabrice/fabrice/mul/out/cl.txt"
recipients="eeswar.jagadisan@tecnotree.com"
cc="osikoya.oladayo@tecnotree.com;chandra.mohan@tecnotree.com"

if [ -f $clfile ]; then
    /opt/boxen/homebrew/bin/mutt -s "Modify Credit Limit" -c $cc -a $clfile -- $recipients < $email
    rm $clfile
    echo "CL file sent and deleted"
else
    echo "Exiting...CL file not found"
fi

exit
