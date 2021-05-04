#! /bin/bash

cd /var/log || exit 1
touch checkssh.log || exit 1
change=`grep -v "$(who | grep pts)" checkssh.log`

if test change != ""
then
        who | grep pts > checkssh.log
fi

dir="/var/log/checkssh.log"
> ssh_mess.log
rn=1
while true
do
        name=`awk -v var=$rn 'NR==var{printf $1}' ${dir}`
        hour=`awk -v var=$rn 'NR==var{printf $4}' ${dir}`
        date=`awk -v var=$rn 'NR==var{printf $3}' ${dir}`
        message="User ${name} dang nhap thanh cong vao thoi gian ${hour} ${date}"
        if [[ -z $name ]] || [[ -z $hour ]] || [[ -z $date ]]
        then
                exit
        else
                echo $message >> ssh_mess.log
                rn=$((rn+1))
        fi
done
    
