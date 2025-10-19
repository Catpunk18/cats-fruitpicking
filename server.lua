RegisterNetEvent('cats-fruitpicking:giveFruit', function(fruit)
    local src = source
    local reward = Config.FruitRewards[fruit]
    if not reward then return end

    local ox = exports.ox_inventory
    local canCarry = true

    if ox and ox.CanCarryItem then
        local ok, resp = pcall(function()
            return ox:CanCarryItem(src, reward.item, reward.amount)
        end)
        if ok and resp == false then
            canCarry = false
        elseif not ok then
        end
    end

    if not canCarry then
        TriggerClientEvent('cats-fruitpicking:clientNotify', src, {
            title = 'Inventory Full',
            description = ('You can’t carry any more %ss.'):format(reward.item),
            type = 'error'
        })
        return
    end

    local success, response = pcall(function()
        return ox:AddItem(src, reward.item, reward.amount)
    end)

    if not success or not response then
        TriggerClientEvent('cats-fruitpicking:clientNotify', src, {
            title = 'Error',
            description = ('Failed to add %s: %s'):format(reward.item, tostring(response)),
            type = 'error'
        })
        return
    end
end)
