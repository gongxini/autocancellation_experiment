#!/bin/bash
  
mysql -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root << EOF
use test
load data infile "result.csv" INTO table sbtest2 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
EOF

