# Casier Chap - Product Requirements Document (PRD)

**Version :** 1.0  
**Date :** 20 février 2026  
**Statut :** Approuvé - Prêt pour implémentation Frontend First

## 1. Project Description

### What

Application mobile **ultra-simple, gratuite et 100% offline** de gestion de stock de boissons (bières, sodas, eaux, jus, alcools) destinée aux petits maquis et bars en Côte d’Ivoire.  
Le gérant configure ses produits une seule fois, déclare ses ventes chaque soir en quelques taps, et obtient immédiatement la caisse théorique, la marge estimée et l’état du stock restant.

### Problem

Les gérants perdent de l’argent tous les jours à cause du vol, des erreurs de comptage et du manque de visibilité sur leur marge réelle. Ils n’ont ni temps ni outil simple pour suivre leur stock le soir. Les apps existantes sont trop complexes, payantes ou nécessitent internet.

### Target Audience

Gérants et propriétaires de petits maquis/bars en Côte d’Ivoire (25-55 ans), souvent sur Android entrée/milieu de gamme, usage principalement le soir, très peu de temps (< 45 secondes par jour), niveau de tech faible à moyen.

## 2. Objective

- Permettre à chaque gérant de savoir **en 30 secondes** si sa journée est bonne ou mauvaise
- Éliminer les pertes de stock et d’argent
- Devenir l’application la plus utilisée dans les maquis ivoiriens (stratégie : gratuit → viral → monétisation via pubs brasseurs)
- Objectif business : 10 000 installations actives en 3 mois, note Play Store ≥ 4.7

## 3. Core Features

### 3.1 Must-Have (MVP)

1. Setup initial des produits (une seule fois)
2. Déclarer les ventes du jour (presets +1, +5, +10, +24 pour casiers)
3. Résumé instantané de la journée (caisse théorique + marge + bouton partage WhatsApp)
4. Dashboard / État du stock (valeur totale + badges BON ÉTAT / MOYEN / CRITIQUE)
5. Mes Produits (liste avec recherche + édition rapide)
6. Historique des 7 derniers jours

### 3.2 Nice-to-Have (Post-MVP)

- Widget Android (caisse du jour sur l’écran d’accueil)
- Mode « Super Simple » (cache les prix d’achat)
- Suggestion de réapprovisionnement automatique
- Mode clair (optionnel)

## 4. User Stories

En tant que gérant de maquis, je veux :

- Ouvrir l’app et voir immédiatement la valeur de mon stock et si la journée est bonne
- Ajouter rapidement les quantités vendues avec un seul tap sur **+24** (casier)
- Valider ma journée et obtenir la caisse + marge en un clic
- Partager le résumé sur WhatsApp au propriétaire en un tap
- Voir l’état de chaque produit (BON / MOYEN / CRITIQUE) sans lire
- Configurer mes produits une seule fois au début

## 5. Technical Requirements

**Technology Stack (MVP) :**

- Framework : **Flutter 3.24+** (Frontend mobile first)
- State Management : Riverpod
- Stockage local 100% offline : Hive
- Visuels : **Stitch** (obligatoire pour tout design : logo, écrans, cartes, boutons, photos produits)
- Partage : share_plus (WhatsApp)
- Design : Material 3 + glassmorphism custom
- Typographie : Inter

**Contraintes strictes :**

- 100% offline (aucune API requise)
- Taille APK < 15 Mo
- Support Android 8.0+ (priorité marché ivoirien)
- Dark mode only (optimisé pour usage nocturne dans le maquis)
- Test obligatoire sur **émulateur Android Studio** après chaque écran important

## 6. Design & User Experience

**Visual Style :**  

Premium moderne 2026 – Dark mode profond, orange #FF7A00 énergique, glassmorphism subtil, photos produits réalistes, très gros boutons, hiérarchie ultra-claire, conçu pour usage à une main.

**Key UI Requirements :**

- Coins arrondis 28px sur toutes les cartes
- Touch targets minimum 56dp
- Typographie Inter (Bold pour titres, Semi-Bold pour gros chiffres)
- Boutons presets +1 / +5 / +10 / +24 très visibles
- Bouton WhatsApp géant sur l’écran résumé
- FAB central orange permanent pour « Déclarer ventes »

**Règle absolue :** Tout élément visuel doit être généré avec **Stitch** avant d’être codé en Flutter.

**Accessibilité :**

- Contraste très élevé
- Textes lisibles même en plein soleil ou nuit
- Icônes et badges couleur très intuitifs (vert/orange/rouge)
