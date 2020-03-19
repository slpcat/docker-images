#!/bin/bash

ZBX_JSON='{"data":[]}'

for NTP_PEER in `/usr/bin/ntpq -p |egrep '^\*|^\#|^\o|^\+|^\x|^\.|^\-|^ ' |grep -v '^  ' |awk '{print $1}' |sed -e 's/^[*+-]//'`; do
  ZBX_JSON=`jq -c ".data |= .+ [{\"{#NTP_PEER}\" : \"${NTP_PEER}\"}]" <<< ${ZBX_JSON}`
done

echo ${ZBX_JSON}

