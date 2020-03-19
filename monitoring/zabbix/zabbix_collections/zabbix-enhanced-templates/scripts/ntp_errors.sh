#!/bin/bash

ZBX_JSON='{"data":[]}'

for NTP_PEER in `/usr/bin/ntpq -p |egrep '^\*|^\#|^\o|^\+|^\x|^\.|^\-|^ ' |grep -v '^  ' |awk '{print $1}' |sed -e 's/^[*+-]//'`; do
  ZBX_JSON=`jq -c ".data |= .+ [{\"{#NTP_PEER}\" : \"${NTP_PEER}\"}]" <<< ${ZBX_JSON}`
done

echo ${ZBX_JSON}

root@ntp:/etc/zabbix/scripts# cat ntp_errors.sh
#!/bin/bash

fn_display_buffer () {
    unset packets
    let buffer=0$1
    while [ $buffer -ne 0 ]; do
        packets=$(( buffer %  2 ))$packets
        buffer=$((  buffer >> 1 ))
    done

    echo $packets |awk -F0 '{print NF-1}'
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <peer ip>"
    exit 1
fi

/usr/bin/ntpq -p |grep -q $1

if [ $? -ne 0 ]; then
    echo -e "Error: Peer not exists\n"
    /usr/bin/ntpq -p
    exit 1
fi

fn_display_buffer `/usr/bin/ntpq -p |grep $1 |awk '{print $7}'`

