#!/bin/bash
  
psql postgres<< EOF
BEGIN;
INSERT INTO sbtest2 SELECT id + 1000001,k,c,pad FROM sbtest2 where id < 1000000;
commit;
EOF

