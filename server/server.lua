_Framework = nil
if framework == 'esx' then
    _Framework = exports["es_extended"]:getSharedObject()
elseif framework == 'qb' then
    _Framework = exports['qb-core']:GetCoreObject()
end

lib.versionCheck('OppoNoppo/op-vehlock')

local lockedVehicles = nil

function getLocks()
    local r = MySQL.query.await('SELECT * FROM `'..('%s'):format(dbTableLocks)..'`')
    return r
end

lib.callback.register('op-vehlock:getLocks', function()
    return getLocks()
end)

lib.callback.register('op-vehlock:getVehState', function(source, plate)
    local r = false
    r = MySQL.single.await('SELECT state FROM `'..('%s'):format(dbTableLocks)..'` WHERE plate = ?', {plate})
    if r then
        if r.state == 'true' then
            r = true
        else
            r = false
        end
    else
        r = false
    end
    return r
end)

lib.callback.register('op-vehlock:updateLock', function(source, plate, state)
    local r = false
    local r1 = MySQL.single.await('SELECT * FROM `'..('%s'):format(dbTableLocks)..'` WHERE plate = ?',{plate})
    local r2
    if r1 then
        r2 = MySQL.update.await('UPDATE `'..('%s'):format(dbTableLocks)..'` SET state = ? WHERE plate = ?', {state, plate})
        if r2 then
            r = true
        end
    else
        r2 = MySQL.insert.await('INSERT INTO `'..('%s'):format(dbTableLocks)..'` (plate, state) VALUES (?,?)', {plate, state})
        if r2 then
            r = true
        end
    end
    return r
end)

--[[

#
#   Keys
#

]]

lib.callback.register('op-vehlock:giveKeys', function(source, plate, target)
    local r = false
    local r2 = false
    if useKeyAsItem then
        local q = MySQL.query.await('SELECT * FROM `'..('%s'):format(dbTableKeys)..'` WHERE plate = ?', {plate})
        if #q > 0 then
            -- Key already exists
            local targetKey = exports['ox_inventory']:Search(target, 'count', 'car_keys', {key_combo = q[1]['key_combo']})
            if targetKey then
                r = false
            else
                exports['ox_inventory']:AddItem(target, 'car_keys', 1, {type = plate, key_combo = q[1]['key_combo']}, nil, function(success, response)
                    if success then
                        r = true
                    else
                        r = 'itemnotCreated'
                    end
                end)
            end
        else
            -- No current key data
            local keycombo = 'KEY-'..math.random(000000, 999999)
            local keygen = MySQL.insert.await('INSERT INTO `'..('%s'):format(dbTableKeys)..'` (`plate`, `key_combo`) VALUES (?,?)', {plate, keycombo})
            if keygen ~= false then
                exports['ox_inventory']:AddItem(target, 'car_keys', 1, {type = plate, key_combo = keycombo}, nil, function(success, response)
                    if success then
                        r = true
                    else
                        r = 'itemnotCreated'
                    end
                end)
            else
                r = false
            end
        end
    else
        r2 = MySQL.single.await('SELECT * FROM `'..('%s'):format(dbTableKeys)..'` WHERE plate = ? AND identifier = ?', {plate, GetPlayerIden(target)})
        if r2 == nil then
            r = MySQL.insert.await('INSERT INTO `'..('%s'):format(dbTableKeys)..'` (plate, identifier) VALUES (?,?)', {plate, GetPlayerIden(target)})
            if r ~= false then
                r = true
            end
        else
            r = false
        end
    end
    return r
end)

RegisterNetEvent('op-vehlock:removeKeys', function(source, data)
    MySQL.query('DELETE FROM `'..('%s'):format(dbTableKeys)..'` WHERE plate = ? AND identifier = ?', {data.plate, data.identifier}, function(result)
        if result then
            r = true
        end
    end)
end)

RegisterNetEvent('op-vehlock:removeKeysID', function(plate, playerId)
    MySQL.query('DELETE FROM `'..('%s'):format(dbTableKeys)..'` WHERE plate = ? AND identifier = ?', {plate, GetPlayerIden(playerId)})
end)

RegisterNetEvent('op-vehlock:wipeKeys', function(plate)
    MySQL.query('DELETE FROM `'..('%s'):format(dbTableKeys)..'` WHERE plate = ?', {plate}, function(result)
        if result then
            r = true
        end
    end)
end)

RegisterNetEvent('op-vehlock:wipeKeys:ALL', function()
    local r = MySQL.query('DELETE FROM `'..('%s'):format(dbTableKeys)..'`', {})
end)

lib.callback.register('op-vehlock:hasKey', function(source, plate, identifier, isPlayerID)
    if isPlayerID then
        identifier = GetPlayerIden(identifier)
    end
    if not identifier then
        identifier = GetPlayerIden(source)
    end
    local r = false
    if useKeyAsItem then
        local qr = MySQL.query.await('SELECT * FROM `'..('%s'):format(dbTableKeys)..'` WHERE `plate` = ?', {plate})
        if qr then
            local hasItem = exports['ox_inventory']:Search(source, 'count', 'car_keys', {key_combo = qr[1]['key_combo']})
            if hasItem > 0 then
                r = true
            end
        end
    else
        r = MySQL.single.await('SELECT `plate`, `identifier` FROM `'..('%s'):format(dbTableKeys)..'` WHERE `identifier` = ? AND `plate` = ?', {identifier, plate})
        if r then
            if r.identifier == identifier then
                r = true
            end
        end
    end
    return r
end)

lib.callback.register('op-vehlock:getKeysOnPlate', function(source, plate)
    r = MySQL.query.await('SELECT * FROM `'..('%s'):format(dbTableKeys)..'` WHERE plate = ?', {plate})
    if r then
        return r
    else
        return false
    end
end)

RegisterNetEvent('op-vehlock:removeKeyFromPlate', function(data)
    local plate = data.plate
    local identifier = data.identifier
    MySQL.query('DELETE FROM `'..('%s'):format(dbTableKeys)..'` WHERE plate = ? AND identifier = ?', {plate, identifier})
end)

lib.callback.register('op-vehlock:getPlayerNameFromIdentifier', function(source,identifier)
    local r = MySQL.single.await('SELECT firstname, lastname FROM users WHERE identifier = ?', {identifier})
    if  r then
        r = r.firstname .. ' ' .. r.lastname
    else
        r = false
    end
    return r
end)

lib.callback.register('op-vehlock:isOwner', function(source, plate)
    local xPlayer = GetPlayerIden(source)
    local r = false
    r = MySQL.single.await('SELECT owner FROM `owned_vehicles` WHERE plate = ?', {plate})
    if r then
        if r.owner == xPlayer then
            r = true
        else
            r = false
        end
    else
        r = false
    end

    return r
end)

RegisterNetEvent('op-vehlock:addJobCar', function(plate, job, grade)

end)

RegisterNetEvent('op-vehlock:removeJobCar', function(plate, job, grade)

end)

--[[

#
#   While loops
#

]]

local function wipeLock(data)
    if data then
        local t = MySQL.query.await('DELETE FROM `'..('%s'):format(dbTableLocks)..'` WHERE plate = ?', {data})
        if t then
            if consolePrinting then print(('[^6op-vehlock^0] Plate: ^6%s^0 has been removed due to not being in the map anymore'):format(data)) end
        end
    end
end

local function checkLocks()
    if consolePrinting then print(('[^6op-vehlock^0] Cleaning up database table `^6%s^0`'):format(dbTableLocks)) end
    local tempLockedVehs = getLocks()
    local vehicles = GetAllVehicles()
    local vehiclePlates = {}
    for i=1, #vehicles do
        table.insert(vehiclePlates, Trim(GetVehicleNumberPlateText(vehicles[i])))
    end
    for i=1, #tempLockedVehs do
        local plate = Trim(tempLockedVehs[i].plate)
        for o=1, #vehiclePlates do
            if vehiclePlates[o] == plate then
                table.remove(tempLockedVehs, i)
            end
        end
    end
    for i=1, #tempLockedVehs do
        wipeLock(tempLockedVehs[i].plate)
    end
    if consolePrinting then print('[^6op-vehlock^0] Database table cleanup has been completed. ^6'..#tempLockedVehs..'^0 plates have been removed.' ) end
end

CreateThread(function()
	while true do
        lockedVehicles = getLocks()
		TriggerClientEvent('op-vehlock:UpdateClientLocks', -1, lockedVehicles)
		Wait(updateTimer*1000)
	end
end)

CreateThread(function()
    while true do
        lockedVehicles = getLocks()
        checkLocks()
        Wait(cleanupTimer*1000)
    end
end)

--[[

#
#   Commands
#

]]

if enableKeys then
    lib.addCommand(false, {'givekeys'}, function(source, args)
        TriggerClientEvent('op-vehlock:giveKeys', source, args.target)
    end, {'target:number'})

    lib.addCommand(false, {'removeKeys'}, function(source)
        TriggerClientEvent('op-vehlock:removeKeys', source)
    end)

    lib.addCommand('group.admin', {'wipekeys'}, function(source, args)
        TriggerEvent('op-vehlock:wipeKeys', args.plate)
    end, {'plate:string'})
end
--[[

#
#   Initializing
#

]]

CreateThread(function()
    if wipeKeysOnStartup then
        TriggerEvent('op-vehlock:wipeKeys:ALL')
    end
end)

--[[

#
#   Lockpick
#

]]

if lockpickEnabled then
    if framework == 'esx' then
        _Framework.RegisterUsableItem('lockpick', function(source)
            TriggerClientEvent('op-vehlock:lockpickVehicle', source)
        end)
    elseif framework == 'qb' then
        _Framework.Functions.CreateUseableItem('lockpick', function(source, item)
            TriggerClientEvent('op-vehlock:lockpickVehicle', source)
        end)
    else
        print('[^6op-vehlock^0] Current framework setting does is not supported for lockpicking. The script will go further with lockpickEnabled set to ^6false^0.' )
        lockpickEnabled = false
    end
end

lib.callback.register('op-vehlock:lockpickRemove', function(source)
    if framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('lockpick', 1)
        return true
    elseif framework == 'qb' then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player.Functions.GetItemByName('my_cool_item') then return false end
        _Framework.Functions.UseItem(source, 'my_cool_item')
        return true
    else
        return false
    end
end)

function Trim(value)
	if not value then return nil end
	return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
end

function GetPlayerIden(target)
    if framework == 'esx' then
        return _Framework.GetPlayerFromId(target).identifier
    elseif framework == 'qb' then
        _Framework.Functions.GetIdentifier(target)
    end
end