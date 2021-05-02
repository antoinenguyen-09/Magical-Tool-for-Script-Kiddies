#! /bin/bash

cd /var/log || exit 1
touch checkssh.log || exit 1
change=`grep -v "$(who)" checkssh.log`

if test change != ""
then
	who > checkssh.log

fi
