#!/bin/bash



function normal {
  sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=1 --table-size=100000 --threads=1 --time=200 $SYSBEN_DIR/select_random_ranges.lua --report-interval=5 --percentile=50 run &
  sleep 20
  ./back.sh >> /dev/null & 
  sleep 3
  echo "interference"
  sleep 90
  echo "interference end"
  sleep 15
}

mysqld --defaults-file=../mysql.cnf &
sleep 5
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=2 --table-size=100000 $SYSBEN_DIR/oltp_update_index.lua --report-interval=3 cleanup >> /dev/null
sysbench --mysql-socket=$PSANDBOX_MYSQL_DIR/mysqld.sock --mysql-db=test --tables=2 --table-size=100000 $SYSBEN_DIR/oltp_update_index.lua --report-interval=3 prepare >> /dev/null
normal
mysqladmin -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root shutdown

