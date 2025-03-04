local QBCore = exports['qb-core']:GetCoreObject()

local fishing = false
local rodModel = 'prop_fishing_rod_02'
local rodNetId = NetworkGetNetworkIdFromEntity(rod)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('nicks-fishing:startFishing')
AddEventHandler('nicks-fishing:startFishing', function()
    local ped = PlayerPedId()
    QBCore.Functions.TriggerCallback('nicks-fishing:checkLicense', function(hasLicense)
        if hasLicense then
            QBCore.Functions.TriggerCallback('nicks-fishing:checkBait', function(hasBait)
                if hasBait then
                    if not fishing then
                        fishing = true
                        QBCore.Functions.Notify('You started fishing!')

                        loadAnimDict('amb@world_human_stand_fishing@idle_a')
                        TaskPlayAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 8.0, -8.0, -1, 49, 0, false, false, false)

                        RequestModel(rodModel)
                        while not HasModelLoaded(rodModel) do
                            Citizen.Wait(100)
                        end
                        local rod = CreateObject(rodModel, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(rod, ped, GetPedBoneIndex(ped, 60309), 0.1, -0.15, 0.0, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
                        rodNetId = NetworkGetNetworkIdFromEntity(rod)

                        Citizen.Wait(5000) -- Simulate fishing time

                        local catch = math.random(1, 100)
                        TriggerServerEvent('nicks-fishing:catchFish', catch)

                        DeleteEntity(NetworkGetEntityFromNetworkId(rodNetId))
                        ClearPedTasks(ped)

                        fishing = false
                    else
                        QBCore.Functions.Notify('You are already fishing.')
                    end
                else
                    QBCore.Functions.Notify('You need bait to fish.')
                end
            end)
        else
            QBCore.Functions.Notify('You need a fishing license to fish.')
        end
    end)
end)

-- Declare createdObjects as a global variable
createdObjects = {}

local function createFishingObject(coords, model, heading)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    local object = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
    SetEntityHeading(object, heading)
    FreezeEntityPosition(object, true)
    SetEntityAsMissionEntity(object, true, true)
    SetEntityDrawOutline(object, Config.SetEntityDrawOutline)
    SetEntityDrawOutlineColor(table.unpack(Config.SetEntityDrawOutlineColor))
    table.insert(createdObjects, object)
end

-- Check if Config.ObjectModels is defined before iterating through it
if Config.ObjectModels then
    for _, obj in ipairs(Config.ObjectModels) do
        createFishingObject(obj.coords, GetHashKey(obj.model), obj.heading)
    end
else
    print("Config.ObjectModels is nil!")
end


local objectInteraction = {
    options = {
        {
            event = "nicks-fishing:interactObject",
            icon = "fa-solid fa-fish",
            label = "Start Fishing",
            iconColor = Config.ColorPalette.green,
        }
    },
    distance = 2.0
}

local objectModelsList = {}
for _, obj in ipairs(Config.ObjectModels) do
    table.insert(objectModelsList, GetHashKey(obj.model))
end

exports['qtarget']:AddTargetModel(objectModelsList, objectInteraction)

RegisterNetEvent("nicks-fishing:interactObject")
AddEventHandler("nicks-fishing:interactObject", function()
TriggerEvent("nicks-fishing:startFishing")
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, object in ipairs(createdObjects) do
            if DoesEntityExist(object) then
                DeleteEntity(object)
            end
        end
    end
end)

Citizen.CreateThread(function()
    for _, spot in ipairs(Config.FishingSpots) do
        local blip = AddBlipForCoord(spot.x, spot.y, spot.z)
        SetBlipSprite(blip, 762) -- Set blip sprite, e.g., 68 for fishing spot
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 3) -- Set blip color
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Fishing Spot")
        EndTextCommandSetBlipName(blip)
    end
end)

exports['qtarget']:AddBoxZone("LicensePurchase", Config.LicensePurchaseLocation, 1.0, 1.0, {
    name = "LicensePurchase",
    heading = 180,
    debugPoly = Config.DebugPoly,
    minZ = 1.0,
    maxZ = 3.0
}, {
    options = {
        {
            event = "nicks-fishing:buyLicense",
            icon = "fa-solid fa-id-card",
            label = "Buy Fishing License",
            iconColor = Config.ColorPalette.orange,
        }
    },
    distance = 2.0
})

RegisterNetEvent('nicks-fishing:buyLicense')
AddEventHandler('nicks-fishing:buyLicense', function()
    QBCore.Functions.TriggerCallback('nicks-fishing:canAfford', function(canAfford)
        if canAfford then
            TriggerServerEvent('nicks-fishing:giveLicense')
        else
            QBCore.Functions.Notify('You do not have enough money to buy a fishing license.')
        end
    end)
end)

exports['qtarget']:AddBoxZone("BaitPurchase", Config.BaitPurchaseLocation, 1.0, 1.0, {
    name = "BaitPurchase",
    heading = 180,
    debugPoly = Config.DebugPoly,
    minZ = 1.0,
    maxZ = 3.0
}, {
    options = {
        {
            event = "nicks-fishing:buyBait",
            icon = "fa-solid fa-fish",
            label = "Buy Fishing Bait",
            iconColor = Config.ColorPalette.red,
        }
    },
    distance = 2.0
})

RegisterNetEvent('nicks-fishing:buyBait')
AddEventHandler('nicks-fishing:buyBait', function()
    QBCore.Functions.TriggerCallback('nicks-fishing:canAfford', function(canAfford)
        if canAfford then
            TriggerServerEvent('nicks-fishing:giveBait')
        else
            QBCore.Functions.Notify('You do not have enough money to buy a fishing bait.')
        end
    end)
end)

RegisterNetEvent('nicks-fishing:sellFish')
AddEventHandler('nicks-fishing:sellFish', function()
    TriggerServerEvent('nicks-fishing:sellFish')
end)

exports['qtarget']:AddBoxZone("FishSellingPoint", Config.SellingPointLocation, 1.0, 1.0, {
    name = "FishSellingPoint",
    heading = 45,
    blip = 1,
    debugPoly = Config.DebugPoly,
    minZ = 1.0,
    maxZ = 3.0
}, {
    options = {
        {
            event = "nicks-fishing:sellFish",
            icon = "fa-solid fa-dollar-sign",
            label = "Sell Fish",
            iconColor = Config.ColorPalette.yellow,
        }
    },
    distance = 2.0
})

 
Citizen.CreateThread(function()

    for _, info in pairs(Config.Blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)
