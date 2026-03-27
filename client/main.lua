local QBCore = exports['qb-core']:GetCoreObject()
local isDigging = false

local function CanDig()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    
    local rayHandle = StartShapeTestCapsule(pos.x, pos.y, pos.z + 2.0, pos.x, pos.y, pos.z - 2.0, 0.5, 1, ped, 7)
    local _, hit, _, _, materialHash = GetShapeTestResultIncludingMaterial(rayHandle)

    if Config.Debug then
        print("Material Hash: " .. materialHash)
    end

    if Config.SandHashes[materialHash] then
        return true
    end
    return false
end

local function StartDiggingProcess()
    if isDigging then
        return lib.notify({
            title = _U('title_digging'),
            description = _U('already_digging'),
            type = 'warning'
        })
    end

    isDigging = true

    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, true) then
        isDigging = false
        return lib.notify({
            title = _U('title_digging'),
            description = _U('cannot_dig_in_car'),
            type = 'error'
        })
    end

    if not CanDig() then
        isDigging = false
        return lib.notify({
            title = _U('title_digging'),
            description = _U('bad_ground'),
            type = 'error'
        })
    end

    local skillCheckSuccess = lib.skillCheck({'easy', {areaSize = 30, speedMultiplier = 1}, {areaSize = 40, speedMultiplier = 1}}, {'e'})

    if not skillCheckSuccess then
        isDigging = false
        return lib.notify({
            title = _U('title_digging'),
            description = _U('skillcheck_failed'),
            type = 'error'
        })
    end

    lib.requestAnimDict(Config.AnimDict)
    TaskPlayAnim(ped, Config.AnimDict, Config.AnimLib, 8.0, -8.0, -1, 1, 0, false, false, false)
    
    local shovelModel = `prop_tool_shovel`
    lib.requestModel(shovelModel)
    local shovelObj = CreateObject(shovelModel, 0, 0, 0, true, true, true)
    
    AttachEntityToEntity(shovelObj, ped, GetPedBoneIndex(ped, 28422), 
        0.03, 0.01, 0.2,
        0.0, 0.0, -9.5,
        true, true, false, true, 1, true
    )

    local progressSuccess = lib.progressCircle({
        duration = Config.DigTime,
        label = _U('digging_progress'),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
    })

    DeleteEntity(shovelObj)
    ClearPedTasks(ped)

    isDigging = false 

    if progressSuccess then
        TriggerServerEvent('v-digging:server:finishDig')
    else
        lib.notify({
            title = _U('title_digging'),
            description = _U('digging_canceled'),
            type = 'inform'
        })
    end
end

exports('useShovel', function(data, slot)
    StartDiggingProcess()
end)

RegisterNetEvent('v-digging:client:startDigging', function()
    StartDiggingProcess()
end)