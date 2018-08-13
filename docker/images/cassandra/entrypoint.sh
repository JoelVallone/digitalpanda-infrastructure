#!/bin/bash

function startCassandra {
    CASSANDRA_CONF=file:///${CASSANDRA_CONF_DIR}
    export CASSANDRA_CONF

    JVM_OPTS="-Dcassandra.logdir=${CASSANDRA_LOG_DIR} -Dlogback.configurationFile=${CASSANDRA_CONF_DIR}/logback.xml"
    export JVM_OPTS

    ${CASSANDRA_BIN}/bin/cassandra -R -p ${CASSANDRA_CONF_DIR}/cassandra.pid &> /dev/null
}

function stopCassandra {
    kill $(${CASSANDRA_CONF_DIR}/cassandra.pid)
    sleep 5
}

if [ "${CONTAINER_AUTO_START:-false}" = "true" ]; then
    startCassandra
    echo "cassandra started - press enter to stop"
    read val
    stopCassandra
    echo "cassandra stopped"
else
    echo "container started - press enter to stop"
    read val
fi


