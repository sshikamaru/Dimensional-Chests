data:extend({
    {
        type = "technology",
        name = "communicating-chest-tech-1",
        localised_name = "Technologie Coffre Dimensionnel",
        localised_description = "Permet de construire le coffre dimensionnel basique.",
        icon = "__Dimensional-Chests__/graphics/1x1/icon.png",
        icon_size = 192,
        unit = {
            count = 10,
            ingredients = {{"automation-science-pack", 1}},
            time = 20
        },
        effects = {
            {type = "unlock-recipe", recipe = "coffre-dimensionnel"}
        },
        prerequisites = {"electronics", "automation", "logistics", "steel-processing", "fast-inserter"}
    },
    {
        type = "technology",
        name = "communicating-chest-tech-2",
        localised_name = "Technologie Grand Coffre Dimensionnel",
        localised_description = "Permet de construire le grand coffre dimensionnel.",
        icon = "__Dimensional-Chests__/graphics/2x2/icon.png",
        icon_size = 192,
        unit = {
            count = 20,
            ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
            time = 25
        },
        effects = {
            {type = "unlock-recipe", recipe = "grand-coffre-dimensionnel"}
        },
        prerequisites = {"communicating-chest-tech-1", "logistics-2", "circuit-network"}
    },
    {
        type = "technology",
        name = "communicating-chest-tech-3",
        localised_name = "Technologie Container Dimensionnel",
        localised_description = "Permet de construire le container dimensionnel.",
        icon = "__Dimensional-Chests__/graphics/3x3/icon.png",
        icon_size = 192,
        unit = {
            count = 30,
            ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}},
            time = 30
        },
        effects = {
            {type = "unlock-recipe", recipe = "container-dimensionnel"}
        },
        prerequisites = {"communicating-chest-tech-2", "bulk-inserter", "advanced-circuit", "automation-2", "electric-energy-distribution-1"}
    },
    {
        type = "technology",
        name = "communicating-chest-tech-4",
        localised_name = "Technologie Grand Container Dimensionnel",
        localised_description = "Permet de construire le grand container dimensionnel.",
        icon = "__Dimensional-Chests__/graphics/4x4/icon.png",
        icon_size = 192,
        unit = {
            count = 40,
            ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}, {"production-science-pack", 1}},
            time = 35
        },
        effects = {
            {type = "unlock-recipe", recipe = "grand-container-dimensionnel"}
        },
        prerequisites = {"communicating-chest-tech-3"}
    },
    {
        type = "technology",
        name = "communicating-chest-tech-5",
        localised_name = "Technologie Entrepôt Dimensionnel",
        localised_description = "Permet de construire l'entrepôt dimensionnel.",
        icon = "__Dimensional-Chests__/graphics/5x5/icon.png",
        icon_size = 192,
        unit = {
            count = 50,
            ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}, {"production-science-pack", 1}},
            time = 40
        },
        effects = {
            {type = "unlock-recipe", recipe = "entrepot-dimensionnel"}
        },
        prerequisites = {"communicating-chest-tech-4", "logistics-3", "processing-unit", "electric-energy-distribution-2"}
    },
    {
        type = "technology",
        name = "communicating-chest-tech-6",
        localised_name = "Technologie Grand Entrepôt Dimensionnel",
        localised_description = "Permet de construire le grand entrepôt dimensionnel.",
        icon = "__Dimensional-Chests__/graphics/6x6/icon.png",
        icon_size = 192,
        unit = {
            count = 60,
            ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}, {"production-science-pack", 1}, {"utility-science-pack", 1}},
            time = 45
        },
        effects = {
            {type = "unlock-recipe", recipe = "grand-entrepot-dimensionnel"}
        },
        prerequisites = {"communicating-chest-tech-5", "automation-3"}
    }
})
