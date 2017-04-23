#!/bin/bash

/usr/bin/supervisord -c /etc/supervisor/supervisord-slave.conf

#hadoop fs -mkdir -p /var/log/hadoop-yarn
