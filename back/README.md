# YourCarYourWay POC - Backend

Ce projet est l'application backend de la preuve de concept pour le Chat - Service Client de **YourCarYourWay**.

## Prérequis

- Java 17+
- [Spring Boot](https://spring.io/projects/spring-boot)

## Installation & Lancement

Aucune base de données n'est requise pour ce PoC.

Pour lancer le serveur :

cd yourcaryourway_poc/back

```bash
./mvnw spring-boot:run
```
ou avec Gradle :
```bash
./gradlew bootRun
```

Le backend démarre sur le port `8080` et expose un endpoint WebSocket.

## Structure du projet

- `src/` : code source principal
- `controller/` : logique métier
- `entity/` : modèles de données
- `config/` : configuration WebSocket

## Contribution

Les contributions sont les bienvenues ! Veuillez ouvrir une issue ou une pull request.

## Licence

Ce projet est sous licence MIT.
