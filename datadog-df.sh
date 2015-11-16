#!/bin/bash

appname=`basename $0`
pid=$$
tmpfile=/tmp/${appname}.${pid}

trap "rm -f ${tmpfile}*" EXIT

# Make sure you replace the API and or APP key below with the ones for your account
api_key=''


currenttime=$(date +%s)
hostname="`hostname`"
fs_path="/fs_path"

percent=`df -P ${fs_path} | tail -1 | awk '{ print $5 }' | sed -e 's/%//g'`

curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
    [{\"metric\":\"storage.fs_path.percent\",
        \"points\":[[$currenttime, ${percent}]],
        \"type\":\"gauge\",
        \"host\":\"${hostname}\",
        \"tags\":[\"environment:production\"]}
        ]
    }" \
"https://app.datadoghq.com/api/v1/series?api_key=${api_key}"
