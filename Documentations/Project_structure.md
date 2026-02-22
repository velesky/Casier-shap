# Project Structure - Casier Chap

## Root Directory

```text
casier_chap/
├── .cursor/
│   └── rules/
├── Documentations/
│   ├── PRD.md
│   ├── Implementation.md
│   ├── Project_structure.md
│   ├── UI_UX_doc.md
│   ├── Bug_tracking.md
│   └── README.md
├── lib/
│   ├── app/                          # Configuration globale de l'application
│   │   ├── app.dart
│   │   ├── router.dart
│   │   └── bootstrap.dart
│   ├── core/                         # Couche technique globale
│   │   ├── constants/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── di/
│   ├── features/                     # Modules métiers (architecture modulaire claire)
│   │   ├── dashboard/
│   │   │   ├── presentation/
│   │   │   │   ├── dashboard_screen.dart
│   │   │   │   └── dashboard_viewmodel.dart
│   │   │   └── widgets/
│   │   ├── inventory/                # Mes Produits + Gestion stock
│   │   │   ├── presentation/
│   │   │   │   ├── inventory_screen.dart
│   │   │   │   └── inventory_viewmodel.dart
│   │   │   └── widgets/
│   │   ├── sales/
│   │   │   ├── presentation/
│   │   │   │   ├── declare_sales_screen.dart
│   │   │   │   └── daily_summary_screen.dart
│   │   │   └── widgets/
│   │   └── history/
│   │       ├── presentation/
│   │       │   ├── history_screen.dart
│   │       │   └── history_viewmodel.dart
│   │       └── widgets/
│   ├── shared/                       # Éléments réutilisables partout
│   │   ├── widgets/
│   │   │   ├── product_card.dart
│   │   │   ├── quantity_preset_buttons.dart
│   │   │   ├── hero_card.dart
│   │   │   ├── status_badge.dart
│   │   │   └── glass_card.dart
│   │   ├── models/
│   │   │   ├── product.dart
│   │   │   ├── daily_sale.dart
│   │   │   └── stock_history.dart
│   │   └── extensions/
│   ├── data/                         # Couche données
│   │   ├── repositories/
│   │   └── services/
│   └── main.dart
├── assets/
│   ├── images/
│   │   ├── logo/
│   │   └── products/
│   └── icons/
├── test/
├── pubspec.yaml
├── analysis_options.yaml
├── flutter_native_splash.yaml
├── flutter_launcher_icons.yaml
├── README.md
└── .gitignore
```

## Detailed Structure

### `/lib` - Code source principal (Flutter)

- **app/** : Configuration globale (app, router, bootstrap)
- **core/** : Couche technique globale (thème, constants, DI)
- **features/** : Organisation modulaire par fonctionnalité métier
- **shared/** : Éléments réutilisables (widgets, modèles, extensions)
- **data/** : Couche données (repositories et services Hive)

### `/assets` - Ressources statiques

- **images/products/** : Photos produits réalistes
- **images/logo/** : Logo principal (généré par Stitch)

### `/Documentations` - Documentation du projet

- Tous les fichiers de référence

### Fichiers de configuration racine

- `pubspec.yaml` : Dépendances
- `flutter_native_splash.yaml` : Splash screen
- `flutter_launcher_icons.yaml` : Icônes de l’app

## File Naming Conventions

- **Écrans** : `xxx_screen.dart`
- **ViewModels** : `xxx_viewmodel.dart`
- **Widgets communs** : dans `shared/widgets/`
- **Modèles** : dans `shared/models/`
- **Dossiers features** : minuscules (dashboard/, inventory/, sales/, history/)

## Module Organization (Flutter Best Practices)

- Architecture modulaire Feature-First
- Chaque feature contient son dossier `presentation/` (screen + viewmodel) et `widgets/`
- Riverpod pour le state management
- Hive pour la persistance 100% offline
- Stitch obligatoire pour tout design avant de coder l’UI

## Development Workflow (Frontend First)

1. Générer le design avec **Stitch**
2. Implémenter le code Flutter
3. Tester immédiatement sur **émulateur Android Studio**
4. Valider la cohérence avec `UI_UX_doc.md`
5. Mettre à jour `Implementation.md` et `Bug_tracking.md`

**Backend** : Aucun pour le MVP (tout en local avec Hive).  
**Test** : Obligatoire sur émulateur Android Studio après chaque écran important.
