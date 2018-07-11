#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:60060`

khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`
local cpu_temp=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n $(nproc) | awk '{print $1/1000}' | jq -rsc .` #just a try to get CPU temps
stats=`echo $stats_raw | jq '{hs: [.hashrate.threads[][0]], temp: '$cpu_temp', uptime: .connection.uptime}'`