#!/bin/bash

function test()
{
	runningTime=$(( $2 * 3 / 2))
	
	sysbench /usr/share/sysbench/oltp_read_only.lua --db-driver=mysql --mysql-port=3306 --mysql-user=root --mysql-password=adgjla --mysql-db=test --tables=3 --table-size=100000 --threads=10 --time=$runningTime --report-interval=1 --percentile=50 run > resultCancelAt$1 2>&1 &
	sleep 20
	sudo ./select.sh &
	sudo ./xtrabackup.sh > /dev/null 2>&1 &
	sleep $1
	sudo ./cancel.sh &
	sleep 5
	sudo ./select.sh &
}


sysbench /usr/share/sysbench/oltp_read_only.lua --db-driver=mysql --mysql-port=3306 --mysql-user=root --mysql-password=adgjla --mysql-db=test --tables=3 --table-size=100000 --threads=10 --time=120 --report-interval=3 cleanup
sysbench /usr/share/sysbench/oltp_read_only.lua --db-driver=mysql --mysql-port=3306 --mysql-user=root --mysql-password=adgjla --mysql-db=test --tables=3 --table-size=100000 --threads=10 --time=120 --report-interval=3 prepare

start=$(date +%s)
sudo ./select.sh
end=$(date +%s)
take=$(( end -start ))
echo $take

test $(( take * 10 / 100 )) $take
sleep 700
test $(( take / 2 )) $take
sleep 700
test $(( take * 90 / 100 )) $take
