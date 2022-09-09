#!/bin/bash

function normal {
  sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=100000 --threads=1 --time=90 $SYSBEN_DIR/select_random_points.lua --report-interval=1 --percentile=50 run &
  sleep 20
  ./back.sh >> /dev/null &
  echo "interference"
  sleep 10
  echo "cancel"
  ./cancel.sh
  sleep 60
  echo "interference end"
  sleep 10
}

mysqld --defaults-file=../mysql.cnf &
sleep 5
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=100000 --threads=1 --time=200 $SYSBEN_DIR/oltp_update_index.lua --report-interval=10 --percentile=50 cleanup 
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=100000 --threads=1 --time=200 $SYSBEN_DIR/oltp_update_index.lua --report-interval=10 --percentile=50 prepare
./gendata.sh
./update_data.py
normal
mysqladmin -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root shutdown

