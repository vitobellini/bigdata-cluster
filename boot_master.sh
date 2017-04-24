#!/bin/bash


mv /root/conf-hadoop-master/* $HADOOP_HOME/etc/hadoop/

if [ -f /root/serf-master.json ]; then
	mv /root/serf-master.json /etc/serf/serf-master.json 
fi

if [ -f /root/masters ]; then
	mv /root/masters $HADOOP_HOME/etc/hadoop/
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord-master.conf
