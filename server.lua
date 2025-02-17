QBCore = exports['qb-core']:GetCoreObject()


local fishTypes = Config.FishTypes
local fishPrices = Config.FishPrices


RegisterNetEvent('nicks-fishing:sellFish')
AddEventHandler('nicks-fishing:sellFish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local totalEarnings = 0

    for _, fish in pairs(fishTypes) do
        local fishCount = Player.Functions.GetItemByName(fish)
        if fishCount then
            Player.Functions.RemoveItem(fish, fishCount.amount)
            totalEarnings = totalEarnings + (fishCount.amount * fishPrices[fish])
        end
    end

    if totalEarnings > 0 then
        Player.Functions.AddMoney('cash', totalEarnings)
        TriggerClientEvent('QBCore:Notify', src, 'You sold your fish for $' .. totalEarnings .. '.')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You have no fish to sell.')
    end
end)


RegisterNetEvent('nicks-fishing:catchFish')
AddEventHandler('nicks-fishing:catchFish', function(catch)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if catch > 50 then
        local fish = fishTypes[math.random(#fishTypes)]
        if Player.Functions.RemoveItem('fish_bait', 1) then
            Player.Functions.AddItem(fish, 1)
            TriggerClientEvent('QBCore:Notify', src, 'You caught a ' .. fish .. '!')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You do not have bait to fish.')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'No fish caught this time.')
    end
end)

QBCore.Functions.CreateCallback('nicks-fishing:canAfford', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local money = Player.Functions.GetMoney('cash') -- or 'bank' if you prefer
    if money >= 500 then -- set your price here
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('nicks-fishing:giveLicense')
AddEventHandler('nicks-fishing:giveLicense', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('cash', 500) -- or 'bank' if you prefer
    Player.Functions.AddItem('license_fishing', 1)
    TriggerClientEvent('QBCore:Notify', src, 'You bought a fishing license.')
end)

QBCore.Functions.CreateCallback('nicks-fishing:checkLicense', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local license = Player.Functions.GetItemByName('license_fishing')
    if license then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('nicks-fishing:giveBait')
AddEventHandler('nicks-fishing:giveBait', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('cash', 500) -- or 'bank' if you prefer
    Player.Functions.AddItem('fish_bait', 1)
    TriggerClientEvent('QBCore:Notify', src, 'You bought a fishing bait.')
end)

QBCore.Functions.CreateCallback('nicks-fishing:checkBait', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bait = Player.Functions.GetItemByName('fish_bait')
    if bait then
        cb(true)
    else
        cb(false)
    end
end)


RegisterNetEvent('nicks-fishing:giveItem')
AddEventHandler('nicks-fishing:giveItem', function(itemName, itemPrice)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('cash', itemPrice) -- or 'bank' if you prefer
    Player.Functions.AddItem(itemName, 1)
    TriggerClientEvent('QBCore:Notify', src, 'You bought a ' .. itemName .. '.')
end)