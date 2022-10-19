ESX                           = nil
local isOnTimer 		= 0

Citizen.CreateThread(function()
	lib.requestAnimDict('anim@mp_player_intmenu@key_fob@', 100)
	lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 100)
	-- print(json.encode(langSettings[language],{indent=true}))
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)


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

local function doLockpicking(veh)
	local plate = GetVehicleNumberPlateText(veh)
	TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false )
	local success = lib.skillCheck(lockpickLevels)
	if success then
		ClearPedTasks(PlayerPedId())
		changeLock(plate, veh, true)
	else
		ClearPedTasks(PlayerPedId())
		lib.notify({type = 'error', title = langSettings[language]['LockPickFailed']})
	end
end

function changeLock(plate, veh, isLockpick)
	lib.callback('op-vehlock:getVehState', false, function(isLocked)
		if isLocked then -- is locked
			lib.callback('op-vehlock:updateLock', false, function(result)
				if result then
					if not isLockpick then TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', "fob_click", 8.0, 8.0, -1, 48, 1, false, false, false) end
					SetVehicleDoorsLocked(veh, 0)
					lib.notify({type = 'success', title = (langSettings[language]['NowOpen']):format(plate)})
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
					if not isLockpick then TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', "fob_click", 8.0, 8.0, -1, 48, 1, false, false, false) end
					SetVehicleDoorsLocked(veh, 2)
					lib.notify({type = 'error', title = (langSettings[language]['NowLocked']):format(plate)})
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
		lib.notify({type = 'inform', title = langSettings[language]['OnCooldown']})
	else
		changeLockRadius()
		doTimer()
	end
end)

RegisterCommand('_lockVehicle', function()
	TriggerEvent('op-vehlock:_lockVehicle')
end, false)
RegisterKeyMapping('_lockVehicle', langSettings[language]['keyMappingLabel'], 'keyboard', 'O')

function giveKeys(target, ignoreFlags) -- ignoreFlags is default false, if you want to give keys to a player for a job car then use exports['op-vehlock']:giveKeys(int playerId, bool ignoreFlags)
	if not ignoreFlags then
		if GetPlayerServerId(PlayerId()) == target then
			lib.callback('op-vehlock:isOwner', false, function(isOwner)
				if isOwner then
					lib.notify({type = 'error', title = langSettings[language]['AlreadyHasKeys']})
				else
					lib.notify({type = 'error', title = langSettings[language]['CannotGiveYourself']})
				end
			end, ESX.Math.Trim(GetVehicleNumberPlateText(lib.getClosestVehicle(GetEntityCoords(PlayerPedId()), 1.5, true))))
			return
		end
	end
	if GetPlayerFromServerId(target) == -1 then
		lib.notify({type = 'error', title = langSettings[language]['TargetNotOnline']})
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
									lib.notify({type = 'success', title = (langSettings[language]['KeysGivenTo']):format(ESX.Math.Trim(GetVehicleNumberPlateText(veh)), target)})
								end
							else
								lib.notify({type = 'inform', title = (langSettings[language]['TargetAlreadyHasKeys']):format(ESX.Math.Trim(GetVehicleNumberPlateText(veh)))})
							end
						end, ESX.Math.Trim(GetVehicleNumberPlateText(veh)), target)
					else
					end
				end, ESX.Math.Trim(GetVehicleNumberPlateText(veh)), target)
			else
				lib.notify({type = 'inform', title = langSettings[language]['TargetToFar']})
			end
		end
	else
		lib.notify({type = 'error', title = langSettings[language]['VehicleRequired']})
	end
end

exports('giveKeys', giveKeys)

RegisterNetEvent('op-vehlock:giveKeys',function(target)
	-- print('test')
	giveKeys(target)
end)

RegisterNetEvent('op-vehlock:lockpickVehicle', function()
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
		local veh = lib.getClosestVehicle(GetEntityCoords(PlayerPedId()), 2, false)
		if veh then
			lib.callback('op-vehlock:lockpickRemove', false, function(removed)
				if removed then
					doLockpicking(veh)
				else
					lib.notify({type = 'error', title = langSettings[language]['ETryAgain']})
				end
			end)
		end
	else
		lib.notify({type = 'error', title = langSettings[language]['LeaveVehicle']})
	end
end)

if usingTarget then
	if targetFramework == 'ox' then
		exports.ox_target:addGlobalVehicle({
            {
                name = 'op-vehlock:lockVehicle',
                icon = 'fa-solid fa-key',
                label = langSettings[language]['UseKeys'],
                distance = 2.5,
                onSelect = function(data)
                    local plate = GetVehicleNumberPlateText(data.entity)
                    changeLock(plate,data.entity)
                end,
                canInteract = function(entity)
					local result = false
                    local plate = GetVehicleNumberPlateText(entity)
                    result = lib.callback.await('op-vehlock:isOwner', false, plate)
					if not result then
						result = lib.callback.await('op-vehlock:hasKey', false, plate)
					end
					return result
                end
            }
        })
	elseif targetFramework == 'qtarget' then
		exports.qtarget:Vehicle({
			options = {
				{
					icon = 'fa-solid fa-key',
					label = langSettings[language]['UseKeys'],
					action = function(entity)
						local plate = GetVehicleNumberPlateText(entity)
                    changeLock(plate,entity)
					end,
					canInteract = function(entity)
						print(json.encode(entity))
						local result = false
						local plate = GetVehicleNumberPlateText(entity)
						result = lib.callback.await('op-vehlock:isOwner', false, plate)
						if not result then
							result = lib.callback.await('op-vehlock:hasKey', false, plate)
						end
						return result
					end
				},
			},
			distance = 2.5
		})
	else
		print('targetFramework has an invalid option please check the config.lua')
		print('targetFramework has an invalid option please check the config.lua')
		print('targetFramework has an invalid option please check the config.lua')
		print('targetFramework has an invalid option please check the config.lua')
	end
end