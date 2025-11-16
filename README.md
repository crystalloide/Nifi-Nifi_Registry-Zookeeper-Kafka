# Environnement démonstration Nifi NifiRegistry Zookeeper Kafka avec docker compose :

Notre démonstration donne accès à Nifi 1.28.1, Nifi Registry 1.28.1, Zookeeper et Kafka (Confluent Platform 7.9.2)


### 0°) Réupération du projet en local : 

  Sur une VM ou machine sans installation préalable, on aura installé Docker / Docker Compose : 
  
  Si besoin, instructions d’installation ici : https://docs.docker.com/compose/install


```sh
cd ~
rm -Rf Big-Data-Cluster
git clone https://github.com/crystalloide/Nifi-Nifi_Registry-Zookeeper-Kafka/
cd Nifi-Nifi_Registry-Zookeeper-Kafka
```

### 1°)	Lancement du cluster :

```sh

docker compose -f TP01_Nifi-Nifi_Registry-Zookeeper-Kafka_dans_docker_compose.yml up -d
docker ps -a
```



## 3°) Pour arrêter le cluster :

```sh
docker compose -f TP01_Nifi-Nifi_Registry-Zookeeper-Kafka_dans_docker_compose.yml down -v
```


# Have fun !
