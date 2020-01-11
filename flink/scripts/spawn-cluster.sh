#!/bin/bash

set -e

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
SCRIPT_FOLDER="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
ROOT_FOLDER="${SCRIPT_FOLDER}/.."

HADOOP_VERSION=2.8.3
FLINK_VERSION=1.9.1
SCALA_VERSION=2.11

FLINK_ARCHIVE=flink-${FLINK_VERSION}-bin-scala_${SCALA_VERSION}.tgz
FLINK_FOLDER=flink-${FLINK_VERSION}
if [ ! -d "${ROOT_FOLDER}/${FLINK_FOLDER}" ]; then
    echo "DOWNLOAD FLINK : ${HADOOP_NAME}"
    cd ${ROOT_FOLDER}
    wget https://www-eu.apache.org/dist/flink/${FLINK_FOLDER}/${FLINK_ARCHIVE}
    tar -zxf ${FLINK_ARCHIVE}
    rm ${FLINK_ARCHIVE}
    cd ${FLINK_FOLDER}
fi

HADOOP_FLINK_BUNDLE_JAR=flink-shaded-hadoop-2-uber-${HADOOP_VERSION}-7.0.jar
FLINK_LIB_FOLDER="${ROOT_FOLDER}/${FLINK_FOLDER}/lib"
if [ ! -f "${FLINK_LIB_FOLDER}/${HADOOP_FLINK_BUNDLE_JAR}" ]; then
    echo "DOWNLOAD HADOOP BUNDLE FOR FLINK : ${HADOOP_NAME}"
    cd ${FLINK_LIB_FOLDER}
    wget https://repo.maven.apache.org/maven2/org/apache/flink/flink-shaded-hadoop-2-uber/${HADOOP_VERSION}-7.0/${HADOOP_FLINK_BUNDLE_JAR}
fi

cd "${ROOT_FOLDER}/${FLINK_FOLDER}"
export YARN_CONF_DIR="${ROOT_FOLDER}/../hadoop/config/client-config"
export HADOOP_CONF_DIR="${ROOT_FOLDER}/../hadoop/config/client-config"
./bin/yarn-session.sh -t 2 -s 2 -st -jm 1024m -tm 3072


exit 0;
echo "SPAWN FLINK CLUSTER"

exit 0;
echo "SUBMIT FLINK JOB"
${HADOOP_FOLDER}/bin/hadoop  \
    --config $HADOOP_CLIENT_CONFIG_FOLDER \
    jar ${HADOOP_FOLDER}/share/hadoop/mapreduce/hadoop-mapreduce-examples-${HADOOP_VERSION}.jar pi 16 1000


