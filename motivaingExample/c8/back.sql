begin;
select c from sbtest1 limit 1; 
SELECT pg_sleep(500);
select c from sbtest1;
commit;
