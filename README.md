# YourCarYourWay – Proof of Concept

Ce repository contient le PoC du service client chat pour **YourCarYourWay**, incluant le backend, le frontend et la base de données.

---

## Table des matières

- [Présentation](#présentation)
- [Structure du repository](#structure-du-repository)
- [Installation rapide](#installation-rapide)
- [Backend](#backend)
- [Frontend](#frontend)
- [Base de données](#base-de-données)
- [Contribution](#contribution)
- [Licence](#licence)

---

## Présentation

Ce projet démontre un système de chat pour le service client, avec une architecture complète : backend Java/Spring Boot, frontend Angular, et base de données MySQL.

---

## Structure du repository

- `back/` : Application backend (Spring Boot)
- `front/` : Application frontend (Angular)
- `database/` : Scripts d’initialisation MySQL

---

## Installation rapide

1. **Cloner le repository :**
    ```bash
    git clone <repo-url>
    cd yourcaryourway_poc
    ```

2. **Configurer la base de données :**
    - MySQL 8.0+ requis
    - Exécuter le script :
      ```bash
      mysql -u root -p < database/init.sql
      ```

3. **Lancer le backend :**
    ```bash
    cd back
    ./mvnw spring-boot:run
    # ou
    ./gradlew bootRun
    ```

4. **Lancer le frontend :**
    ```bash
    cd ../front
    npm install
    npm start
    # ou
    yarn install && yarn start
    ```

---

## Backend

- **Techno :** Java 17+, Spring Boot
- **Port :** 8080
- **Fonctionnalités :** API REST & WebSocket pour le chat
- **Structure :**
  - `src/` : code source
  - `controller/` : logique métier
  - `entity/` : modèles de données
  - `config/` : configuration WebSocket

---

## Frontend

- **Techno :** Angular, Node.js >= 16.x
- **Fonctionnalités :**
  - Interface utilisateur du chat
  - Intégration avec l’API backend
- **Scripts utiles :**
  - `start` : serveur de dev
  - `build` : build production
  - `test` : tests unitaires

---

## Base de données

- **Type :** MySQL 8.0+
- **Tables principales :**
  - `users`, `user_profiles`, `agencies`, `vehicle_categories`, `vehicles`, `reservations`, `payments`, `chat_messages`, `chat_conversations`
- **Installation :**
  ```bash
  mysql -u root -p < database/init.sql
  ```

---

## Contribution

Les contributions sont les bienvenues !

1. Forkez le repo
2. Créez une branche (`git checkout -b feature/ma-feature`)
3. Commitez vos modifications
4. Poussez la branche
5. Ouvrez une Pull Request

---

## Licence

Ce projet est sous licence MIT.