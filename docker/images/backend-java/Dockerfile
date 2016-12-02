FROM ubuntu:14.04
MAINTAINER Joel Vallone <joel.vallone@gmail.com>

ENV SHARE_FOLDER /usr/share
ENV JAVA_HEAP_SIZE 512

RUN apt-get update && \
    apt-get install -y software-properties-common

RUN add-apt-repository ppa:openjdk-r/ppa && \
 apt-get update && \
 apt-get install -y openjdk-8-jdk && \
 rm -rf /var/lib/apt/lists/*

COPY *backend*.jar /opt/backend.jar
COPY entrypoint.sh /opt/entrypoint.sh

EXPOSE 8080

ENTRYPOINT /opt/entrypoint.sh