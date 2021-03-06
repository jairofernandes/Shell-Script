#!/bin/bash

SOURCE_SERVER='IpDoServidorDeOrigem'
DESTINATION_SERVER='IpDoServidorDeDestino'
PASSWORD="h2jxkLAr@8ZN"
DEFAULT_PASSWORD='$6$rounds=5000$159a3f62ed8cced5$.bkdRSlQqS58BEqzhuhC16yxmyIkaLwsnZj3q9Y2No0hHGBQToU3ph9hOz8R1L7bvY2uFJ9A0a9AwAgH5FvjS/'
CONFIGFILE=$1
COMMAND=$(which imapsync)

for DADOS in $(cat $CONFIGFILE); do

        USERNAME=$(echo $DADOS | awk -F ";" '{print $1}')
 
        ORIGIN_PASSWORD=$(echo $DADOS | awk -F ";" '{print $2}')

        mysql --defaults-group-suffix=remoto -e "UPDATE dbispconfig.mail_user SET password='$DEFAULT_PASSWORD' WHERE login='$USERNAME';"

        mysql -e "UPDATE dbispconfig.mail_user SET password='$DEFAULT_PASSWORD' WHERE login='$USERNAME';"

        imapsync --host1 $SOURCE_SERVER --user1 $USERNAME --password1 $PASSWORD --tls1 --host2 $DESTINATION_SERVER --user2 $USERNAME --password2 $PASSWORD --tls2

        mysql --defaults-group-suffix="remoto" -e "UPDATE dbispconfig.mail_user SET password='$ORIGIN_PASSWORD' WHERE login='$USERNAME';"

        mysql -e "UPDATE dbispconfig.mail_user SET password='$ORIGIN_PASSWORD' WHERE login='$USERNAME';"
done
