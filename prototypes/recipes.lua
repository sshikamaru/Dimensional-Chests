--recipes.lua

data:extend({
    -- Coffre dimensionnel 1x1
    {
        type = "recipe",
        name = "coffre-dimensionnel",
        localised_name = "Coffre dimensionnel",
        enabled = false,
        ingredients = {
            {type = "item", name = "steel-chest", amount = 1},
            {type = "item", name = "electronic-circuit", amount = 4},
            {type = "item", name = "copper-cable", amount = 10}
        },
        results = {
            {type = "item", name = "coffre-dimensionnel", amount = 1}
        }
    },

    -- Grand coffre dimensionnel 2x2
    {
        type = "recipe",
        name = "grand-coffre-dimensionnel",
        localised_name = "Grand coffre dimensionnel",
        enabled = false,
        ingredients = {
            {type = "item", name = "coffre-dimensionnel", amount = 1},
            {type = "item", name = "electronic-circuit", amount = 4},
            {type = "item", name = "steel-plate", amount = 20}
        },
        results = {
            {type = "item", name = "grand-coffre-dimensionnel", amount = 1}
        }
    },

    -- Container dimensionnel 3x3
    {
        type = "recipe",
        name = "container-dimensionnel",
        localised_name = "Container dimensionnel",
        enabled = false,
        ingredients = {
            {type = "item", name = "grand-coffre-dimensionnel", amount = 1},
            {type = "item", name = "electronic-circuit", amount = 8},
            {type = "item", name = "advanced-circuit", amount = 4},
            {type = "item", name = "steel-plate", amount = 30}
        },
        results = {
            {type = "item", name = "container-dimensionnel", amount = 1}
        }
    },

    -- Grand container dimensionnel 4x4
    {
        type = "recipe",
        name = "grand-container-dimensionnel",
        localised_name = "Grand container dimensionnel",
        enabled = false,
        ingredients = {
            {type = "item", name = "container-dimensionnel", amount = 1},
            {type = "item", name = "electronic-circuit", amount = 16},
            {type = "item", name = "advanced-circuit", amount = 8},
            {type = "item", name = "steel-plate", amount = 40}
        },
        results = {
            {type = "item", name = "grand-container-dimensionnel", amount = 1}
        }
    },

    -- Entrepôt dimensionnel 5x5
    {
        type = "recipe",
        name = "entrepot-dimensionnel",
        localised_name = "Entrepôt dimensionnel",
        enabled = false,
        ingredients = {
            {type = "item", name = "grand-container-dimensionnel", amount = 1},
            {type = "item", name = "electronic-circuit", amount = 32},
            {type = "item", name = "advanced-circuit", amount = 16},
            {type = "item", name = "processing-unit", amount = 8},
            {type = "item", name = "steel-plate", amount = 50}
        },
        results = {
            {type = "item", name = "entrepot-dimensionnel", amount = 1}
        }
    },

    -- Grand entrepôt dimensionnel 6x6
    {
        type = "recipe",
        name = "grand-entrepot-dimensionnel",
        localised_name = "Grand entrepôt dimensionnel",
        enabled = false,
        ingredients = {
            {type = "item", name = "entrepot-dimensionnel", amount = 1},
            {type = "item", name = "electronic-circuit", amount = 64},
            {type = "item", name = "advanced-circuit", amount = 32},
            {type = "item", name = "processing-unit", amount = 16},
            {type = "item", name = "steel-plate", amount = 60}
        },
        results = {
            {type = "item", name = "grand-entrepot-dimensionnel", amount = 1}
        }
    }
})
