Config = {}

Config.Van = "JOURNEY"

Config.Cooking = {
    Auto = {
        Delay = 1000 * 15, -- Longer delay for automatic cooking
        Ingredients = {
            {name = 'copper', amount = 1},
            {name = 'diamond', amount = 1}
        },
        Result = {
            name = 'lockpick',
            minAmount = 8, -- Lower minimum yield
            maxAmount = 14  -- Lower maximum yield
        }
    },
    Manual = {
        Delay = {minDelay = 1000 * 5, maxDelay = 1000 * 10}, -- Shorter delay for manual cooking
        Ingredients = {
            {name = 'copper', amount = 1},
            {name = 'diamond', amount = 1}
        },
        Result = {
            name = 'lockpick',
            minAmount = 12, -- Higher minimum yield
            maxAmount = 20 -- Higher maximum yield
        },
        SkillCheck = {
            Inputs = {'w', 'a', 's', 'd'},
            Difficulty = "easy" -- Increased difficulty for more engagement
        }
    }
}
