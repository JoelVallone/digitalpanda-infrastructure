
# Confluent full platform:
https://docs.confluent.io/current/installation/installing_cp/index.html#installation
docker install: 
 - https://docs.confluent.io/current/installation/docker/installation/index.html#cp-docker-install
 - quick-start: https://docs.confluent.io/current/quickstart/ce-docker-quickstart.html
 - three node deployment (see test procedure): https://docs.confluent.io/3.3.0/installation/docker/docs/tutorials/clustered-deployment.html
 - docker install: https://docs.confluent.io/current/installation/docker/index.html
 - config reference: https://docs.confluent.io/current/installation/docker/config-reference.html
# Kafka message broker & zookeeper
k8s quick deploy: https://github.com/PharosProduction/tutorial-apache-kafka-cluster
state with docker: https://docs.confluent.io/current/installation/docker/operations/external-volumes.html#external-volumes
docker with confluent docker images:  https://medium.com/@robcowart/deploying-confluent-platform-kafka-oss-using-docker-39b65fa6809b

## zookeeper
image: https://github.com/confluentinc/cp-docker-images/tree/5.3.1-post/debian/zookeeper
### Deployment and quick check
multi node: https://docs.confluent.io/current/zookeeper/deployment.html#multi-node-setup
```
ansible-playbook -i cluster-inventory kafka-cluster.yml -e clear_state=true
docker logs -f cp-zookeeper-0
for ip in '192.168.1.242' '192.168.1.241' '192.168.1.1'; do mode=$(echo stat | nc $ip 2181 | grep "Mode"); echo "$ip => $mode"; dones
```
ZooKeeper Commands: The Four Letter Word : https://zookeeper.apache.org/doc/r3.3.3/zookeeperAdmin.html#sc_maintenance


# Kafka connect
user-guide: https://docs.confluent.io/current/connect/userguide.html
config keys: https://docs.confluent.io/current/connect/references/allconfigs.html
    0.5 GiB per cassandra sink => 4 => 2 GiB

# Avro schema registry
general https://docs.confluent.io/current/schema-registry/installation/deployment.html
config keys: https://docs.confluent.io/current/schema-registry/installation/config.html
