#!/bin/bash
  
psql postgres<< EOF
select pg_cancel_backend(pid) from pg_stat_activity WHERE query = 'INSERT INTO sbtest1 SELECT id + 1000001,k,c,pad FROM sbtest1 where id < 1000000;';
EOF

