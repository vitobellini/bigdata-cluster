# docker-hadoop
Hadoop Cluster with Docker

![hadoop logo](https://hadoop.apache.org/images/hadoop-logo.jpg)

### Prerequisites

Before to start, you have to had the following softwares to be installed on all your machines:

- [docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/install/)

#### Installing Docker Engine

https://docs.docker.com/engine/installation/

#### Installing docker-compose

```
$ sudo apt-get update && sudo apt-get -y upgrade
$ sudo apt-get install python-pip
$ sudo pip install docker-compose
```

## Run example

Master
```bash
$ sudo docker-compose up -d
```

Slaves
```bash
$ sudo docker-compose up -d slave
```
