#!/usr/bin/env bash


stats_raw=`curl --connect-timeout 2 --silent --noproxy '*' http://127.0.0.1:60060`
			#echo $stats_raw | jq .
			if [[ $? -ne 0 || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner from localhost:60060${NOCOLOR}"
			else
				khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`
				local cpu_temp=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n $(nproc) | awk '{print $1/1000}' | jq -rsc .` #just a try to get CPU temps
				stats=`echo $stats_raw | jq '{hs: [.hashrate.threads[][0]], temp: '$cpu_temp', uptime: .connection.uptime}'`
			fi
			