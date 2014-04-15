#!/bin/bash
set -e

#Run mysql user
chown -R mysql:mysql /var/lib/mysql

#Install
mysql_install_db --user mysql > /dev/null

sleep 10s

#Start mysqld 
cd /usr ; /usr/bin/mysqld_safe &  > /dev/null
#mysqld &

sleep 10s

#Setup MYSQL
MYSQL_COMMAND="mysql -uroot mysql -e"

$MYSQL_COMMAND "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'  WITH GRANT OPTION;"
$MYSQL_COMMAND "CREATE DATABASE your_database ;"
$MYSQL_COMMAND "FLUSH PRIVILEGES;"

