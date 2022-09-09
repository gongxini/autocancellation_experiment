#!/bin/bash

function normal {
  $POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=100000 --threads=1 --time=306  --percentile=50 $POSTGRES_SYSBENCH_DIR/share/sysbench/select_random_ranges.lua --report-interval=1 run & 
  sleep 30
  pkill sysbench
  sleep 1
  $POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=100000 --threads=1 --time=306  --percentile=50 $POSTGRES_SYSBENCH_DIR/share/sysbench/oltp_update_index.lua --report-interval=10 run &
  cat ./back.sql | $PSANDBOX_POSTGRES_DIR/bin/psql postgres > /dev/null &
  sleep 11
  echo "interference"
  sleep 300
  echo "interference end"
  sleep 10
  $POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=100000 --threads=1 --time=306  --percentile=50 $POSTGRES_SYSBENCH_DIR/share/sysbench/select_random_ranges.lua --report-interval=1 run & 
  sleep 33
}

postgres -D $PSANDBOX_POSTGRES_DIR/data/ --config-file=$PSANDBOX_POSTGRES_DIR/data/postgresql.conf &
sleep 1

$POSTGRES_SYSBENCH_DIR/bin/sysbench --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=100000 $POSTGRES_SYSBENCH_DIR/share/sysbench/oltp_update_index.lua cleanup >> /dev/null
$POSTGRES_SYSBENCH_DIR/bin/sysbench --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=100000 $POSTGRES_SYSBENCH_DIR/share/sysbench/oltp_update_index.lua prepare >> /dev/null

normal

pkill postgre
