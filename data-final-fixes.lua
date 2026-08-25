-- data-final-fixes.lua
-- Diagnostic en jeu (console F4/~) :
--   - surface_conditions : nil des deux côtés (vanilla ET reservoir-dimensionnel)
--     -> ce n'était PAS le mécanisme en cause.
--   - collision_mask.layers : vanilla n'a PAS "space_tile", mais
--     reservoir-dimensionnel L'A. La tuile de plateforme spatiale avancée
--     ("se-space-platform-plating") porte ce layer -> notre entité entre en
--     collision avec la tuile elle-même et ne peut donc pas y être construite.
--   Origine probable : un script K2/SE qui ajoute "space_tile" au
--   collision_mask de toute entité de type "storage-tank" non whitelistée
--   par nom (le vanilla et kr-huge-storage-tank y échappent, pas le nôtre).
--
-- IMPORTANT : pour que ce fichier s'exécute APRÈS celui qui ajoute ce layer
-- (et l'annule au lieu de l'inverse), Dimensional-Chests doit charger après
-- Space Exploration / Krastorio 2. Dans info.json, tableau "dependencies" :
--   "? space-exploration", "? Krastorio2"
-- (dépendances optionnelles : ordonnent le chargement sans rendre ces mods
-- obligatoires).

local proto = data.raw["storage-tank"] and data.raw["storage-tank"]["reservoir-dimensionnel"]
if proto then
    if proto.collision_mask and proto.collision_mask.layers then
        proto.collision_mask.layers["space_tile"] = nil
    end
    -- gardé par précaution, au cas où d'autres mods utilisent bien ce
    -- mécanisme-ci ({} = aucune restriction de surface)
    proto.surface_conditions = {}
end