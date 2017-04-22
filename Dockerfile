FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Java

ENV JAVA_HOME		/usr/lib/jvm/java-8-oracle
ENV PATH		$PATH:$JAVA_HOME/bin

RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common net-tools iputils-ping less telnet

RUN apt-get install -y openssh-server serf sshpass supervisor vim
RUN mkdir -p /var/run/sshd /var/log/supervisor

RUN \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

RUN echo '' >> /etc/profile \
     && echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile \
     && echo 'export PATH="$PATH:$JAVA_HOME/bin"' >> /etc/profile \
     && echo '' >> /etc/profile

# Passwordless

RUN echo 'root:root' | chpasswd

RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ADD conf/ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

COPY conf/sshd_config /etc/ssh/sshd_config

COPY keys/id_rsa.pub /root/.ssh/authorized_keys

COPY keys/id_rsa /root/.ssh
COPY keys/id_rsa.pub /root/.ssh

# Hadoop

ENV APACHE_MIRROR	www-eu.apache.org

ENV HADOOP_VERSION	2.8.0
ENV HADOOP_HOME		/usr/local/hadoop
ENV HADOOP_OPTS		-Djava.library.path=/usr/local/hadoop/lib/native
ENV PATH		$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN apt-get update && \
    apt-get install -y wget libzip4 libsnappy1v5 libssl-dev && \
    wget http://$APACHE_MIRROR/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -zxf /hadoop-$HADOOP_VERSION.tar.gz && \
    rm /hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION /usr/local/hadoop && \
    mkdir -p /usr/local/hadoop/logs

# Overwrite default HADOOP configuration files with our config files

COPY conf-hadoop $HADOOP_HOME/etc/hadoop/
RUN mkdir -p /root/conf-hadoop-master
COPY conf-hadoop-master /root/conf-hadoop-master/

COPY conf/masters /root/
COPY conf/slaves /root/

# Formatting HDFS

RUN mkdir -p /data/dfs/data /data/dfs/name /data/dfs/namesecondary && \
    hdfs namenode -format

VOLUME /data

# Supervisor

COPY conf/supervisord-master.conf /etc/supervisor/supervisord-master.conf
COPY conf/supervisord-slave.conf /etc/supervisor/supervisord-slave.conf

# Master

COPY boot_master.sh /root/
RUN chmod +x /root/boot_master.sh

####################
# PORTS
####################
#
# http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.0/bk_HDP_Reference_Guide/content/reference_chap2.html
# http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cdh_ig_ports_cdh5.html
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/core-default.xml
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

# HDFS: NameNode (NN):
#	 8020 = fs.defaultFS			(IPC / File system metadata operations)
#						(9000 is also frequently used alternatively)
#	 8022 = dfs.namenode.servicerpc-address	(optional port used by HDFS daemons to avoid sharing RPC port)
#       50070 = dfs.namenode.http-address	(HTTP  / NN Web UI)
#	50470 = dfs.namenode.https-address	(HTTPS / Secure UI)
# HDFS: DataNode (DN):
#	50010 = dfs.datanode.address		(Data transfer)
#	50020 = dfs.datanode.ipc.address	(IPC / metadata operations)
#	50075 = dfs.datanode.http.address	(HTTP  / DN Web UI)
#	50475 = dfs.datanode.https.address	(HTTPS / Secure UI)
# HDFS: Secondary NameNode (SNN)
#	50090 = dfs.secondary.http.address	(HTTP / Checkpoint for NameNode metadata)
#EXPOSE 9000 50070 50010 50020 50075 50090

EXPOSE 50020 50090 50070 50010 50075 9000 8025 8031 8032 8035 8033 8040 8042 8050 49707 22 2120 8088 8030
