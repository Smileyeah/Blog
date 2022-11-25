#!/bin/bash

#use： create_db_mysql_remote.sh dbname
#
#如果mysql中已经有了一个dbname，会先drop掉，
#
#再创建一个空的dbname库，
#
#同时创建一个名为dbname的用户，对这个dbname库有所有权限。

HOSTNAME="127.0.0.1" #数据库Server信息
PORT="3306"
USERNAME="user"
PASSWORD="password"
DBNAME=$1 #要创建的数据库的库名称
MYSQL_CMD="mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD}"
echo ${MYSQL_CMD}

#删除数据库
echo "drop database ${DBNAME}"
drop_db_sql="drop database IF EXISTS ${DBNAME}"
echo ${drop_db_sql} | ${MYSQL_CMD} 
if [ $? -ne 0 ] #判断库是否删除成功
then
        echo "drop databases ${DBNAME} failed ..."
        exit 1
fi

#创建数据库
echo "create database ${DBNAME}"
create_db_sql="create database IF NOT EXISTS ${DBNAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"
echo ${create_db_sql} | ${MYSQL_CMD} 
if [ $? -ne 0 ] #判断是否创建成功
then
        echo "create databases ${DBNAME} failed ..."
        exit 1
fi

#创建用户及分配权限
echo "create user ${DBNAME}"
create_user_sql="grant all privileges on ${DBNAME}.* to ${DBNAME}@'%' identified by 'Ganwei.123'"
echo ${create_user_sql} | ${MYSQL_CMD}
if [ $? -ne 0 ] #判断是否创建成功
then
        echo "create user ${DBNAME} failed ..."
        exit 1
fi

#运行脚本
echo "running sql script in ${DBNAME}"
running_cmd="use ${DBNAME};source IoTCenter13.8_MySQL.sql;"
echo ${running_cmd} | ${MYSQL_CMD} 
if [ $? -ne 0 ]
then
        echo "run script cmd failed..."
        exit 1
fi
