#!/bin/bash

rm $PSANDBOX_MYSQL_DIR/data/test/outfile.csv
rm $PSANDBOX_MYSQL_DIR/data/test/result.csv
mysql -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root << EOF
use test
select * from sbtest2 INTO OUTFILE 'outfile.csv' FIELDS ENCLOSED BY '"' TERMINATED BY ',' ESCAPED BY '"' LINES TERMINATED BY '\r\n';
EOF
