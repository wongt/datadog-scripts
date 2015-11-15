#!/bin/bash
#
# The following script queries a DNS server and calculates the 
# response latency in milliseconds 
#
appname=`basename $0`
pid=$$
tmpfile=/tmp/${appname}.${pid}

trap "rm -f ${tmpfile}*" EXIT

# Make sure you replace the API and or APP key below with the ones for your account
api_key=''


hostname="`hostname`"
dns_server="8.8.8.8"

currenttime=$(date +%s)
lookup_start=$(($(date +%s%N)/1000000))
nslookup google.ca ${dns_server} > /dev/null 2>&1
lookup_end=$(($(date +%s%N)/1000000))

latency=`expr ${lookup_end} - ${lookup_start}`

curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
    [{\"metric\":\"dns.latency\",
        \"points\":[[$currenttime, ${latency}]],
        \"type\":\"gauge\",
        \"host\":\"${hostname}\",
        \"tags\":[\"environment:production\"]}
        ]
    }" \
"https://app.datadoghq.com/api/v1/series?api_key=${api_key}"
