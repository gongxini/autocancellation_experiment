#!/bin/bash

function normal {
  sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=5 --table-size=1000 --threads=1 --time=200  --percentile=50 --report-interval=1 $SYSBEN_DIR/oltp_point_select.lua run & 
  sleep 20
  echo "cancel"
  sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=5 --table-size=1000 --threads=1 --time=197 $SYSBEN_DIR/oltp_update_index.lua run >> /dev/null &
  sleep 1
  ./cancel.sh &
  sleep 200
}

mysqld --defaults-file=my.cnf &
sleep 5

sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=5 --table-size=1000 --threads=1 --time=70 $SYSBEN_DIR/oltp_point_select.lua --report-interval=3 cleanup >> /dev/null
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=5 --table-size=1000 --threads=1 --time=70 $SYSBEN_DIR/oltp_point_select.lua --report-interval=3 prepare >> /dev/null
normal
mysqladmin -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root shutdown

