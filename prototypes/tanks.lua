--tanks.lua
-- Réservoir dimensionnel : équivalent "ender tank" pour les fluides.
-- Un seul item/entité (contrairement aux 6 tiers des coffres).
-- Caractéristiques calquées sur le "kr-huge-storage-tank" de Krastorio 2 :
-- hitbox 5x5, capacité 200000, 12 connexions de tuyaux (3 par côté),
-- 2000 PV, résistances, flow_length_in_ticks=360, circuit_wire_max_distance=20.
--
-- Graphismes dédiés (architecture identique aux coffres) :
--   entity.png    : 512x512  (sprite statique de l'entité, scale 0.416015625 ;
--                   sert aussi d'icône item/recette/techno, icon.png n'existe
--                   plus)
--   animation.png : 4096x4096, grille 8x8 (64 frames) -> frames de 512x512,
--                   scale 0.416015625, animation de liaison jouée uniquement
--                   quand le réservoir est connecté à un réseau (cf. control.lua).
--
-- IMPORTANT : contrairement au linked-container des coffres, le storage-tank
-- n'a pas de mécanisme natif de mise en réseau. La synchronisation entre
-- réservoirs d'un même réseau est simulée manuellement dans control.lua.
--
-- NOTE : le corpse "kr-medium-random-pipes-remnants" du huge tank K2 n'est
-- pas repris ici (dépendance Krastorio2 non confirmée) ; on garde le
-- "medium-remnants" vanilla, cohérent avec le "small-remnants" des coffres.

local base_tank = data.raw["storage-tank"]["storage-tank"]

local proto = table.deepcopy(base_tank)

proto.name = "reservoir-dimensionnel"
proto.localised_name = "Réservoir dimensionnel"
proto.minable = {mining_time = 1, result = "reservoir-dimensionnel"}

-- hitbox 5x5 : valeurs reprises telles quelles du kr-huge-storage-tank
proto.collision_box = {{-2.35, -2.35}, {2.35, 2.35}}
proto.selection_box = {{-2.5, -2.5}, {2.5, 2.5}}

-- caractéristiques reprises du kr-huge-storage-tank
proto.max_health = 2000
proto.flow_length_in_ticks = 360
proto.resistances = {
    {type = "physical", percent = 50},
    {type = "fire", percent = 80},
    {type = "impact", percent = 80}
}
proto.corpse = "medium-remnants"
proto.vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65}
proto.working_sound = {
    sound = {
        filename = "__base__/sound/storage-tank.ogg",
        volume = 0.5
    },
    max_sounds_per_prototype = 3
}
proto.circuit_wire_max_distance = 20

-- capacité du fluidbox (API 2.0 : "volume", en unités de fluide)
proto.fluid_box.volume = 200000

-- 12 connexions de tuyaux : 3 par côté, positions reprises telles quelles du
-- kr-huge-storage-tank (offsets -1 / 0 / 1 le long de chaque côté, bord à ±2)
proto.fluid_box.pipe_connections = {
    -- côté ouest
    {flow_direction = "input-output", direction = defines.direction.west, position = {-2, -1}},
    {flow_direction = "input-output", direction = defines.direction.west, position = {-2, 0}},
    {flow_direction = "input-output", direction = defines.direction.west, position = {-2, 1}},
    -- côté nord
    {flow_direction = "input-output", direction = defines.direction.north, position = {-1, -2}},
    {flow_direction = "input-output", direction = defines.direction.north, position = {0, -2}},
    {flow_direction = "input-output", direction = defines.direction.north, position = {1, -2}},
    -- côté est
    {flow_direction = "input-output", direction = defines.direction.east, position = {2, -1}},
    {flow_direction = "input-output", direction = defines.direction.east, position = {2, 0}},
    {flow_direction = "input-output", direction = defines.direction.east, position = {2, 1}},
    -- côté sud
    {flow_direction = "input-output", direction = defines.direction.south, position = {-1, 2}},
    {flow_direction = "input-output", direction = defines.direction.south, position = {0, 2}},
    {flow_direction = "input-output", direction = defines.direction.south, position = {1, 2}}
}

-- icône dédiée (remplace celle du storage-tank vanilla)
-- NB : icon.png n'existe plus (dossier tank ne contient plus que entity.png
-- et animation.png) -> on réutilise entity.png comme icône, comme pour les coffres.
proto.icon = "__Dimensional-Chests__/graphics/tank/entity.png"
proto.icon_size = 512
proto.icons = nil

-- sprite statique dédié (remplace pictures.picture du storage-tank vanilla ;
-- les autres champs de "pictures" -- window_background, fluid_background,
-- flow_sprite, gas_flow_animation -- restent ceux du vanilla via le deepcopy)
-- 512x512px désormais (au lieu de 426x426) ; scale recalculé pour conserver
-- la même taille affichée en jeu : 0.5 * 426/512 = 0.416015625
proto.pictures.picture = {
    filename = "__Dimensional-Chests__/graphics/tank/entity.png",
    width = 512,
    height = 512,
    scale = 0.416015625,
    shift = {0, 0}
}

data:extend({proto})

-- Animation de liaison (jouée uniquement quand le réservoir est lié à un
-- réseau), même format que les animations des coffres dans chests.lua.
-- spritesheet 4096x4096, grille 8x8 (64 frames) -> frames de 512x512,
-- scale = 0.416015625, cohérent avec le picture ci-dessus.
data:extend({
    {
        type = "animation",
        name = "reservoir-dimensionnel-animation",
        filename = "__Dimensional-Chests__/graphics/tank/animation.png",
        width = 512,
        height = 512,
        line_length = 8,
        frame_count = 64,
        animation_speed = 1,
        scale = 0.416015625,
        shift = {0, 0}
    }
})
