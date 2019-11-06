#!/bin/bash

SOURCE_SERVER='172.16.0.10'
DESTINATION_SERVER='172.16.0.30'
PASSWORD="h2jxkLAr@8ZN"
DEFAULT_PASSWORD='$6$rounds=5000$159a3f62ed8cced5$.bkdRSlQqS58BEqzhuhC16yxmyIkaLwsnZj3q9Y2No0hHGBQToU3ph9hOz8R1L7bvY2uFJ9A0a9AwAgH5FvjS/'
#DEFAULT_PASSWORD='$H4lzeITIguNFdxKwDFPweDmdsXfmlFWnGWGgrx.VHok9Ee/BSoL6Iime6Lr7EG6yC.JjQ9RAONgC4sPY/RlvF0'
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
