#!/bin/bash

rm /tmp/cancel.txt
mysql -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root << EOF
use test;
select concat('KILL QUERY ',id,';') from INFORMATION_SCHEMA.processlist where Info like "%INTO tables sbtest2%" into outfile '/tmp/cancel.txt';	
source /tmp/cancel.txt; 
EOF
