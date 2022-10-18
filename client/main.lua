ESX                           = nil

Citizen.CreateThread(function()
	-- print(json.encode(langSettings[language],{indent=true}))
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

local isOnTimer = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Loop function
RegisterNetEvent('op-vehlock:UpdateClientLocks', function(table)
	local vehstable = lib.getNearbyVehicles(GetEntityCoords(PlayerPedId()), 999, true)
	for i=1, #vehstable do
		for _=1, #table do
			if table[_].plate == ESX.Math.Trim(GetVehicleNumberPlateText(vehstable[i].vehicle)) then
				local veh = vehstable[i].vehicle
				if table[_].state == 'true' then
					local doors = GetNumberOfVehicleDoors(veh)
					for o=1, doors do
						SetVehicleDoorShut(veh, o, false)
					end
					SetVehicleDoorsLocked(veh, 2)
				else
					SetVehicleDoorsLocked(veh, 0)
				end
			end
		end
	end
end)

function changeLock(plate, veh)
	lib.callback('op-vehlock:getVehState', false, function(isLocked)
		if isLocked then -- is locked
			lib.callback('op-vehlock:updateLock', false, function(result)
				if result then
					SetVehicleDoorsLocked(veh, 0)
					exports['mythic_notify']:SendAlert('success', (langSettings[language]['NowOpen']):format(plate))
					TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', "fob_click", 8.0, 8.0, -1, 48, 1, false, false, false)
					SetVehicleLights(veh, 2)
					Wait (200)
					SetVehicleLights(veh, 0)
					Wait (200)
					SetVehicleLights(veh, 2)
					Wait (200)
					SetVehicleLights(veh, 0)
					Wait (200)
					SetVehicleLights(veh, 2)
					Wait (200)
					SetVehicleLights(veh, 0)
				else
					print('error with plate '..plate)
				end
			end, plate, 'false')
		else -- is not locked
			lib.callback('op-vehlock:updateLock', false, function(result)
				if result then
					SetVehicleDoorsLocked(veh, 2)
					exports['mythic_notify']:SendAlert('error', (langSettings[language]['NowLocked']):format(plate))
					TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', "fob_click", 8.0, 8.0, -1, 48, 1, false, false, false)
					SetVehicleLights(veh, 2)
					Wait (400)
					SetVehicleLights(veh, 0)
					Wait (400)
					SetVehicleLights(veh, 2)
					Wait (400)
					SetVehicleLights(veh, 0)
					Wait (400)
					SetVehicleLights(veh, 2)
					Wait (400)
					SetVehicleLights(veh, 0)
				else
					print('error with plate '..plate)
				end
			end, plate, 'true')
		end
	end, plate)
end

function changeLockRadius()
	local vehs = lib.getNearbyVehicles(GetEntityCoords(PlayerPedId()), 5, true)
	local ownedcars = {}
	if #vehs > 0 then
		for i=1, #vehs do
			lib.callback('op-vehlock:isOwner', false, function(isOwner)
				if isOwner then
					changeLock(ESX.Math.Trim(GetVehicleNumberPlateText(vehs[i].vehicle)), vehs[i].vehicle)
				else
					lib.callback('op-vehlock:hasKey', false, function(hasKey)
						if hasKey then
							changeLock(ESX.Math.Trim(GetVehicleNumberPlateText(vehs[i].vehicle)), vehs[i].vehicle)
						end
					end, ESX.Math.Trim(GetVehicleNumberPlateText(vehs[i].vehicle)))
				end
			end, ESX.Math.Trim(GetVehicleNumberPlateText(vehs[i].vehicle)))
		end
	end
end

exports('changeLock', changeLock)
exports('changeLockRadius', changeLockRadius)

function doTimer()
	isOnTimer = 4
	while isOnTimer > 0 do
		isOnTimer = isOnTimer - 1
		Wait(1000)
	end
end

RegisterNetEvent('op-vehlock:_lockVehicle', function ()
	if isOnTimer > 0 then
		exports['mythic_notify']:SendAlert('inform', langSettings[language]['OnCooldown'])
	else
		changeLockRadius()
		doTimer()
	end
end)

RegisterCommand('_lockVehicle', function()
	TriggerEvent('op-vehlock:_lockVehicle')
end, false)
RegisterKeyMapping('_lockVehicle', langSettings[language]['keyMappingLabel'], 'keyboard', 'O')

function giveKeys(target)
	if GetPlayerServerId(PlayerId()) == target then
		exports['mythic_notify']:SendAlert('error', langSettings[language]['AlreadyHasKeys'])
		return
	end
	if GetPlayerFromServerId(target) == -1 then
		exports['mythic_notify']:SendAlert('error', langSettings[language]['TargetNotOnline'])
		return
	end

	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		if veh then
			local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target))))
			if dist <= 5 then
				lib.callback('op-vehlock:isOwner', false, function(isOwner)
					if isOwner then
						lib.callback('op-vehlock:giveKeys', false, function(success)
							if success then
								if fullFunctionality then
									exports['mythic_notify']:SendAlert('success', (langSettings[language]['KeysGivenTo']):format(ESX.Math.Trim(GetVehicleNumberPlateText(veh)), target))
								end
							else
								exports['mythic_notify']:SendAlert('inform', (langSettings[language]['TargetAlreadyHasKeys']):format(ESX.Math.Trim(GetVehicleNumberPlateText(veh))))
							end
						end, ESX.Math.Trim(GetVehicleNumberPlateText(veh)), target)
					else
					end
				end, ESX.Math.Trim(GetVehicleNumberPlateText(veh)))
			else
				exports['mythic_notify']:SendAlert('inform',langSettings[language]['TargetToFar'])
			end
		end
	else
		exports['mythic_notify']:SendAlert('error', langSettings[language]['VehicleRequired'])
	end
end

exports('giveKeys', giveKeys)

RegisterNetEvent('op-vehlock:giveKeys',function(target)
	-- print('test')
	giveKeys(target)
end)