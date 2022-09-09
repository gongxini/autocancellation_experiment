#!/bin/bash

function normal {
  sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=500000 --threads=1 --time=80 $SYSBEN_DIR/oltp_update_index.lua --report-interval=1 --percentile=50 run &
  sleep 20
  ./back.sh >> /dev/null & 
  echo "interference"
#  sleep 10
#  ./cancel.sh
  sleep 60
  echo "interference end"
  sleep 15
}

mysqld --defaults-file=../mysql.cnf &
sleep 5
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=500000 $SYSBEN_DIR/oltp_update_index.lua --report-interval=3 cleanup >> /dev/null
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=500000 $SYSBEN_DIR/oltp_update_index.lua --report-interval=3 prepare >> /dev/null
normal
mysqladmin -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root shutdown

