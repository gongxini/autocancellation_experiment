#!/bin/bash
  
psql postgres<< EOF
select pg_sleep(200);
EOF

