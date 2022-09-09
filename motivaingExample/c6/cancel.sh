#!/bin/bash

end=$((SECONDS+20))

while [ $SECONDS -lt $end ]; do
  rm /tmp/cancel.txt
  mysql -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root -e "select concat('KILL QUERY ',id,';') from INFORMATION_SCHEMA.processlist where Info like \"UPDATE sbtest2 SET k=k+1%\" and STATE=\"updating\" into outfile '/tmp/cancel.txt';"
  mysql -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root -e "source /tmp/cancel.txt;"
  sleep 0.1
done
