#!/bin/bash

sudo innobackupex --ftwrl-wait-timeout=20 --user=root --password=adgjla /root/backup
#sudo innobackupex --user=root --password=adgjla --ftwrl-wait-timeout=20 --kill-long-queries-timeout=10 --kill-long-query-type=all /root/backup
rm -rf /root/backup
