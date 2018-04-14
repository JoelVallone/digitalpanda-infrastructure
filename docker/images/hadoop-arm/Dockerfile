FROM hypriot/rpi-java 
MAINTAINER Joel Vallone <joel.vallone@gmail.com>

ENV JAVA_HEAP_SIZE 2048
ENV HADOOP_BASE  /opt/hadoop
ENV HADOOP_PREFIX ${HADOOP_BASE}/hadoop-2.9.0
ENV HADOOP_CONF_DIR ${HADOOP_BASE}/ext/config 
ENV HADOOP_LOG_DIR ${HADOOP_BASE}/ext/log

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Install hadoop 2.9
RUN mkdir -p ${HADOOP_BASE} && \
    cd ${HADOOP_BASE} && \
    wget http://mirror.switch.ch/mirror/apache/dist/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz && \
    tar -zxf hadoop-2.9.0.tar.gz && \
    rm hadoop-2.9.0.tar.gz;

# Setup hadoop directories
WORKDIR ${HADOOP_BASE}
RUN mkdir -p $HADOOP_BASE/ext/hdfs/master/data && \
    mkdir -p $HADOOP_BASE/ext/hdfs/slave/data && \
    mkdir -p $HADOOP_CONF_DIR && \
    mkdir -p $HADOOP_LOG_DIR

# Load default settings
COPY entrypoint.sh /opt/entrypoint.sh
COPY default-config ${HADOOP_CONF_DIR}

ENTRYPOINT /opt/entrypoint.sh
