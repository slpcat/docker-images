#!/bin/bash
set -e
parse_dns () {
        START=`expr index "$1" sb://`
        END=`expr index "$1" \;`
        SSTART=$((START+5))
        SEND=$(($END -$SSTART -1))
        echo `expr substr $1 $SSTART $SEND`
}
topic=mytopic
count=10000
size=1000
rate=100
while getopts ":t:c:s:r:d:h:" opt; do
  case $opt in
    t) topic="$OPTARG"
    ;;
    c) count="$OPTARG"
    ;;
    s) size="$OPTARG"
    ;;
    r) rate="$OPTARG"
    ;;
    d) dest="$OPTARG"
    ;;
    h) echo usage
        echo -t topic to send to
        echo -c count of messages to sned
        echo -s size of each message
        echo -r rate per second to send
        echo -d destination connection string of Event Hubs namespace
    ;;
    \?) echo "Invalid option -$OPTARG use -h for help" >&2
    ;;
  esac
done
if [[ ! -z $dest ]]
then
    DNS=$(parse_dns $dest)
    PERF_PRODUCER_CONFIG="bootstrap.servers=$DNS:9093\nclient.id=mirror_maker_producer\nrequest.timeout.ms=60000\nsasl.mechanism=PLAIN\nsecurity.protocol=SASL_SSL\nsasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"\$ConnectionString\" password=\"$dest\";"
    echo -e $PERF_PRODUCER_CONFIG > perf.producer.config
    kafka-producer-perf-test --topic $topic --record-size $size --producer.config perf.producer.config  --throughput $rate --num-records $count
else
    echo "missing -d destinaton connection string, use -h for help"
fi
