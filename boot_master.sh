#!/bin/bash


mv /root/conf-hadoop-master/* $HADOOP_HOME/etc/hadoop/

if [ -f /root/masters ]; then
	mv /root/masters $HADOOP_HOME/etc/hadoop/
fi

if [ -f /root/slaves ]; then
	mv /root/slaves $HADOOP_HOME/etc/hadoop/
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord-master.conf

#hadoop fs -mkdir -p /var/log/hadoop-yarn
