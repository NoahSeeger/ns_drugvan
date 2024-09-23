ESX = exports["es_extended"]:getSharedObject()

-- Table to track players who are currently cooking
local activeCookingPlayers = {}

RegisterServerEvent("ns_drugvan:startCooking")
AddEventHandler("ns_drugvan:startCooking", function(auto)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Check if the player is already cooking
    if activeCookingPlayers[_source] then
        TriggerClientEvent('ox_lib:notify', _source, {
            title = "Meth Kochen",
            icon = "syringe",
            position = "bottom-right",
            description = "Du kochst bereits!",
            type = "error"
        })
        return
    end

    -- Mark the player as cooking
    activeCookingPlayers[_source] = true

    local cookingConfig = auto and Config.Cooking.Auto or Config.Cooking.Manual
    local delay = cookingConfig.Delay

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(auto and delay or math.random(delay.minDelay, delay.maxDelay))

            -- Check if player is still in the van's area
            local isInVanArea = lib.callback.await("ns_drugvan:stillAtVan", _source)
            if not isInVanArea then
                TriggerClientEvent('ox_lib:notify', _source, {
                    title = "Meth Kochen",
                    icon = "syringe",
                    position = "bottom-right",
                    description = "Kochen abgebrochen. Du hast den Van verlassen!",
                    type = "error"
                })
                break
            end

            local canCook = true
            for _, ingredient in ipairs(cookingConfig.Ingredients) do
                local itemCount = xPlayer.getInventoryItem(ingredient.name).count
                if itemCount < ingredient.amount then
                    canCook = false
                    break
                end
            end

            if canCook then
                for _, ingredient in ipairs(cookingConfig.Ingredients) do
                    xPlayer.removeInventoryItem(ingredient.name, ingredient.amount)
                end

                if not auto then
                    local skillCheck = lib.callback.await("ns_drugvan:skillCheck", _source, cookingConfig.SkillCheck.Difficulty, cookingConfig.SkillCheck.Inputs)
                    if not skillCheck then
                        --POLIZEIDISPATCH!!
                        TriggerClientEvent('ox_lib:notify', _source, {
                            title = "Meth Kochen",
                            icon = "syringe",
                            position = "bottom-right",
                            description = "Skill Check failed. Police alerted!",
                            type = "error"
                        })
                        break
                    end
                end

                local result = cookingConfig.Result
                local resultAmount = math.random(result.minAmount, result.maxAmount)
                xPlayer.addInventoryItem(result.name, resultAmount)

                TriggerClientEvent('ox_lib:notify', _source, {
                    title = "Meth Kochen",
                    icon = "syringe",
                    position = "bottom-right",
                    description = 'Du hast ' .. resultAmount .. ' ' .. result.name .. ' gekocht!',
                    type = "inform"
                })
            else
                TriggerClientEvent('ox_lib:notify', _source, {
                    title = "Meth Kochen",
                    icon = "syringe",
                    position = "bottom-right",
                    description = "Nicht genug Zutaten.",
                    type = "error"
                })
                break
            end
        end

        -- Unmark the player as cooking when the process ends
        activeCookingPlayers[_source] = nil
    end)
end)

RegisterServerEvent("ns_drugvan:stopCooking")
AddEventHandler("ns_drugvan:stopCooking", function()
    local _source = source
    activeCookingPlayers[_source] = nil
    TriggerClientEvent('ox_lib:notify', _source, {
        title = "Meth Kochen",
        icon = "syringe",
        position = "bottom-right",
        description = "Kochen gestoppt.",
        type = "inform"
    })
end)
