# FAQ — Dimensional Chests

---

## 🇫🇷 Français

### Comment fonctionne le partage d'inventaire ?

Chaque coffre dimensionnel puise et dépose directement dans un stock commun à son réseau, plutôt que de transférer des objets via une bande ou un robot. Poser un objet dans un coffre lié le rend instantanément disponible dans tous les autres coffres du même réseau, même sur une autre surface.

### Comment lier un coffre (ou le réservoir) à un réseau ?

Ouvrez le coffre ou le réservoir : une interface dédiée s'affiche avec la liste des réseaux existants pour cette taille de coffre (ou pour le réservoir). Sélectionnez un réseau puis appliquez-le, ou créez-en un nouveau si besoin. Un bouton permet de délier l'entité à tout moment.

### Les réseaux sont-ils partagés entre les différentes tailles de coffres ?

Non. Chaque taille de coffre (16, 32, 64, 128, 256 ou 512 emplacements) possède son propre ensemble de réseaux nommés, tout comme le réservoir dimensionnel. Un « Coffre dimensionnel » et un « Grand coffre dimensionnel » ne peuvent donc pas partager le même réseau.

### Le réseau fonctionne-t-il entre plusieurs surfaces ?

Oui. Deux coffres (ou réservoirs) du même réseau partagent leur contenu qu'ils soient sur la même surface ou sur des surfaces différentes.

### Que se passe-t-il si je délie un réservoir de fluide ?

Un réservoir non lié n'accepte plus aucun apport de fluide : il ne fait plus qu'extraire ce qu'il contient déjà. Cela évite qu'un réservoir oublié hors réseau ne se remplisse dans le vide.

> ⚠️ **Problème connu** : tant qu'un réservoir n'est pas lié, tout fluide qui y est injecté disparaît purement et simplement, au lieu d'être simplement refusé. Ce comportement n'est pas encore corrigé.

### Un réservoir peut-il contenir plusieurs fluides à la fois ?

Non, comme un réservoir classique il ne gère qu'un seul fluide à la fois. Tous les réservoirs d'un même réseau partagent ce fluide unique, à la manière d'un « ender tank ».

### Les paramètres de liaison suivent-ils lors d'un copier/coller, d'un collage par robot ou d'un blueprint ?

Oui, dans les trois cas. La liaison au réseau est conservée quand vous copiez/collez les paramètres d'une entité vers une autre, quand un robot colle des paramètres, et quand vous posez un blueprint contenant des coffres ou un réservoir déjà configurés.

### Les coffres sont-ils compatibles avec le réseau de circuits ?

Oui, tous les coffres dimensionnels lisent leur contenu et leur mode logistique sur le réseau de circuits, exactement comme un coffre en acier.

### À quoi sert l'animation sur le coffre ou le réservoir ?

C'est un indicateur visuel : elle joue uniquement quand l'entité est activement liée à un réseau, et s'arrête dès qu'elle est déliée. Un simple coup d'œil suffit pour repérer les entités connectées.

### Le mod est-il compatible avec Space Exploration et Krastorio 2 ?

Oui. Ces deux mods sont gérés comme dépendances optionnelles, ce qui garantit que Dimensional Chests se charge après eux. Un correctif dédié évite un conflit de collision qui aurait autrement empêché de poser le réservoir dimensionnel sur certaines plateformes spatiales.

### Faut-il débloquer une technologie pour chaque taille de coffre ?

Oui, chaque taille de coffre et le réservoir ont leur propre technologie à débloquer, avec des prérequis progressifs (électronique, réseau de circuits, science chimique/production, etc.).

> ℹ️ Le coût de ces technologies, ainsi que le coût de fabrication des coffres, est amené à être fortement durci dans une prochaine version.

### La suppression d'un coffre ou d'un réservoir affecte-t-elle le reste du réseau ?

Non. Détruire ou miner une entité liée la retire simplement de son réseau ; le reste des entités connectées continue de fonctionner normalement.

### Pourquoi mon réseau ne peut-il pas être supprimé ?

Parce qu'il contient encore des entités (coffres ou réservoir) qui y sont liées. Déliez ou détruisez d'abord toutes les entités du réseau avant de pouvoir le supprimer.

---

## 🇬🇧 English

### How does the shared inventory work?

Each dimensional chest reads and writes directly to a stock shared by its network, instead of moving items through belts or bots. Dropping an item into a linked chest makes it instantly available in every other chest on the same network, even across surfaces.

### How do I link a chest (or the tank) to a network?

Open the chest or tank: a dedicated GUI shows the list of existing networks for that chest size (or for the tank). Pick a network and apply it, or create a new one if needed. A button lets you unlink the entity at any time.

### Are networks shared between different chest sizes?

No. Each chest size (16, 32, 64, 128, 256, or 512 slots) has its own set of named networks, and so does the dimensional tank. A "Dimensional Chest" and a "Large Dimensional Chest" can't share the same network.

### Does the network work across multiple surfaces?

Yes. Two chests (or tanks) on the same network share their contents whether they're on the same surface or on different ones.

### What happens if I unlink a fluid tank?

An unlinked tank stops accepting any fluid input — it can only extract what it already holds. This prevents a tank left outside a network from silently filling up.

> ⚠️ **Known issue**: while a tank is unlinked, any fluid pumped into it simply disappears instead of being rejected. This isn't fixed yet.

### Can a tank hold more than one fluid at a time?

No, like a regular storage tank it only handles a single fluid at a time. Every tank on the same network shares that one fluid, ender-tank style.

### Do link settings survive copy/paste, robot-pasted settings, or blueprints?

Yes, in all three cases. The network link is preserved when copy/pasting settings between entities, when a robot pastes settings, and when you place a blueprint containing already-configured chests or a tank.

### Are the chests compatible with the circuit network?

Yes, all dimensional chests read their contents and logistic mode over the circuit network, exactly like a steel chest.

### What's the animation on the chest or tank for?

It's a visual indicator: it only plays while the entity is actively linked to a network, and stops as soon as it's unlinked — an easy way to spot connected entities at a glance.

### Is the mod compatible with Space Exploration and Krastorio 2?

Yes. Both are handled as optional dependencies, which ensures Dimensional Chests loads after them. A dedicated fix avoids a collision conflict that would otherwise prevent placing the dimensional tank on certain space platforms.

### Does every chest size need its own technology unlock?

Yes, each chest size and the tank have their own technology to research, with progressively deeper prerequisites (electronics, circuit network, chemical/production science, etc.).

> ℹ️ The cost of these technologies, along with the crafting cost of the chests, is planned to be significantly increased in an upcoming version.

### Does removing a chest or tank affect the rest of the network?

No. Destroying or mining a linked entity simply removes it from its network; the remaining connected entities keep working normally.

### Why can't I delete my network?

Because it still has entities (chests or the tank) linked to it. Unlink or destroy every entity on the network first before you can delete it.
