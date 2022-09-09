#!/bin/bash

function normal {
$POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=1000000 --threads=1 --time=90 $POSTGRES_SYSBENCH_DIR/share/sysbench/select_random_points.lua --report-interval=1 --percentile=50 run &
iostat -m 1 > log.txt &
sleep 30
./back.sh &
sleep 10
#$POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=2 --table-size=1000000 --threads=1 --time=90 $POSTGRES_SYSBENCH_DIR/share/sysbench/select_random_points.lua --report-interval=1 --percentile=50 run &
sleep 90
}

postgres -D $PSANDBOX_POSTGRES_DIR/data/ --config-file=$PSANDBOX_POSTGRES_DIR/data/postgresql.conf &
sleep 5
$POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=2 --table-size=1000000 --threads=1 --time=200 $POSTGRES_SYSBENCH_DIR/share/sysbench/oltp_update_index.lua --report-interval=10 cleanup 
$POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=2 --table-size=1000000 --threads=1 --time=200 $POSTGRES_SYSBENCH_DIR/share/sysbench/oltp_update_index.lua --report-interval=10 prepare 
normal
pkill postgre
