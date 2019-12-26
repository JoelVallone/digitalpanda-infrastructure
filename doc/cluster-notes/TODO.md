# New

- setup kafka-connect with cassandra connector
    - setup cassandra tables
    - setup kafka connectors
    - test cassandra sink from avro topic
- write flink jobs
 - metric averages: 1m/1h/6h
 - measure inventory
 - setup jar submit mechanism
- rewrite pi iot client to write raw measure to kafka topic
- rewrite backend code to handle metric averages


- Optional: Tune YARN & HDFS
    - Optional: custom always-on YARN queue for flink
    - Optional: tune jvm memory allocation for HDFS & YARN
- Optional: setup new-cassandra to multi-node mode
    - transfer metrics from old cassandra to kafka topic
    - sink raw metrics to new-cassandra table
- Optional: run containers as panda-worker user (fix nuc disk access rights binding)
- Optional: setup docker containers network in bridge mode with manual hosts file "etc_hosts"
- Optional: setup network routing to reach stressed pandas via fanless1

# Old
- update pi3-1 to new hypriot OS version OR troubleshoot docker registry
- fix datanode display httpAddress to host ip instead of localhost in namenode ui
- fix ressource and node managers logging => not to default location container-unreachable
- enhance hadoop-common parametrization
- fix dns reverse lookup + enable dfs.namenode.datanode.registration.ip-hostname-check
