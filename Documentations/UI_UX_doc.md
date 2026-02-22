# UI/UX Documentation - Casier Chap

## Design System Overview

Casier Chap est une application mobile Flutter 100% offline, ultra-simple et premium, conçue pour les gérants de petits maquis et bars en Côte d’Ivoire.

**Style global :** Dark mode profond, moderne 2026, glassmorphism subtil, énergie orange vif, très gros éléments tactiles, utilisation à une main en moins de 30 secondes.

**Règle absolue :** Tout élément visuel (logo, écrans, cartes, boutons, photos produits, mockups) **doit être généré avec Stitch** avant d’être converti en code Flutter.

## Visual Style Guide

### Color Palette

#### Primary Colors

- **Primary Orange (énergie principale) :** `#FF7A00`
- **Primary Dark Orange :** `#E66A00`
- **Primary Light Orange :** `#FFB74D`

#### Semantic Colors

- **Success / Bon État :** `#00E676` (vert vif)
- **Warning / Moyen :** `#FF9500` (orange moyen)
- **Critical / Stock Faible :** `#FF3D00` (rouge discret)
- **Background :** `#000000` (noir profond)
- **Surface / Cards :** `#1C1C1E` (glassmorphism)
- **Border Glass :** `rgba(255,255,255,0.08)`
- **Text Primary :** `#FFFFFF`
- **Text Secondary :** `#A1A1A6`

### Typography (Inter)

- **Heading 1 (titres écrans) :** 28-32pt Bold
- **Big Numbers (caisse, stock) :** 36-48pt Semi-Bold
- **Body / Labels :** 17pt Regular
- **Captions / Prix petits :** 13-14pt Medium
- **Buttons :** 17pt Semi-Bold

### Spacing & Layout

- Padding horizontal principal : 24px
- Padding vertical cartes : 16-20px
- Espacement entre éléments : 16px / 24px
- Coins arrondis : **28px** sur toutes les cartes et boutons principaux

### Glassmorphism

- Background : `Color(0x1C1C1E)` avec opacity 0.95
- Border : 1px solid `rgba(255,255,255,0.08)`
- Blur : subtil (utiliser `BackdropFilter` ou Container avec BoxDecoration)

### Shadows

- Soft shadow pour élévation légère sur les cartes

## Component Guidelines (Flutter)

### Hero Card (valeur stock / caisse)

- Grande carte orange dégradé
- Gros chiffre centré
- Badge vert pour évolution (+12%)

### Product Card

- Photo produit réaliste à gauche (grande)
- Nom produit en Bold
- "Casier 24 bouteilles"
- Prix achat / vente alignés
- Badge statut (BON ÉTAT / MOYEN / CRITIQUE)
- Bouton édition discret

### Quantity Preset Buttons

- Gros boutons orange : **+1  +5  +10  +24**
- Touch target minimum 56dp
- +24 particulièrement mis en avant (casier)

### FAB Central

- Bouton orange géant permanent en bas au centre
- Icône + « Déclarer ventes »

### Bottom Navigation

- 5 icônes : Accueil, Stock, Ventes (FAB), Historique, Profil

### Bouton WhatsApp

- Vert vif (#25D366), très grand sur l’écran Résumé
- Icône WhatsApp + texte "Partager sur WhatsApp"

### Status Badges

- Vert rond « BON ÉTAT »
- Orange « MOYEN »
- Rouge « CRITIQUE »

## Specific Screens (à générer avec Stitch)

1. **Splash Screen** : Logo caisse orange + tagline
2. **Dashboard** : Hero valeur stock + 3 petites cartes catégories + scroll horizontal produits
3. **Mes Produits** : Search bar + liste verticale ProductCard
4. **Déclarer Ventes** : Liste produits + presets quantités + total live en bas
5. **Résumé de la Journée** : Hero caisse énorme + marge verte + bouton WhatsApp géant

## User Experience Rules

- **Ultra-simple** : maximum 3 taps pour déclarer une journée
- **One-handed** : tous les boutons en zone accessible avec le pouce
- **Dark mode only** : optimisé pour usage soir/nuit dans le maquis
- **Photos produits réalistes** : Flag Spéciale, Bock Solibra, Coca-Cola, Guinness, Fanta, Awa 1.5L…
- **Feedback immédiat** : total estimé qui monte en live
- **Confirmation** : modale avant validation de la journée

## Accessibility & Performance

- Touch targets minimum 56dp
- Contraste très élevé (WCAG AAA)
- Police Inter lisible même sur petits écrans
- Images optimisées (assets locales)
- Application < 15 Mo
- Test obligatoire sur émulateur Android Studio après chaque écran important

## Stitch Usage Rule (Obligatoire)

Avant de coder tout nouvel écran ou composant visuel :

1. Demander à Stitch de générer le design (iPhone 16 Pro, dark mode, glassmorphism, orange #FF7A00)
2. Valider le visuel
3. Convertir en code Flutter propre

**Ce document est la référence visuelle unique du projet.**

Tout doit être cohérent avec ce Design System et généré via Stitch.
Ce fichier est maintenant 100% adapté à Casier Chap.
