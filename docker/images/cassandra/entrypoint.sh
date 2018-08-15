#!/bin/bash

function startCassandra {
    CASSANDRA_CONF=file:///${CASSANDRA_CONF_DIR}
    export CASSANDRA_CONF

    JVM_OPTS="-Dcassandra.logdir=${CASSANDRA_LOG_DIR} -Dlogback.configurationFile=${CASSANDRA_CONF_DIR}/logback.xml"
    export JVM_OPTS

    ${CASSANDRA_BIN}/bin/cassandra -R -p ${CASSANDRA_CONF_DIR}/cassandra.pid &> /dev/null
    chmod a+r ${CASSANDRA_CONF_DIR}/cassandra.pid
}

function stopCassandra {
    kill $(cat ${CASSANDRA_CONF_DIR}/cassandra.pid)
    sleep 5
    echo "cassandra stopped"
}

if [ "${CONTAINER_AUTO_START:-false}" = "true" ]; then
    trap stopCassandra SIGTERM
    trap stopCassandra SIGINT
    startCassandra
    echo "cassandra started - press enter to stop"
    read val
    stopCassandra
else
    echo "container started - press enter to stop"
    read val
fi


