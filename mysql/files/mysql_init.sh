#!/bin/bash
 
#if [ ! -d /usr/local/webservers/ ];then
#   mkdir /usr/local/webservers
#fi


DIR='/usr/local/webservers/mysql-5.6.19'

#mysq init
if [ "`ls -A /data/mysql/data/`" = "" ];then

$DIR/scripts/mysql_install_db --user=mysql --basedir=/usr/local/webservers/mysql-5.6.19/ --datadir=/data/mysql/data

fi

#mysq grains
/bin/chown -R mysql.mysql /data/mysql

#service managed script
/bin/cp $DIR/support-files/mysql.server /etc/init.d/mysqld

#global
CMMD="echo 'export PATH=$PATH:$DIR/bin' > /etc/profile.d/mysql.sh && source /etc/profile.d/mysql.sh"
eval $CMMD
 

