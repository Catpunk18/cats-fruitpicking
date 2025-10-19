local treeStates = {} 

CreateThread(function()
    for fruitIndex, treeGroup in ipairs(Config.Trees) do
        for coordIndex, coord in ipairs(treeGroup.coords) do
            local treeId = ("%s_%s"):format(fruitIndex, coordIndex)

            exports.ox_target:addSphereZone({
                coords = coord,
                radius = 1.5,
                options = {
                    {
                        name = 'harvest_' .. treeGroup.fruit .. '_' .. coordIndex,
                        label = ('Harvest %s'):format(treeGroup.label),
                        icon = 'fa-solid fa-apple-whole',
                        onSelect = function()
                            HarvestTree(treeId, treeGroup)
                        end
                    }
                },
                debug = false
            })
        end
    end
end)

function HarvestTree(treeId, treeGroup)
    local now = GetGameTimer()
    if treeStates[treeId] and (now - treeStates[treeId]) < (Config.TreeCooldown * 1000) then
        lib.notify({
            title = 'Tree not ready',
            description = 'This tree needs more time to regrow fruit.',
            type = 'error'
        })
        return
    end

    local ped = PlayerPedId()
    local anim = treeGroup.anim

    RequestAnimDict(anim.dict)
    while not HasAnimDictLoaded(anim.dict) do Wait(0) end

    TaskPlayAnim(ped, anim.dict, anim.name, 8.0, -8.0, -1, 49, 0, false, false, false)

    local success = lib.progressBar({
        duration = 5000,
        label = ('Picking %s...'):format(treeGroup.fruit),
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true }
    })

    ClearPedTasks(ped)

    if success then
        TriggerServerEvent('cats-fruitpicking:giveFruit', treeGroup.fruit)
        treeStates[treeId] = GetGameTimer()
        lib.notify({
            title = 'Success',
            description = ('You harvested a %s!'):format(treeGroup.fruit),
            type = 'success'
        })
    else
        lib.notify({
            title = 'Cancelled',
            description = 'You stopped harvesting.',
            type = 'error'
        })
    end
end

RegisterNetEvent('cats-fruitpicking:clientNotify', function(data)
    if not data then return end
    lib.notify({
        title = data.title or 'Notification',
        description = data.description or '',
        type = data.type or 'inform'
    })
end)