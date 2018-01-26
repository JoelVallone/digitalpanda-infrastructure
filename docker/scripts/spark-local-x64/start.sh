#!/bin/bash
set -e

SCRIPT_FOLDER="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
DOCKER_IMAGES=$SCRIPT_FOLDER/../../images

function cleanup {
msg "Stop and remove all containers"
if [ -n "$(sudo docker ps -q)" ]; then
    sudo docker stop $(sudo docker ps -q)
    sudo docker rm $(sudo docker ps -q -a)
fi
}

function msg {
txt=\
"=========================================================\n
 > $1 \n
========================================================="
echo -e "" $txt
}

trap echo -e "failure trap: \n" && cleanup EXIT

echo "STARTING SPARK LOCALLY"
cleanup

msg "Build docker images"
sudo docker build -t hadoop-hdfs:latest ${DOCKER_IMAGES}/hadoop-hdfs

msg "Start docker images"



HDFS_MASTER_DOCKER_ID=$(sudo docker run \
    --name=hadoop-hdfs-master \
    --net=host \
    -d -t hadoop-hdfs:latest)

HDFS_SLAVE_DOCKER_ID=$(sudo docker run \
    --name=hadoop-hdfs-slave \
    --net=host \
    -d -t hadoop-hdfs:latest)

msg "Start Spark cluster"
sudo docker exec hadoop-hdfs-master bash -c '"$HADOOP_PREFIX"/bin/hdfs namenode -format hadoop-hdfs' 
sudo docker exec hadoop-hdfs-master bash -c '"$HADOOP_PREFIX"/sbin/hadoop-daemon.sh --config $HADOOP_BASE/config start namenode' 
sudo docker exec hadoop-hdfs-slave bash -c '"$HADOOP_PREFIX"/sbin/hadoop-daemon.sh  --config $HADOOP_BASE/config start datanode'
sudo docker ps

echo "STARTED SPARK LOCALLY: "
echo " -> hdfs namenode page: http://127.0.0.1:50070"

firefox http://127.0.0.1:50070

