#!/bin/bash

sshpass -p "root" ssh-copy-id -o StrictHostKeyChecking=no root@hadoop-slave1
sshpass -p "root" ssh-copy-id -o StrictHostKeyChecking=no root@hadoop-slave2
sshpass -p "root" ssh-copy-id -o StrictHostKeyChecking=no root@hadoop-slave3
sshpass -p "root" ssh-copy-id -o StrictHostKeyChecking=no root@hadoop-slave4
