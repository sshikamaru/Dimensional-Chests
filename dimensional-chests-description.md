# Dimensional Chests — Description portail des mods

---

## 🇫🇷 Français

### Résumé court

Des coffres et un réservoir dimensionnels qui partagent leur inventaire (ou leur fluide) à distance, en 6 tailles de coffres (16 à 512 emplacements) plus un réservoir de fluide, avec gestion de réseaux nommés, réseau de circuits et une animation visuelle quand la liaison est active.

### Description complète

**Dimensional Chests** ajoute une gamme de coffres, ainsi qu'un réservoir, capables de partager le même inventaire ou le même stock de fluide, où qu'ils soient placés sur la carte (même surface ou surfaces différentes). Contrairement à un simple coffre relié par une bande transporteuse, chaque coffre dimensionnel puise et dépose directement dans un stock commun : posez-en un dans votre zone de minage, un autre à l'usine, et les objets sont disponibles instantanément des deux côtés.

**Six tailles de coffres, chacune avec sa propre technologie :**

| Coffre | Emplacements | Emprise |
|---|---|---|
| Coffre dimensionnel | 16 | 1×1 |
| Grand coffre dimensionnel | 32 | 2×2 |
| Container dimensionnel | 64 | 3×3 |
| Grand container dimensionnel | 128 | 4×4 |
| Entrepôt dimensionnel | 256 | 5×5 |
| Grand entrepôt dimensionnel | 512 | 6×6 |

**Un réservoir dimensionnel pour les fluides :**

| Réservoir | Capacité | Emprise |
|---|---|---|
| Réservoir dimensionnel | 200 000 | 5×5 |

Fonctionne sur le même principe que les coffres, mais pour un seul fluide à la fois : tous les réservoirs d'un même réseau partagent le même stock, comme un « ender tank ». Un réservoir non lié n'accepte plus d'apport et ne fait plus qu'extraire, pour éviter qu'il ne se remplisse dans le vide.

**Interface de gestion des réseaux :**
- Chaque taille de coffre — et le réservoir — possède ses propres réseaux, que vous nommez et gérez librement (créer, renommer, supprimer).
- Interface dédiée à l'ouverture du coffre ou du réservoir : sélectionnez un réseau dans la liste, appliquez-le ou déliez-le en un clic.
- Les paramètres de liaison sont conservés lors du copier-coller de paramètres, du collage via robot, et se propagent correctement avec les blueprints.

**Réseau de circuits :**
Tous les coffres sont compatibles avec le réseau de circuits : lecture du contenu et du mode logistique, comme un coffre en acier.

**Retour visuel :**
Une animation distincte se déclenche sur le coffre ou le réservoir dès qu'il est activement lié à un réseau, et s'arrête immédiatement si vous le déliez — un repère visuel simple pour savoir d'un coup d'œil quels éléments sont connectés.

### Compatibilité
- Fonctionne avec la construction par robots et par le joueur.
- Compatible blueprints, copier/coller de paramètres.
- Nécessite de débloquer la technologie correspondant à chaque taille de coffre et au réservoir.

---

## 🇬🇧 English

### Short description

Dimensional chests and a dimensional tank that share their inventory (or fluid) across distance, in 6 chest sizes (16 to 512 slots) plus one fluid tank, with named network management, circuit network support, and a visual animation while actively linked.

### Full description

**Dimensional Chests** adds a line of chests, plus a fluid tank, that share the exact same inventory or fluid stock no matter where they're placed on the map (same surface or different surfaces). Unlike belt-connected storage, each dimensional chest reads and writes directly to a shared stock: drop one at your mining outpost, another at your factory, and items are instantly available on both ends.

**Six chest sizes, each gated behind its own technology:**

| Chest | Slots | Footprint |
|---|---|---|
| Dimensional Chest | 16 | 1×1 |
| Large Dimensional Chest | 32 | 2×2 |
| Dimensional Container | 64 | 3×3 |
| Large Dimensional Container | 128 | 4×4 |
| Dimensional Warehouse | 256 | 5×5 |
| Large Dimensional Warehouse | 512 | 6×6 |

**A dimensional tank for fluids:**

| Tank | Capacity | Footprint |
|---|---|---|
| Dimensional Tank | 200,000 | 5×5 |

Works on the same principle as the chests, but for a single fluid at a time: every tank on the same network shares the same pool, ender-tank style. An unlinked tank stops accepting input and only extracts, so it can't silently fill up while disconnected.

**Network management interface:**
- Each chest size — and the tank — has its own set of networks, which you name and manage freely (create, rename, delete).
- A dedicated GUI opens with the chest or tank: pick a network from the dropdown, apply it, or unlink it with one click.
- Link settings are preserved through copy/paste, robot-pasted settings, and propagate correctly through blueprints.

**Circuit network:**
All chests support the circuit network — reading contents and logistic mode, just like a steel chest.

**Visual feedback:**
A distinct animation plays on the chest or tank as soon as it's actively linked to a network, and stops immediately when unlinked — a quick visual cue for spotting which ones are connected at a glance.

### Compatibility
- Works with both player and robot construction.
- Blueprint-compatible, supports copy/paste of settings.
- Each chest size and the tank require unlocking their corresponding technology.
