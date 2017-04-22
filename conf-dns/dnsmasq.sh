#!/bin/bash

serf members -status=alive | while read line ;do
  NEXT_HOST=$(echo $line|cut -d' ' -f 1)
  NEXT_ADDR=$(echo $line|cut -d' ' -f 2)
  NEXT_IP=${NEXT_ADDR%%:*}
  echo $NEXT_IP	$NEXT_HOST
done > /etc/althosts

service dnsmasq restart
