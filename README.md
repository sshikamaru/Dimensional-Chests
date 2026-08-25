# Dimensional Chests

Mod Factorio ajoutant des coffres — et un réservoir de fluide — qui partagent leur contenu à distance, en 6 tailles de coffres plus un réservoir, avec gestion de réseaux nommés, réseau de circuits et une animation visuelle quand la liaison est active.

[![Mod Portal](https://img.shields.io/badge/Factorio-Mod%20Portal-orange)](https://mods.factorio.com/mod/Dimensional-Chests)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Factorio](https://img.shields.io/badge/Factorio-2.x-brightgreen)](https://factorio.com)

*A Factorio mod adding chests — and a fluid tank — that share their contents across distance, in 6 chest sizes plus one tank, with named network management, circuit network support, and a linked-status animation.*

---

## Fonctionnalités

- **6 tailles de coffres dimensionnels** (16 à 512 emplacements), chacune débloquée par sa propre technologie.
- **1 réservoir dimensionnel** (200 000 unités de fluide, emprise 5×5), débloqué par sa propre technologie, fonctionnant selon le même principe qu'un « ender tank » : tous les réservoirs d'un même réseau partagent le même fluide.
- **Réseaux nommés par taille de coffre et pour le réservoir** : créez, renommez, supprimez vos réseaux via une interface dédiée qui s'ouvre avec l'entité.
- **Réseau de circuits** : lecture du contenu et du mode logistique sur les coffres, comme un coffre en acier.
- **Compatible construction robot, blueprints, copier/coller de paramètres** : les paramètres de liaison suivent l'entité dans ces trois cas.
- **Animation de liaison** : un visuel distinct joue sur le coffre ou le réservoir tant qu'il est actif dans un réseau, et s'arrête dès qu'il est délié.
- **Compatibilité Space Exploration / Krastorio 2** : correctifs dédiés en `data-final-fixes.lua` pour éviter les conflits de collision liés à ces mods.

## Installation

- Via le [Mod Portal officiel](https://mods.factorio.com/mod/Dimensional-Chests) (recherche intégrée au jeu ou téléchargement manuel).
- Ou en clonant ce dépôt dans votre dossier `mods` :

```bash
git clone https://github.com/sshikamaru/Dimensional-Chests.git
```

## Structure du projet

```
Dimensional-Chests/
├── control.lua                      # Logique runtime : GUI, réseaux, animations, events
├── data.lua                         # Point d'entrée data-stage, require des prototypes
├── data-final-fixes.lua             # Correctifs de compatibilité (collision, Space Exploration)
├── prototypes/
│   ├── chests.lua                   # Prototypes des 6 coffres et de leurs animations
│   ├── tanks.lua                    # Prototype du réservoir dimensionnel et son animation
│   ├── items.lua                    # Items de placement (coffres + réservoir)
│   ├── recipes.lua                  # Recettes de fabrication
│   └── technologies.lua             # Arbre technologique
├── info.json                        # Métadonnées du mod
├── locale/                          # Traductions
├── graphics/                        # Icônes, sprites, animations (1x1 à 6x6, tank)
├── README.md
└── FAQ.md
```

## Développement

Ce mod est écrit pour Factorio 2.x (API `storage`, prototypes `linked-container` pour les coffres).

Le réservoir dimensionnel repose sur un `storage-tank` classique : contrairement au `linked-container`, ce type n'a pas de mise en réseau native. La synchronisation entre réservoirs d'un même réseau est donc simulée côté script dans `control.lua`, à intervalle régulier.

Pour tester localement :
1. Clonez ou liez ce dossier dans votre répertoire `%APPDATA%/Factorio/mods/` (Windows) ou `~/.factorio/mods/` (Linux/Mac), avec un nom de dossier `Dimensional-Chests_<version>`.
2. Activez le mod depuis le menu des mods en jeu.

## Contribuer

Les issues et pull requests sont les bienvenues. Merci de :
- Décrire clairement le contexte (version de Factorio, mods actifs, étapes de reproduction pour un bug).
- Garder un style de code cohérent avec l'existant.

## Licence

Ce mod est distribué sous licence [MIT](LICENSE).

## Crédits

Développé par sshika.
