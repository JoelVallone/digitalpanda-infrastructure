FROM ubuntu:14.04
MAINTAINER Joel Vallone <joel.vallone@gmail.com>

ENV SHARE_FOLDER /usr/share

RUN  \
   apt-get update && \
   apt-get install git

RUN  \
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
  apt-get install -y nodejs && \
  rm -rf /var/lib/apt/lists/*

RUN cd /opt && \
    git clone git@github.com:JoelVallone/digitalpanda-frontend.git && \
    cd /digitalpanda-frontend && \
    npm install

COPY entrypoint.sh /opt/entrypoint.sh

EXPOSE 8081

ENTRYPOINT /opt/entrypoint.sh