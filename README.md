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

## 6°) TP exemple intéraction Nifi et Kafka : 



##############################################################################################
## (Optionnel) Interface Nifi-Registry : http://nifi-registry:18080
##############################################################################################
## Avec un navigateur web : on va sur l'URL mappée : 
http://127.0.0.1:18080/nifi-registry/

## On crée le Bucket "Formation" :
## - Cliquer sur la clé à molette en haut à droite
## - cliquer sur "NEW BUCKET"
## - Dans la fenêtre "New Bucket" qui s'affiche :
##   - Bucket Name : "Formation" 
##   - Description : "Bucket pour les flows du périmètre Formation"
## Puis fermer ( croix en haut à droite)


## On déclare ensuite le schéma registry à utiliser pour Nifi : 
## - Aller sur Nifi avec le navigateur sur l'URL :  https://localhost:8443/nifi/
## - En haut à droite (menu hamburger) : 
##     - Cliquer sur "Controller Settings"
##     - Cliquer sur l'onglet "Registry Clients" 
##        => Puis cliquer sur le "+" à droite
##        Dans la fenêtre "Add Registry Client" qui s'ouvre : 
## 							=>	Name : "Nifi Registry"
##							=>  Type : "NifiRegistryFlowRegistryClient(1.28.1)   (menu déroulant)
##							=>  Description : Nifi Registry Formation
##							=>  Puis cliquer  sur "Add"
##	      - Cliquer sur le crayon en bout de ligne
##        - Sélectionner l'onglet "Properties" 
##        - puis cliquer sur la ligne URL et renseigner le champ avec : http://nifi-registry:18080/nifi-registry/ 
##                                                                      Remarque : la valeur http://127.0.0.1:18080/nifi-registry/ ne fonctionnerait pas
##        - Cliquer sur "Update"
##		  - Fermer la fenêtre (croix en haut à droite)

	


##############################################################################################
## Utilisation de Kafka : 
##############################################################################################
## On vérifie maintenant que Kafka est opérationnel :

## Pour kafka : dans un terminal de commande shell : 
netstat -anl | grep 9092

## Affichage : 
	tcp        0      0 0.0.0.0:29092           0.0.0.0:*               LISTEN     
	tcp        0      0 0.0.0.0:9092            0.0.0.0:*               LISTEN     
	tcp6       0      0 :::29092                :::*                    LISTEN     
	tcp6       0      0 :::9092                 :::*                    LISTEN     


## On va créer un topic et l'alimenter : 
docker exec -it kafka bash 


## Création du topic "test-topic" : 
kafka-topics --create --topic test-topic  --bootstrap-server localhost:9092 

## Affichage en retour : 
	Created topic test-topic.

## On vérifie que le topic est bien créé : 	
kafka-topics --list --bootstrap-server localhost:9092 

## Affichage en retour : 
	test-topic


## Idem on crée le topic de sortie pour plus tard : 
kafka-topics --create --topic test-topic-sortie  --bootstrap-server localhost:9092 
kafka-topics --list --bootstrap-server localhost:9092 


## Saisie de quelques messages pour alimenter le topic "test-topic" :  
## On utilise l'utilitaire "kafka-console-producer" : 
kafka-console-producer --topic test-topic --bootstrap-server localhost:9092

## Saisir ensuite quelques messages : 
Test1
Test2
...
## (Ctrl-C pour quitter)


## On vérifie que le topic est bien alimenté avec nos messages  : 	
kafka-console-consumer --topic test-topic --bootstrap-server localhost:9092 --from-beginning

## Affichage : ( peut nécessiter quelques secondes)
Test1
Test2
...
## (Ctrl-C pour quitter)



##############################################################################################
## Utilisation de Nifi pour créer un flow intéragissant avec Kafka : 
##############################################################################################

## On retourne dans l'interface UI de Nifi pour créer un Flow intéragissant avec le topic Kakfa : 
https://localhost:8443/nifi


## Précision : si on a fait l'étape optionnelle de définition du Nifi Registry dans Nifi, 
## on peut désormais versionner les changmenets approtés aux flow Nifi. 
## Rappel : on versionne un Group Flow (pas un processor seul)



#######################################################################################
## Ecriture/lecture de messages dans un topic Kafka à partir d'un flow Nifi :
#######################################################################################

## Remarque : on peut importer directement l'ensemble du TP 
## via le "Process Group" nommé "TP01_Nifi-Nifi_Registry-Zookeeper-Kafka_dans_docker_compose.json"


#####################################
## 2 Groupes composent cet exemple :  
#####################################

## Le 1er groupe nommé "Generation_Message_dans_Kafka" qui est composé de deux processeurs :

## 1°) un processor "GenerateFlowFile" pour générer ce que l'on va ensuite écrire dans notre topic

		Remarque : 
		
		- Dans l'onglet Properties, le champ "Custom Text" est : 	Test${nextInt()}
		- Dans l'onglet Properties, le champ "Mime Type" est : 		Text
		
		
		
## 2°) un processor "PublishKafka_2_6" sur le canevas de l'UI Nifi : 

## Exemple pour la version Nifi 1.28.x dans notre exemple :


## Paramètrage du processor sur Kafka : (onglet Properties dans la fenêtre "Edit Processor")
## Ici par exemple PublishKafka_2_6_1.28.0

>	Kafka Brokers					kafka:29092
> 	Topic Name						test-topic
> 	Use Transactions				false
	Message Demarcator				No value set
>	Failure Strategy				Route to Failure
>	Delivery Guarantee				Guarantee Single Node Delivery
	Attributes to Send as Headers (Regex)		No value set
	Message Header Encoding			UTF-8
>	Security Protocol				PLAINTEXT
>	SASL Mechanism					PLAIN	
	Kerberos Credentials Service	No value set
	Kerberos User Service			No value set
	Kerberos Service Name			No value set
	Kerberos Principal				No value set
	Kerberos Keytab					No value set
>	Username						admin
>	Password						admin						<<<<< IMPORTANT : à resaisir si vous avez importé le TP à partir du fichier JSON						
	SSL Context Service				No value set
	Kafka Key						No value set	
>	Key Attribute Encoding			UTF-8 Encoded
>	Max Request Size				1 MB
>	Acknowledgment Wait Time		5 secs
>	Max Metadata Wait Time			5 sec
	Partitioner class				DefaultPartitioner
>	Partition						0							<<<< IMPORTANT : on compte à partir de 0 dans Kafka :-) : la première partition est la partition "0"
>	Compression Type				none



## Remarque : dans l'onglet "Relationships" de ce processeur, 
## la case "terminate" de "failure" et "success" sont cochés 
## => pour indiquer que le flow s'arrête au niveau de ce processeur




## Le 2nd groupe nommé "Consommation_Message_dans_Kafka" qui est composé de deux processeurs :

## 1°) un processor "ConsumeKafka_2_6" pour récupérer (lire/consommer) les messages du topic alimenté par le 1er groupe précédent :

## ConsumeKafka_2_6 1.28.0 


>	Kafka Brokers					kafka:29092
>	Topic Name(s)					test-topic
>	Topic Name Format				names
>	Group ID						CGRP1					<<<< Obligatoire
	Commit Offsets					true
	Max Uncommitted Time			1 secs
>	Honor Transactions				false
	Message Demarcator				No value set
	Separate By Key					false
>	Security Protocol				PLAINTEXT
>	SASL Mechanism					PLAIN
	Kerberos Credentials Service	No value set
	Kerberos User Service			No value set
	Kerberos Service Name			No value set
	Kerberos Principal				No value set
	Kerberos Keytab					No value set
>	Username						admin
>	Password						admin					<<<<< IMPORTANT : à resaisir si vous avez importé le TP à partir du fichier JSON	
	SSL Context Service				No value set
>	Key Attribute Encoding			UTF-8 Encoded
>	Offset Reset					latest
	Message Header Encoding			UTF-8
	Headers to Add as Attributes (Regex)		No value set
	Max Poll Records				10000
>	Communications Timeout			60 secs



## 2°) un processor "PublishKafka_2_6" pour réécrire les messages dans le topic de sortie test-topic-sortie :

#### Paramètrage du processor sur Kafka : (onglet Properties dans la fenêtre "Edit Processor")
#### Ici par exemple PublishKafka_2_6_1.28.0

>	Kafka Brokers					kafka:29092
> 	Topic Name						test-topic-sortie
> 	Use Transactions				false
	Message Demarcator				No value set
>	Failure Strategy				Route to Failure
>	Delivery Guarantee				Guarantee Single Node Delivery
	Attributes to Send as Headers (Regex)		No value set
	Message Header Encoding			UTF-8
>	Security Protocol				PLAINTEXT
>	SASL Mechanism					PLAIN	
	Kerberos Credentials Service	No value set
	Kerberos User Service			No value set
	Kerberos Service Name			No value set
	Kerberos Principal				No value set
	Kerberos Keytab					No value set
>	Username						admin
>	Password						admin						<<<<< IMPORTANT : à resaisir si vous avez importé le TP à partir du fichier JSON						
	SSL Context Service				No value set
	Kafka Key						No value set	
>	Key Attribute Encoding			UTF-8 Encoded
>	Max Request Size				1 MB
>	Acknowledgment Wait Time		5 secs
>	Max Metadata Wait Time			5 sec
	Partitioner class				DefaultPartitioner
>	Partition						0							<<<< IMPORTANT : on compte à partir de 0 dans Kafka :-) : la première partition est la partition "0"
>	Compression Type				none




#### On démarre les deux Flows

#### On lit les messages de test-topic en entrée, puis on réécrit en sortie ces messages dans le topic test-topic-sortie

#### On vérifie maintenant que le topic est bien alimenté avec nos messages  : 	
#### On retourne dans le conteneur kafka  : 
docker exec -it kafka bash 

#### Et on affiche les messages du topic de sortie alimenté par notre stream Nifi :
kafka-console-consumer --topic test-topic-sortie --bootstrap-server localhost:9092 --from-beginning --property print.key=true

#### CTRL-C pour sortir

#### Penser à sortir du conteneur également : 
exit 


## 7°) Pour arrêter le cluster :

#### Remarque  : pour seulement arrêter notre environnement si besoin :
```sh
docker compose -f TP01_Nifi-Nifi_Registry-Zookeeper-Kafka_dans_docker_compose.yml stop
```
#### Remarque  : pour arrêter et supprimer totalement notre environnement si besoin :
```sh
docker compose -f TP01_Nifi-Nifi_Registry-Zookeeper-Kafka_dans_docker_compose.yml down -v
```


# Have fun !
