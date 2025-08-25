# Base de données Your Car Your Way

## Structure de la base de données MySQL

Ce script initialise la base de données complète pour l'application Your Car Your Way.

### Tables principales :
- `users` - Gestion des utilisateurs et authentification
- `user_profiles` - Profils détaillés des clients
- `agencies` - Agences de location
- `vehicle_categories` - Catégories de véhicules (norme ACRISS)
- `vehicles` - Véhicules disponibles à la location
- `reservations` - Réservations et locations
- `payments` - Transactions de paiement
- `chat_messages` - Messages du service client (pour le PoC)
- `chat_conversations` - Conversations de support

### Installation :

1. **MySQL requis** : Version 8.0 ou supérieure
2. **Exécuter le script** :
```bash
mysql -u root -p < init.sql