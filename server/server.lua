ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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
    r2 = MySQL.single.await('SELECT * FROM `'..('%s'):format(dbTableKeys)..'` WHERE plate = ? AND identifier = ?', {plate, ESX.GetPlayerFromId(target).identifier})
    if r2 == nil then
        r = MySQL.insert.await('INSERT INTO `'..('%s'):format(dbTableKeys)..'` (plate, identifier) VALUES (?,?)', {plate, ESX.GetPlayerFromId(target).identifier})
        if r ~= false then
            r = true
        end
    else
        r = false
    end
    return r
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

lib.callback.register('op-vehlock:hasKey', function(source, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local r = false
    r = MySQL.single.await('SELECT plate, identifier FROM `'..('%s'):format(dbTableKeys)..'` WHERE identifier = ? AND plate = ?', {xPlayer.identifier, plate})
    if r then
        if r.identifier == xPlayer.identifier then
            r = true
        else
            r = false
        end
    else
        r = false
    end
    return r
end)

lib.callback.register('op-vehlock:isOwner', function(source, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local r = false
    r = MySQL.single.await('SELECT owner FROM `owned_vehicles` WHERE plate = ?', {plate})
    if r then
        if r.owner == xPlayer.identifier then
            r = true
        else
            r = false
        end
    else
        r = false
    end

    return r
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
    local unknownPlates = {}
    local vehicles = GetAllVehicles()
    local vehiclePlates = {}
    for i=1, #vehicles do
        table.insert(vehiclePlates, ESX.Math.Trim(GetVehicleNumberPlateText(vehicles[i])))
    end
    for i=1, #lockedVehicles do
        if lockedVehicles[i].plate ~= vehiclePlates then
            table.insert(unknownPlates, lockedVehicles[i].plate)
        end
    end
    for i=1, #unknownPlates do
        wipeLock(unknownPlates[i])
    end
    if consolePrinting then print('[^6op-vehlock^0] Database table cleanup has been completed. ^6'..#unknownPlates..'^0 plates have been removed.' ) end
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
    ESX.RegisterUsableItem('lockpick', function(source)
        print('test')
        TriggerClientEvent('op-vehlock:lockpickVehicle', source)
    end)
end

lib.callback.register('op-vehlock:lockpickRemove', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('lockpick', 1)
    return true
end)
