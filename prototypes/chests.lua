--chests.lua

-- Animations de liaison (jouées uniquement quand le coffre est lié à un réseau)
-- Chaque spritesheet fait 1536px de large (8 colonnes) x (8 lignes) pour 64 frames au total
data:extend({
    {
        type = "animation",
        name = "coffre-dimensionnel-animation",
        filename = "__Dimensional-Chests__/graphics/1x1/animation.png",
        width = 192,
        height = 176,
        line_length = 8,
        frame_count = 64,
        animation_speed = 1,
        shift = {0, 0}
    },
    {
        type = "animation",
        name = "grand-coffre-dimensionnel-animation",
        filename = "__Dimensional-Chests__/graphics/2x2/animation.png",
        width = 192,
        height = 174,
        line_length = 8,
        frame_count = 64,
        animation_speed = 1,
        shift = {0, 0}
    },
    {
        type = "animation",
        name = "container-dimensionnel-animation",
        filename = "__Dimensional-Chests__/graphics/3x3/animation.png",
        width = 192,
        height = 201,
        line_length = 8,
        frame_count = 64,
        animation_speed = 1,
        shift = {0, 0}
    },
    {
        type = "animation",
        name = "grand-container-dimensionnel-animation",
        filename = "__Dimensional-Chests__/graphics/4x4/animation.png",
        width = 192,
        height = 187,
        line_length = 8,
        frame_count = 64,
        animation_speed = 1,
        shift = {0, 0}
    },
    {
        type = "animation",
        name = "entrepot-dimensionnel-animation",
        filename = "__Dimensional-Chests__/graphics/5x5/animation.png",
        width = 192,
        height = 173,
        line_length = 8,
        frame_count = 64,
        animation_speed = 1,
        shift = {0, 0}
    },
    {
        type = "animation",
        name = "grand-entrepot-dimensionnel-animation",
        filename = "__Dimensional-Chests__/graphics/6x6/animation.png",
        width = 192,
        height = 158,
        line_length = 8,
        frame_count = 64,
        animation_speed = 1,
        shift = {0, 0}
    }
})

data:extend({
    -- Coffre dimensionnel 1x1
    {
        type = "linked-container",
        name = "coffre-dimensionnel",
        localised_name = "Coffre dimensionnel",
        icon = "__Dimensional-Chests__/graphics/1x1/icon.png",
        icon_size = 192,
        flags = {"placeable-player", "player-creation"},
        minable = {mining_time = 0.5, result = "coffre-dimensionnel"},
        max_health = 350,
        corpse = "small-remnants",
		collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        inventory_size = 16,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "1MJ"
        },
        energy_usage = "100kW",
        idle_energy_usage = "5kW",
        picture = {
            filename = "__Dimensional-Chests__/graphics/1x1/entity.png",
            width = 192,
            height = 176,
			scale = 0.1667,
            shift = {0,0}
        },
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        circuit_read_contents = true,
        circuit_read_logistics_mode = true
    },

    -- Grand coffre dimensionnel 2x2
    {
        type = "linked-container",
        name = "grand-coffre-dimensionnel",
        localised_name = "Grand coffre dimensionnel",
        icon = "__Dimensional-Chests__/graphics/2x2/icon.png",
        icon_size = 192,
        flags = {"placeable-player", "player-creation"},
        minable = {mining_time = 0.5, result = "grand-coffre-dimensionnel"},
        max_health = 350,
        corpse = "small-remnants",
        collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
		selection_box = {{-1, -1}, {1, 1}},
        inventory_size = 32,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "2MJ"
        },
        energy_usage = "200kW",
        idle_energy_usage = "10kW",
        picture = {
            filename = "__Dimensional-Chests__/graphics/2x2/entity.png",
            width = 192,
            height = 174,
            scale = 0.3333,
            shift = {0,0}
        },
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        circuit_read_contents = true,
        circuit_read_logistics_mode = true
    },

    -- Container dimensionnel 3x3
    {
        type = "linked-container",
        name = "container-dimensionnel",
        localised_name = "Container dimensionnel",
        icon = "__Dimensional-Chests__/graphics/3x3/icon.png",
        icon_size = 192,
        flags = {"placeable-player", "player-creation"},
        minable = {mining_time = 0.5, result = "container-dimensionnel"},
        max_health = 350,
        corpse = "small-remnants",
        collision_box = {{-1.3, -1.3}, {1.3, 1.3}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        inventory_size = 64,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "5MJ"
        },
        energy_usage = "500kW",
        idle_energy_usage = "20kW",
        picture = {
            filename = "__Dimensional-Chests__/graphics/3x3/entity.png",
            width = 192,
            height = 201,
            scale = 0.5,
            shift = {0,0}
        },
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        circuit_read_contents = true,
        circuit_read_logistics_mode = true
    },

    -- Grand container dimensionnel 4x4
    {
        type = "linked-container",
        name = "grand-container-dimensionnel",
        localised_name = "Grand container dimensionnel",
        icon = "__Dimensional-Chests__/graphics/4x4/icon.png",
        icon_size = 192,
        flags = {"placeable-player", "player-creation"},
        minable = {mining_time = 0.5, result = "grand-container-dimensionnel"},
        max_health = 350,
        corpse = "small-remnants",
        collision_box = {{-1.8, -1.8}, {1.8, 1.8}},
		selection_box = {{-2, -2}, {2, 2}},
        inventory_size = 128,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "10MJ"
        },
        energy_usage = "1MW",
        idle_energy_usage = "30kW",
        picture = {
            filename = "__Dimensional-Chests__/graphics/4x4/entity.png",
            width = 192,
            height = 187,
            scale = 0.6667,
            shift = {0,0}
        },
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        circuit_read_contents = true,
        circuit_read_logistics_mode = true
    },

    -- Entrepôt dimensionnel 5x5
    {
        type = "linked-container",
        name = "entrepot-dimensionnel",
        localised_name = "Entrepôt dimensionnel",
        icon = "__Dimensional-Chests__/graphics/5x5/icon.png",
        icon_size = 192,
        flags = {"placeable-player", "player-creation"},
        minable = {mining_time = 0.5, result = "entrepot-dimensionnel"},
        max_health = 350,
        corpse = "small-remnants",
        collision_box = {{-2.3, -2.3}, {2.3, 2.3}},
		selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
        inventory_size = 256,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "20MJ"
        },
        energy_usage = "2MW",
        idle_energy_usage = "40kW",
        picture = {
            filename = "__Dimensional-Chests__/graphics/5x5/entity.png",
            width = 192,
            height = 173,
            scale = 0.8333,
            shift = {0,0}
        },
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        circuit_read_contents = true,
        circuit_read_logistics_mode = true
    },

    -- Grand entrepôt dimensionnel 6x6
    {
        type = "linked-container",
        name = "grand-entrepot-dimensionnel",
        localised_name = "Grand entrepôt dimensionnel",
        icon = "__Dimensional-Chests__/graphics/6x6/icon.png",
        icon_size = 192,
        flags = {"placeable-player", "player-creation"},
        minable = {mining_time = 0.5, result = "grand-entrepot-dimensionnel"},
        max_health = 350,
        corpse = "small-remnants",
        collision_box = {{-2.8, -2.8}, {2.8, 2.8}},
		selection_box = {{-3, -3}, {3, 3}},
        inventory_size = 512,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            buffer_capacity = "40MJ"
        },
        energy_usage = "4MW",
        idle_energy_usage = "60kW",
        picture = {
            filename = "__Dimensional-Chests__/graphics/6x6/entity.png",
            width = 192,
            height = 158,
            shift = {0,0}
        },
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        circuit_read_contents = true,
        circuit_read_logistics_mode = true
    }
})
