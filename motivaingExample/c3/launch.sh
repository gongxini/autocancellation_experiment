#!/bin/bash
  
function normal {
  sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=1 --threads=1 --time=90 --percentile=50 --report-interval=1  $SYSBEN_DIR/oltp_update_index.lua  run &
  sleep 20
  ./back.sh >> /dev/null &
  echo "interference"
  sleep 12
  ./cancel.sh
  sleep 60
  echo "interference end"
  sleep 15
}

mysqld --defaults-file=../mysql.cnf &
sleep 5
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=1 --threads=1 --time=65 $SYSBEN_DIR/oltp_update_index.lua --report-interval=3 cleanup 
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=1 --threads=1 --time=65 $SYSBEN_DIR/oltp_update_index.lua --report-interval=3 prepare
normal
mysqladmin -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root shutdown

