#!/bin/bash

serf members -status=alive -tag role=slave | while read line ;do
  NEXT_HOST=$(echo $line|cut -d' ' -f 1)
  NEXT_ADDR=$(echo $line|cut -d' ' -f 2)
  NEXT_IP=${NEXT_ADDR%%:*}
  echo $NEXT_IP
done > $HADOOP_HOME/etc/hadoop/slaves
