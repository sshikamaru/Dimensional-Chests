-- items.lua

data:extend({
    {
        type = "item",
        name = "coffre-dimensionnel",
        localised_name = "Coffre Dimensionnel",
        localised_description = "Un coffre capable de se connecter au réseau dimensionnel.",
        icon = "__Dimensional-Chests__/graphics/1x1/icon.png",
        icon_size = 192,
        subgroup = "storage",
        order = "a[chest]-1",
        place_result = "coffre-dimensionnel",
        stack_size = 50
    },
    {
        type = "item",
        name = "grand-coffre-dimensionnel",
        localised_name = "Grand Coffre Dimensionnel",
        localised_description = "Une version plus grande du coffre dimensionnel.",
        icon = "__Dimensional-Chests__/graphics/2x2/icon.png",
        icon_size = 192,
        subgroup = "storage",
        order = "a[chest]-2",
        place_result = "grand-coffre-dimensionnel",
        stack_size = 40
    },
    {
        type = "item",
        name = "container-dimensionnel",
        localised_name = "Container Dimensionnel",
        localised_description = "Un container dimensionnel pour stocker plus d'objets.",
        icon = "__Dimensional-Chests__/graphics/3x3/icon.png",
        icon_size = 192,
        subgroup = "storage",
        order = "a[chest]-3",
        place_result = "container-dimensionnel",
        stack_size = 30
    },
    {
        type = "item",
        name = "grand-container-dimensionnel",
        localised_name = "Grand Container Dimensionnel",
        localised_description = "Un container dimensionnel encore plus grand.",
        icon = "__Dimensional-Chests__/graphics/4x4/icon.png",
        icon_size = 192,
        subgroup = "storage",
        order = "a[chest]-4",
        place_result = "grand-container-dimensionnel",
        stack_size = 20
    },
    {
        type = "item",
        name = "entrepot-dimensionnel",
        localised_name = "Entrepôt Dimensionnel",
        localised_description = "Un entrepôt dimensionnel pour le stockage massif.",
        icon = "__Dimensional-Chests__/graphics/5x5/icon.png",
        icon_size = 192,
        subgroup = "storage",
        order = "a[chest]-5",
        place_result = "entrepot-dimensionnel",
        stack_size = 10
    },
    {
        type = "item",
        name = "grand-entrepot-dimensionnel",
        localised_name = "Grand Entrepôt Dimensionnel",
        localised_description = "Le plus grand entrepôt dimensionnel disponible.",
        icon = "__Dimensional-Chests__/graphics/6x6/icon.png",
        icon_size = 192,
        subgroup = "storage",
        order = "a[chest]-6",
        place_result = "grand-entrepot-dimensionnel",
        stack_size = 5
    }
})
