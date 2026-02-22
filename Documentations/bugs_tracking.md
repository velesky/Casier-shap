# Bug Tracking - Casier Chap

## Overview

Ce document suit tous les bugs, problèmes et leurs résolutions pour le projet **Casier Chap**.  
Tout bug doit être documenté ici **avant** d’être corrigé.  
Le projet est 100% Flutter + Stitch + Hive (frontend first).

**Dernière mise à jour :** 20 février 2026  
**Version du document :** 1.0

## Bug Report Template

### Bug ID: CAS-YYYY-MM-DD-X

- **Date signalée :** [JJ/MM/AAAA]
- **Reporter :** [Ton nom ou Antigravity]
- **Sévérité :** [Critique / Haute / Moyenne / Basse]
- **Statut :** [Open / In Progress / Resolved / Closed]
- **Environnement :** [Emulateur Android Studio / Appareil physique / Antigravity]
- **Version Flutter :** [3.24.x]

#### Description du bug

[Description claire et concise]

#### Étapes pour reproduire

1. Step 1
2. Step 2
3. Step 3

#### Comportement attendu

[Ce qui devrait se passer]

#### Comportement réel

[Ce qui se passe réellement]

#### Messages d’erreur / Logs

```console
[Copie les logs ou l’erreur ici]
```

#### Screenshots / Vidéo

[Joindre si possible]

#### Résolution

[Comment le bug a été corrigé - à remplir une fois résolu]

#### Date de résolution

[JJ/MM/AAAA]

## Active Bugs

Aucun bug actif pour l’instant. À remplir au fur et à mesure.

## Resolved Bugs

Exemple (à supprimer une fois le premier bug réel ajouté).

### Bug ID: CAS-2026-02-20-001

- **Date signalée :** 20/02/2026
- **Sévérité :** Moyenne
- **Statut :** Resolved
- **Environnement :** Emulateur Android Studio
- **Date de résolution :** 20/02/2026

#### Description

Le bouton +24 n’était pas assez grand sur les petits écrans.

#### Résolution du bug

Augmenté le `minimumSize` du bouton à 56dp et régénéré le design avec Stitch.

## Common Issues & Solutions (Casier Chap)

### Hive Initialization Errors

**Problème :** `Hive.initFlutter()` ou adapters non enregistrés  
**Solution :** Appeler `HiveService.init()` dans `main.dart` avant `runApp()`

### Riverpod Provider Not Found

**Problème :** `Provider not found`  
**Solution :** Vérifier que le provider est dans `ProviderScope` et bien importé

### Stitch Design → Code mismatch

**Problème :** L’UI codée ne ressemble pas au design Stitch  
**Solution :** Régénérer le design avec Stitch + copier les couleurs/hex exacts depuis UI_UX_doc.md

### APK trop lourd (>15 Mo)

**Problème :** Photos produits trop lourdes  
**Solution :** Compresser les images dans assets/images/products/ + utiliser `flutter build apk --split-per-abi`

### Boutons trop petits sur émulateur

**Problème :** Touch targets < 56dp  
**Solution :** Toujours utiliser `minimumSize: Size(56, 56)` sur les ElevatedButton / TextButton

### Dark mode / Glassmorphism non appliqué

**Problème :** Carte blanche au lieu de glassmorphism  
**Solution :** Utiliser `glass_card.dart` et `AppTheme.dark()` partout

### WhatsApp share ne fonctionne pas

**Problème :** share_plus ne s’ouvre pas  
**Solution :** Ajouter les permissions dans AndroidManifest + tester sur appareil physique

## Bug Severity Levels

- **Critique** : Crash de l’app, perte de données, impossibilité d’utiliser
- **Haute** : Fonctionnalité principale cassée (Déclarer ventes, Résumé)
- **Moyenne** : UI/UX dégradée, bouton trop petit, mauvais alignement
- **Basse** : Problème cosmétique, texte mal orthographié, icône légèrement décalée

## Bug Status Definitions

- **Open** : Signalé et confirmé
- **In Progress** : En cours de correction
- **Resolved** : Corrigé et testé sur émulateur
- **Closed** : Vérifié et validé

## Reporting Guidelines

1. Cherche d’abord si le bug existe déjà
2. Sois très précis (étapes + environnement)
3. Joins toujours screenshot ou vidéo
4. Mets à jour le statut régulièrement
5. Documente toujours la solution

### Règle importante

Aucun bug ne doit être corrigé sans être d’abord enregistré ici.
