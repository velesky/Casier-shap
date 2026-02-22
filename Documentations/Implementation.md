# Implementation Plan for Casier Chap

**Version :** 1.0 (Frontend First)  
**Date :** 20 février 2026  
**Projet :** App mobile Flutter 100% offline pour gérants de maquis en Côte d’Ivoire

## Feature Analysis

### Identified Features

- Splash Screen avec logo
- Dashboard (valeur stock + badges + état produits)
- Mes Produits (liste + recherche + édition)
- Déclarer Ventes du Jour (presets +1/+5/+10/+24 + total live)
- Résumé de la Journée (caisse + marge + bouton WhatsApp)
- Historique des 7 derniers jours
- Gestion du stock avec badges (BON ÉTAT / MOYEN / CRITIQUE)
- Persistance locale complète
- Partage WhatsApp en un tap

### Feature Categorization

- **Must-Have (MVP) :**
  - Splash Screen
  - Dashboard
  - Mes Produits
  - Déclarer Ventes du Jour
  - Résumé de la Journée
  - Stock management + badges
  - Persistance Hive
  - Bouton WhatsApp
  - FAB central orange
- **Should-Have :**
  - Historique 7 jours
  - Confirmation avant validation journée
  - Recherche dans Mes Produits
  - Calcul automatique marge
- **Nice-to-Have :**
  - Widget Android
  - Mode Super Simple
  - Suggestion réapprovisionnement
  - Thème clair (optionnel)

## Recommended Tech Stack

- **Framework :** Flutter 3.24+ (Frontend mobile first)
- **State Management :** Riverpod
- **Local Storage :** Hive (100% offline)
- **Visual Design Tool :** Stitch (obligatoire pour tout visuel : logo, écrans, cartes, boutons, photos produits)
- **Sharing :** `share_plus` (WhatsApp)
- **Fonts :** `google_fonts` (Inter)
- **Design :** Material 3 + glassmorphism custom

**Backend :** Aucun pour le MVP (tout en local Hive). Backend sera ajouté plus tard si besoin.

## Implementation Stages (Frontend First)

### Stage 1: Foundation & Setup

**Durée estimée :** 4-6 heures  
**Dépendances :** Aucune

- [okeuu] Créer le projet Flutter
- [okeuu] Configurer `pubspec.yaml` (Riverpod, Hive, google_fonts, share_plus, etc.)
- [okeuu] Mettre en place le Design System complet (theme, colors, glassmorphism)
- [okeuu] Créer toute la structure de dossiers selon `Project_structure.md`
- [okeuu] Ajouter les assets (`images/products/` + logo via Stitch)
- [okeuu] Initialiser Hive + adapters
- [okeuu] Configurer Riverpod providers de base

### Stage 2: Core UI & Navigation

**Durée estimée :** 6-8 heures  
**Dépendances :** Stage 1 terminé

- [okeuu] Générer avec **Stitch** le Splash Screen + logo
- [okeuu] Générer avec **Stitch** le style global (glassmorphism, orange #FF7A00)
- [okeuu] Implémenter Bottom Navigation + FAB central orange
- [okeuu] Mettre en place routing (GoRouter)
- [okeuu] Créer les 5 écrans vides avec Scaffold et thème
- [okeuu] Appliquer Inter font partout

### Stage 3: Core Screens & Features

**Durée estimée :** 12-16 heures  
**Dépendances :** Stage 2 terminé

- [okeuu] Générer avec **Stitch** le Dashboard complet → implémenter
- [ ] Générer avec **Stitch** Mes Produits (liste + recherche + édition) → implémenter
- [okeuu] Générer avec **Stitch** Déclarer Ventes du Jour (presets + total live) → implémenter
- [okeuu] Générer avec **Stitch** Résumé de la Journée (hero + WhatsApp) → implémenter
- [okeuu] Créer modèles Hive (Product, DailySale)
- [okeuu] Implémenter logique calcul caisse / marge / mise à jour stock

### Stage 4: Offline Logic & Polish

**Durée estimée :** 8-10 heures  
**Dépendances :** Stage 3 terminé

- [/] Persistance complète avec Hive
- [/] Historique 7 jours
- [/] Badges stock dynamiques
- [okeuu] Confirmation dialog avant validation journée
- [/] Micro-interactions et animations
- [ ] Optimisation performance et taille APK

### Stage 5: Testing on Android Studio Emulator

**Durée estimée :** 6-8 heures  
**Dépendances :** Stage 4 terminé

- [/] Tester tous les écrans sur émulateur Android Studio (Android 8.0+ et 14)
- [/] Vérifier usage à une main et vitesse
- [/] Tester partage WhatsApp
- [ ] Valider taille APK < 15 Mo
- [/] Mettre à jour `Bug_tracking.md`
- [ ] Préparer screenshots pour Play Store

**Durée totale estimée MVP Frontend :** 36-48 heures (1 développeur + Antigravity/Stitch)

## Important Guidelines

- **Stitch obligatoire** : Tout écran ou composant visuel doit d’abord être généré avec Stitch
- Frontend en priorité absolue
- Tester sur émulateur Android Studio après chaque stage important
- Respecter strictement `UI_UX_doc.md` et `Project_structure.md`
- Garder l’app ultra-simple et magnifique

**Règle d’or :** On construit d’abord un frontend premium avec Stitch, on teste sur émulateur, puis on passe au reste.
