#!/bin/bash

end=$((SECONDS+10))

while [ $SECONDS -lt $end ]; do
  # rand = $((1 + $RANDOM % 1000))
   mysql -S $PSANDBOX_MYSQL_DIR/mysqld.sock -u root -e "use test;UPDATE sbtest2 SET k=k+1 WHERE id=500;"
done
