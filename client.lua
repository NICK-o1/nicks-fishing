QBCore = exports['qb-core']:GetCoreObject()

local fishing = false
local rodModel = 'prop_fishing_rod_01'
local rodNetId = 'prop_fishing_rod_01'

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
                        TaskPlayAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_a', 8.0, -8.0, -1, 49, 0, false, false, false)

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

local createdObjects = {}

local function createFishingObject(coords, model, heading)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    local object = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
    SetEntityHeading(object, heading)
    FreezeEntityPosition(object, true)
    SetEntityAsMissionEntity(object, true, true)
    table.insert(createdObjects, object)
end

for _, obj in ipairs(Config.ObjectModels) do
    createFishingObject(obj.coords, GetHashKey(obj.model), obj.heading)
end

local objectInteraction = {
    options = {
        {
            event = "nicks-fishing:interactObject",
            icon = "fa-solid fa-fish",
            label = "Start Fishing",
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
    debugPoly = false,
    minZ = 1.0,
    maxZ = 3.0
}, {
    options = {
        {
            event = "nicks-fishing:buyLicense",
            icon = "fa-solid fa-id-card",
            label = "Buy Fishing License",
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
    debugPoly = false,
    minZ = 1.0,
    maxZ = 3.0
}, {
    options = {
        {
            event = "nicks-fishing:buyBait",
            icon = "fa-solid fa-fish",
            label = "Buy Fishing Bait",
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
    debugPoly = false,
    minZ = 1.0,
    maxZ = 3.0
}, {
    options = {
        {
            event = "nicks-fishing:sellFish",
            icon = "fa-solid fa-dollar-sign",
            label = "Sell Fish",
        }
    },
    distance = 2.0
})
