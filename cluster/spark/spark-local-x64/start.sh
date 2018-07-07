#!/bin/bash
#set -e

SCRIPT_FOLDER="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
DOCKER_IMAGES=$SCRIPT_FOLDER/../../../docker/images
SPARK_VERSION=spark-2.3.0
SPARK_NAME=$SPARK_VERSION-bin-hadoop2.7

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
    sudo rm -rf $SCRIPT_FOLDER/data-mount/hdfs/master/data \
     $SCRIPT_FOLDER/data-mount/hdfs/slave/data \
     $SCRIPT_FOLDER/data-mount/yarn/slave/data \
     $SCRIPT_FOLDER/data-mount/log
}

function createDataDirs {
    mkdir -p $SCRIPT_FOLDER/data-mount/hdfs/master/data
    mkdir -p $SCRIPT_FOLDER/data-mount/hdfs/slave/data
    mkdir -p $SCRIPT_FOLDER/data-mount/log
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

echo "STARTING HADOOP LOCALLY"
cleanup
clearDataDirs || true
createDataDirs

msg "Build docker images"
sudo docker build -t hadoop:latest ${DOCKER_IMAGES}/hadoop

msg "Start docker images"

HDFS_MASTER_DOCKER_ID=$(sudo docker run \
    --name=hadoop-hdfs-master \
    -v $SCRIPT_FOLDER/data-mount/:/opt/hadoop/ext \
    --net=host \
    -d -t hadoop:latest)

HDFS_SLAVE_DOCKER_ID=$(sudo docker run \
    --name=hadoop-hdfs-slave \
    -v $SCRIPT_FOLDER/data-mount/:/opt/hadoop/ext \
    --net=host \
    -d -t hadoop:latest)

YARN_MASTER_DOCKER_ID=$(sudo docker run \
    --name=hadoop-yarn-master \
    -v $SCRIPT_FOLDER/data-mount/:/opt/hadoop/ext \
    --net=host \
    -d -t hadoop:latest)

YARN_SLAVE_DOCKER_ID=$(sudo docker run \
    --name=hadoop-yarn-slave \
    -v $SCRIPT_FOLDER/data-mount/:/opt/hadoop/ext \
    --net=host \
    -d -t hadoop:latest)


msg "Start Hadoop cluster"
echo -e "\n\n==> START HDFS"
sudo docker exec hadoop-hdfs-master bash -c '"$HADOOP_PREFIX"/bin/hdfs namenode -format hadoop-hdfs' 
sudo docker exec hadoop-hdfs-master bash -c '"$HADOOP_PREFIX"/sbin/hadoop-daemon.sh start namenode' 
sudo docker exec hadoop-hdfs-slave bash -c '"$HADOOP_PREFIX"/sbin/hadoop-daemon.sh  start datanode'
echo -e "\n\n==> START YARN"
sudo docker exec hadoop-yarn-master bash -c '"$HADOOP_PREFIX"/sbin/yarn-daemon.sh  start resourcemanager'
sudo docker exec hadoop-yarn-slave bash -c '"$HADOOP_PREFIX"/sbin/yarn-daemon.sh  start nodemanager'

if [ ! -d ${SPARK_NAME} ]; then
    msg "DOWNLOAD SPARK : ${SPARK_NAME}"
    wget http://mirror.switch.ch/mirror/apache/dist/spark/${SPARK_VERSION}/${SPARK_NAME}.tgz
    tar -zxf ${SPARK_NAME}.tgz
    rm ${SPARK_NAME}.tgz
fi

msg "EXPORT ENVIRONMENT VARIABLES"
export HADOOP_CONF_DIR=$DOCKER_IMAGES/hadoop/default-config/
export YARN_CONF_DIR=$DOCKER_IMAGES/hadoop/default-config/

echo -e "\n\n"
msg "STARTED HADOOP LOCALLY: "
sudo docker ps
echo "=============================================="
echo " -> hdfs namenode page: http://127.0.0.1:50070"
echo " -> yarn resourcemanager page: http://127.0.0.1:8088"
echo " -> spark UI when task running: http://192.168.0.38:4040"
echo " -> spark cluster-mode command example: "
echo "./${SPARK_NAME}/bin/spark-submit --class org.apache.spark.examples.SparkPi \
    --master yarn \
    --deploy-mode client \
    --driver-memory 512m \
    --executor-memory 512m \
    --executor-cores 1 \
    --queue default \
    ./${SPARK_NAME}/examples/jars/spark-examples*.jar 20000"


# export HADOOP_CONF_DIR=/home/panda-config/hadoop/config/
# one-liner: "./spark-2.3.0-bin-hadoop2.7/bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode client --driver-memory 512m  --executor-memory 2048m --executor-cores 3 --queue default  ./spark-2.3.0-bin-hadoop2.7/examples/jars/spark-examples*.jar 20000"

