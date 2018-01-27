#!/bin/bash
#set -e

SCRIPT_FOLDER="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
DOCKER_IMAGES=$SCRIPT_FOLDER/../../images

function cleanup {
msg "Stop and remove all containers"
if [ -n "$(sudo docker ps -q)" ]; then
    sudo docker stop $(sudo docker ps -q)
    sudo docker rm $(sudo docker ps -q -a)
fi
}

function cleanupTrap {
    echo "/!\\ CLEANUP DUE TO FAILURE /!\\"
    cleanup
}

function clearDataDirs {
    rm -rf $SCRIPT_FOLDER/data-mount/hdfs/master/data
    rm -rf $SCRIPT_FOLDER/data-mount/hdfs/slave/data
    rm -rf $SCRIPT_FOLDER/data-mount/logs
}

function createDataDirs {
    mkdir -p $SCRIPT_FOLDER/data-mount/hdfs/master/data
    mkdir -p $SCRIPT_FOLDER/data-mount/hdfs/slave/data
    mkdir -p $SCRIPT_FOLDER/data-mount/logs
}

function msg {
txt=\
"=========================================================\n
 > $1 \n
========================================================="
echo -e "" $txt
}

#trap cleanup EXIT
trap cleanup SIGQUIT

echo "STARTING SPARK LOCALLY"
cleanup
clearDataDirs || true
createDataDirs

msg "Build docker images"
sudo docker build -t hadoop-hdfs:latest ${DOCKER_IMAGES}/hadoop

msg "Start docker images"

HDFS_MASTER_DOCKER_ID=$(sudo docker run \
    --name=hadoop-hdfs-master \
    -v $SCRIPT_FOLDER/data-mount/:/opt/hadoop/ext \
    --net=host \
    -d -t hadoop-hdfs:latest)

HDFS_SLAVE_DOCKER_ID=$(sudo docker run \
    --name=hadoop-hdfs-slave \
    -v $SCRIPT_FOLDER/data-mount/:/opt/hadoop/ext \
    --net=host \
    -d -t hadoop-hdfs:latest)

msg "Start Spark cluster"
sudo docker exec hadoop-hdfs-master bash -c '"$HADOOP_PREFIX"/bin/hdfs namenode -format hadoop-hdfs' 
sudo docker exec hadoop-hdfs-master bash -c '"$HADOOP_PREFIX"/sbin/hadoop-daemon.sh start namenode' 
sudo docker exec hadoop-hdfs-slave bash -c '"$HADOOP_PREFIX"/sbin/hadoop-daemon.sh  start datanode'

echo -e "\n\n"
msg "STARTED SPARK LOCALLY: "
sudo docker ps
echo "=============================================="
echo " -> hdfs namenode page: http://127.0.0.1:50070"

firefox http://127.0.0.1:50070 || true

