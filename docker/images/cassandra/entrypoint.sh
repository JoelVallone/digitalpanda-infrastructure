#!/bin/bash

function log {
    echo "$(date) - $1"
}

function startForegroundCassandra {
    CASSANDRA_CONF=file:///${CASSANDRA_CONF_DIR}
    export CASSANDRA_CONF

    JVM_OPTS="-Dcassandra.logdir=${CASSANDRA_LOG_DIR} -Dlogback.configurationFile=${CASSANDRA_CONF_DIR}/logback.xml"
    export JVM_OPTS
    log "start cassandra"
    ${CASSANDRA_BIN}/bin/cassandra -f -R -p ${CASSANDRA_CONF_DIR}/cassandra.pid &> /dev/nul
}

function stopCassandra {
    kill $(cat ${CASSANDRA_CONF_DIR}/cassandra.pid)
    sleep 5
    log "cassandra stop"
}

#if [ "${CONTAINER_AUTO_START:-false}" = "true" ]; then
    trap stopCassandra SIGTERM
    trap stopCassandra SIGINT
    startForegroundCassandra
    stopCassandra
#else
#    log "cassandra container started"
#    tail -f /dev/null
#fi

log "end of entrypoint.sh"

