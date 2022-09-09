#!/bin/bash
  
psql postgres<< EOF
BEGIN;
INSERT INTO sbtest1 SELECT id + 1000001,k,c,pad FROM sbtest1 where id < 1000000;
commit;
EOF

