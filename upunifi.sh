#!/bin/bash

VERSION=$1
TEMPDIR='/tmp/unifi'
DATA=$(date +"%d%m%Y")

mkdir $TEMPDIR

wget -c https://dl.ui.com/unifi/$VERSION/UniFi.unix.zip -O $TEMPDIR/UniFi.unix.$VERSION.zip

systemctl stop unifi

tar -C /opt/UniFi -zcpvf backup_$DATA.tar.gz data

unzip -qo $TEMPDIR/UniFi.unix.$VERSION.zip -d /opt

chown -R ubnt.ubnt /opt/UniFi

tar -C /opt/UniFi -xzpvf backup_$DATA.tar.gz

systemctl start unifi
