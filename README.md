## Environnement démonstration Nifi Nifi-Registry Zookeeper Kafka avec docker compose :

Notre démonstration donne accès à Nifi 1.28.1, Nifi Registry 1.28.1, Zookeeper et Kafka (Confluent Platform 7.9.2)

### 1°) Remarque :   Pensez aux dispositifs éventuels actifs (UFW, APPARMOR SELINUX etc)

Paramétrer ou désactiver les dispositifs si besoin : exemple pour un Ubuntu : sur un environnement de test : 

```sh
sudo systemctl status ufw
sudo systemctl disable ufw
sudo systemctl status apparmor
sudo systemctl disable apparmor
```

### 2°) Réupération du projet en local : 

  Sur une VM ou machine sans installation préalable, on aura installé Docker / Docker Compose : 
  
  Si besoin, instructions d’installation ici : https://docs.docker.com/compose/install

```sh
cd ~
rm -Rf Big-Data-Cluster
git clone https://github.com/crystalloide/Nifi-Nifi_Registry-Zookeeper-Kafka/
cd Nifi-Nifi_Registry-Zookeeper-Kafka
ls
cat TP01_Nifi-Nifi_Registry-Zookeeper-Kafka_dans_docker_compose.yml
```


## 3°) Explications : 

```md
Ce fichier docker-compose.yml configure un conteneur NiFi avec les éléments suivants :
- image officielle Apache NiFi 1.28.1
- le port HTTPS 8443 du conteneur est mappé au port 8443 de l'hôte,
  ce qui permettra d'accéder à NiFi via https://localhost:8443/nifi
- Des variables d'environnement sont définies pour configurer le port HTTPS
  et créer un utilisateur unique pour l'authentification.
- Des volumes sont montés pour persister les données et la configuration de NiFi.
- Le conteneur est configuré pour redémarrer automatiquement en cas d'arrêt inattendu.

- NIFI_SECURITY_USER_AUTHORIZER=single-user-authorizer permet d'activer l'autorisation à utilisateur unique
- NIFI_SECURITY_USER_LOGIN_IDENTITY_PROVIDER=single-user-provider permet de configurer le fournisseur d'identité sur "utilisateur unique"

Ces ajouts, combinés avec les variables SINGLE_USER_CREDENTIALS_USERNAME et SINGLE_USER_CREDENTIALS_PASSWORD, 
permettent de configurer l'authentification à utilisateur unique.

- NIFI_WEB_HTTPS_HOST=0.0.0.0
- NIFI_WEB_HTTPS_PORT=8443

La variable NIFI_WEB_HTTPS_HOST=0.0.0.0 permet à NiFi d'écouter sur toutes les interfaces réseau du conteneur.
La variable NIFI_WEB_HTTPS_PORT=8443 spécifie le port HTTPS sur lequel NiFi écoutera.

```

### 4°)	Lancement du cluster :

```sh

docker compose -f TP01_Nifi-Nifi_Registry-Zookeeper-Kafka_dans_docker_compose.yml up -d
docker ps -a
```

## 5°) Accès à l'UI Nifi : 

```md

Dans notre exemple, les valeurs de login/mdp sont déjà fixées dans le fichier docker-compose.yml : 

      - SINGLE_USER_CREDENTIALS_USERNAME=nifi
      - SINGLE_USER_CREDENTIALS_PASSWORD=nifipassword

On vérifie simplement que l'on peut désormais accéder à l'interface web de NiFi 
en ouvrant un navigateur sur l'URL https://localhost:8443/nifi 
Note : il faudra accepter l'alerte de sécurité et passer outre 
C'est dû au certificat auto-signé généré par NiFi lors de la première connexion.
```


## 7°) Pour arrêter le cluster :

```sh
docker compose -f TP01_Nifi-Nifi_Registry-Zookeeper-Kafka_dans_docker_compose.yml down -v
```


# Have fun !
