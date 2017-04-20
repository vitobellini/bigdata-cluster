#!/bin/bash


mv /root/conf-hadoop-master/* $HADOOP_HOME/etc/hadoop/

mv /root/masters $HADOOP_HOME/etc/hadoop/
mv /root/slaves $HADOOP_HOME/etc/hadoop/

#hadoop fs -mkdir -p /var/log/hadoop-yarn
