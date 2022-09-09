#!/bin/bash

function normal {
$POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=1000000 --threads=1 --time=90 $POSTGRES_SYSBENCH_DIR/share/sysbench/select_random_points.lua --report-interval=1 --percentile=50 run &
sleep 20
./back.sh  &
echo "interference"
sleep 20
./cancel.sh
sleep 60
echo "interference end"
sleep 10
}

postgres -D $PSANDBOX_POSTGRES_DIR/data/ --config-file=$PSANDBOX_POSTGRES_DIR/data/postgresql.conf &
sleep 5
$POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=1000000 --threads=1 --time=200 $POSTGRES_SYSBENCH_DIR/share/sysbench/select_random_points.lua --report-interval=10 cleanup 
$POSTGRES_SYSBENCH_DIR/bin/sysbench  --pgsql-db=postgres --pgsql-user=$(whoami) --tables=1 --table-size=1000000 --threads=1 --time=200 $POSTGRES_SYSBENCH_DIR/share/sysbench/select_random_points.lua --report-interval=10 prepare 
normal
pkill postgre
