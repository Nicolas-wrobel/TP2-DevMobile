# 📱 Application "Objets Trouvés"

Cette application permet de visualiser, filtrer et rechercher des objets trouvés, avec la possibilité de consulter les détails de chaque objet, filtrer selon plusieurs critères (gare, catégorie, date, etc.) et afficher uniquement les objets non consultés depuis la dernière utilisation.

## 📝 Fonctionnalités

- **Affichage des objets trouvés :** L'application liste les objets trouvés récemment avec des informations telles que la gare d'origine, la date de l'objet trouvé, et son état de restitution.
- **Recherche par date :** Vous pouvez rechercher les objets trouvés à une date spécifique.
- **Filtres avancés :** Filtrer les objets par gare, catégorie, et statut de restitution.
- **Affichage des derniers objets consultés :** Afficher ou masquer les objets déjà consultés depuis la dernière connexion.
- **Scroll infini :** Chargement automatique de nouveaux objets lors du défilement pour afficher plus d'éléments sans recharger l'application.
- **Mémorisation de la dernière consultation :** Enregistre la date de la dernière consultation de l'utilisateur pour ne pas afficher les mêmes objets consultés.

## 🛠️ Technologies utilisées

- **Flutter** : Cadre de développement multiplateforme pour créer des applications mobiles.
- **Dart** : Langage de programmation utilisé avec Flutter.
- **HTTP** : Gestion des requêtes pour récupérer les objets trouvés depuis une API.
- **Shared Preferences** : Stockage local pour mémoriser la dernière consultation et les objets consultés.

## 📂 Structure du projet

- **lib/**
  - **models/** : Contient les modèles de données pour les objets trouvés.
  - **screens/** : Contient les différentes pages de l'application (`home_screen.dart`, `object_detail_screen.dart`, etc.)
  - **services/** : Gestion des services tels que la connexion API (`api_service.dart`) et le stockage local (`local_storage_service.dart`).

## 📦 API Utilisée

Les données des objets trouvés sont récupérées depuis l'API publique de la SNCF :

- **API SNCF des objets trouvés** : `https://data.sncf.com/api/records/1.0/search/?dataset=objets-trouves-restitution`
