#!/bin/bash
  
psql postgres<< EOF
BEGIN;
LOCK TABLE sbtest2 IN ACCESS EXCLUSIVE MODE;
select pg_sleep(90);
commit;
EOF

