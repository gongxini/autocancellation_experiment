#!/bin/bash
  
psql postgres<< EOF
select 1 from sbtest2 for update;
select 1 from sbtest2 for update;
select 1 from sbtest2 for update;
select 1 from sbtest2 for update;
select 1 from sbtest2 for update;
select 1 from sbtest2 for update;
select 1 from sbtest2 for update;
EOF

