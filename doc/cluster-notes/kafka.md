
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
```shell script
ansible-playbook -i cluster-inventory kafka-cluster.yml -e clear_state=true
docker logs -f cp-zookeeper-0
for ip in '192.168.1.1' '192.168.1.242' '192.168.1.241' ; do mode=$(echo stat | nc -q 1 $ip 2181 | grep "Mode"); echo "$ip => $mode"; done
```
ZooKeeper Commands: The Four Letter Word : https://zookeeper.apache.org/doc/r3.3.3/zookeeperAdmin.html#sc_maintenance

## kafka-broker
config keys: https://docs.confluent.io/current/installation/configuration/broker-configs.html

Check if the broker started:
```shell script
docker logs cp-kafka-broker-1 | grep started
```

Create topic: 
```shell script
docker run --net=host --rm confluentinc/cp-kafka:5.3.1 \
  kafka-topics --create --topic bar --partitions 3 --replication-factor 2 --if-not-exists --zookeeper stressed-panda-1.lab.digitalpanda.org:2181

```

Describe topic: 
```shell script
docker run --net=host --rm confluentinc/cp-kafka:5.3.1 \
  kafka-topics --describe --topic bar --zookeeper stressed-panda-1.lab.digitalpanda.org:2181
```

Produce data from console:
```shell script
docker run --net=host --rm confluentinc/cp-kafka:5.3.1 \
  bash -c "seq 42 | kafka-console-producer --broker-list stressed-panda-1.lab.digitalpanda.org:9092,stressed-panda-2.lab.digitalpanda.org:9092 --topic bar && echo 'Produced 42 messages.'"
```

Consume data from console:
```shell script
#Might take some time when it is the first time that the broker system gets a request from a consumer.
# => The brokers must create the topic __consumers_offset
docker run --net=host --rm confluentinc/cp-kafka:5.3.1 \
  kafka-console-consumer --bootstrap-server stressed-panda-1.lab.digitalpanda.org:9092 --topic bar --from-beginning --max-messages 42
```


# Kafka connect
user-guide: https://docs.confluent.io/current/connect/userguide.html
config keys: https://docs.confluent.io/current/connect/references/allconfigs.html
    0.5 GiB per cassandra sink => 4 => 2 GiB

# Avro schema registry
general https://docs.confluent.io/current/schema-registry/installation/deployment.html
config keys: https://docs.confluent.io/current/schema-registry/installation/config.html
