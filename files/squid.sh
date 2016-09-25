#!/bin/sh

INTERVAL=${COLLECTD_INTERVAL:-10}
HOSTNAME=`hostname -f`
while sleep $INTERVAL; do
  squidclient -p 8080 cache_object://localhost/counters \
  | awk -v interval=${INTERVAL} -v host=${HOSTNAME} -F ' = ' \
    '/client_http..*/ { gsub("\\.", "_", $1); print "PUTVAL", host"/squid/counter-"$1, "interval="interval, "N:"$2 }'
done
