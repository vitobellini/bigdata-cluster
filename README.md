# docker-hadoop
Hadoop Cluster with Docker

![hadoop logo](https://hadoop.apache.org/images/hadoop-logo.jpg)

### Prerequisites

Before to start, you have to had the following softwares to be installed on all your machines:

- [docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/install/)

```
Give examples
```

## Run example

Master
```bash
$ sudo docker-compose up -d
```

Slaves
```bash
$ sudo docker-compose up -d datanode
```
