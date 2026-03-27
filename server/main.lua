local QBCore = exports['qb-core']:GetCoreObject()

local WebhookURL = 'WEBHOOK'  -- Add your webhook here

local function LogToDiscord(title, message, color)
    if WebhookURL == 'WEBHOOK' or WebhookURL == '' then return end
    
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. title .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Digging • " .. os.date("%d.%m.%Y klo %H:%M"),
            },
        }
    }

    PerformHttpRequest(WebhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = "Digging Logs", 
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('v-digging:server:finishDig', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local playerName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    local playerID = src
    local license = QBCore.Functions.GetIdentifier(src, 'license')

    local items = exports.ox_inventory:GetInventoryItems(src)
    local shovelSlot = nil
    
    for _, item in pairs(items) do
        if item.name == Config.ShovelItem then
            shovelSlot = item
            break
        end
    end

    if not shovelSlot then return end

    local currentDurability = shovelSlot.metadata.durability or 100
    local newDurability = currentDurability - Config.DurabilityLoss

    if newDurability <= 0 then
        exports.ox_inventory:RemoveItem(src, Config.ShovelItem, 1, nil, shovelSlot.slot)
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('title_digging'),
            description = _U('shovel_broke'),
            type = 'error'
        })

        LogToDiscord(_U('log_shovel_broke_title'), _U('log_shovel_broke_desc', playerName, playerID), 15548997)

    else
        shovelSlot.metadata.durability = newDurability
        exports.ox_inventory:SetMetadata(src, shovelSlot.slot, shovelSlot.metadata)
    end

    local randomRoll = math.random(1, 100)
    local currentThreshold = 0
    local gotSomething = false

    for _, loot in ipairs(Config.LootTable) do
        currentThreshold = currentThreshold + loot.chance

        if randomRoll <= currentThreshold then
            local amount = math.random(loot.min, loot.max)
            
            if exports.ox_inventory:CanCarryItem(src, loot.item, amount) then
                exports.ox_inventory:AddItem(src, loot.item, amount)
                
                TriggerClientEvent('ox_lib:notify', src, {
                    title = _U('title_find'),
                    description = _U('found_item', amount, loot.label),
                    type = 'success'
                })
                
                LogToDiscord(_U('log_found_title'), _U('log_found_desc', playerName, playerID, loot.label, loot.item, amount), 5763719)

                gotSomething = true
            else
                 TriggerClientEvent('ox_lib:notify', src, {
                    title = _U('title_inventory'),
                    description = _U('inventory_full'),
                    type = 'error'
                })

                LogToDiscord(_U('log_full_title'), _U('log_full_desc', playerName, playerID, loot.label), 16776960)
            end
            
            break 
        end
    end

    if not gotSomething then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _U('title_digging'),
            description = _U('found_nothing'),
            type = 'inform'
        })

        LogToDiscord(_U('log_nothing_title'), _U('log_nothing_desc', playerName, playerID), 9807270)
    end
end)