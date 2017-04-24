# docker-hadoop
Hadoop Cluster with Docker

![hadoop logo](https://hadoop.apache.org/images/hadoop-logo.jpg)

### Prerequisites

Before to start, you have to had the following softwares to be installed on all your machines:

- [docker](https://www.docker.com/)

#### Installing Docker Engine

https://docs.docker.com/engine/installation/

## Setup your network

Run the following command on your master pc.

```bash
$ sudo docker swarm init --advertise-addr <ip of your master>
```

Then, make every node of your cluster, to join the docker swarm cluster.

```bash
$ sudo docker swarm join --token <secret token> <ip of your master>
```
Now that you have all the nodes connected to the swarm, create a network overlay on your master.

```bash
$ sudo docker network create --attachable --driver overlay --subnet 10.0.1.0/24 hadoop_cluster
```

## Setup DNS server

This container will run Serf and dnsmasqd.

Serf is tool for cluster membership, failure detection, and orchestration.
dnsmasqd is a lightweight, easy to configure, DNS forwarder.

This container will serve to the cluster the functionality of resolve internal dns hostnames and detect when a new slave joins the cluster.

```bash
$ sudo docker build -t dns:latest -f Dockerfile-DNS .
```

Run the container

```bash
$ sudo docker run -d -ti --name dns --add-host master:10.0.1.2 --hostname cluster-dns --ip 10.0.1.254 --network hadoop_cluster -e TZ=Europe/Rome <image id> bash -c "/root/boot_dns.sh"
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
