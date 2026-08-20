# Dimensional Chests

Mod Factorio ajoutant des coffres qui partagent leur inventaire à distance, en 6 tailles, avec gestion de réseaux nommés, réseau de circuits et une animation visuelle quand la liaison est active.

[![Mod Portal](https://img.shields.io/badge/Factorio-Mod%20Portal-orange)](https://mods.factorio.com/mod/Dimensional-Chests)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

*A Factorio mod adding chests that share inventory across distance, in 6 sizes, with named network management, circuit network support, and a linked-status animation.*

---

## Fonctionnalités

- 6 tailles de coffres dimensionnels (16 à 512 emplacements), chacune débloquée par sa propre technologie.
- Réseaux nommés par taille de coffre : créez, renommez, supprimez vos réseaux via une interface dédiée.
- Compatible réseau de circuits (lecture du contenu et du mode logistique).
- Compatible construction robot, blueprints, copier/coller de paramètres.
- Animation de liaison : un visuel distinct joue sur le coffre tant qu'il est actif dans un réseau, et s'arrête dès qu'il est délié.

## Installation

- Via le [Mod Portal officiel](https://mods.factorio.com/mod/Dimensional-Chests) (recherche intégrée au jeu ou téléchargement manuel).
- Ou en clonant ce dépôt dans votre dossier `mods` :

```bash
git clone https://github.com/sshikamaru/Dimensional-Chests.git
```

## Structure du projet

```
Dimensional-Chests/
├── control.lua        # Logique runtime : GUI, réseaux, animations, events
├── chests.lua          # Prototypes des coffres et de leurs animations
├── items.lua           # Items de placement des coffres
├── recipes.lua         # Recettes de fabrication
├── technologies.lua    # Arbre technologique
├── info.json            # Métadonnées du mod
├── locale/              # Traductions
└── graphics/             # Icônes, sprites, animations (1x1 à 6x6)
```

## Développement

Ce mod est écrit pour Factorio 2.x (API `storage`, prototypes `linked-container`).

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
