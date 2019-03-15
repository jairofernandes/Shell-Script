#!/bin/bash

COUNT=0

if [ -z $1 ]
then
    USER="MAILER-DAEMON"
else
    USER=$1
fi

QUEUE=$(mailq |grep $USER |wc -l)
for MAIL in $(mailq |grep $USER |cut -d" " -f1)
do
    #echo $MAIL
    postsuper -d $MAIL
    COUNT=$(($COUNT + 1))
done

echo ""
echo "###################################################################"
echo ""
echo "E-mails do usuário $USER parados na fila ........: $QUEUE"
echo "E-mails do usuário $USER removidos na fila ......: $COUNT"
echo ""
echo "###################################################################"
echo ""

exit 0
