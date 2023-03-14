local isOnTimer 		= 0

-- TargetSys get used for the target system for functions like removeKey and giveKey, you will first have to select your vehicle(targetSys1) and then the player you want to give/remove the key from(targetSys2)
local targetSys1		= nil -- First target
local targetSys2		= nil -- Second target

--[[

#
#	Initizialize
#

]]
CreateThread(function()
	lib.requestAnimDict('anim@mp_player_intmenu@key_fob@', 100)
	lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 100)
end)

-- Loop function
RegisterNetEvent('op-vehlock:UpdateClientLocks', function(table)
	local vehstable = lib.getNearbyVehicles(GetEntityCoords(PlayerPedId()), 999, true)
	for i=1, #vehstable do
		for _=1, #table do
			if table[_].plate == Trim(GetVehicleNumberPlateText(vehstable[i].vehicle)) then
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

--[[

#
#	Lock System
#

]]

function changeLock(plate, veh, isLockpick)
	lib.callback('op-vehlock:getVehState', false, function(isLocked)
		if isLocked then -- is locked
			lib.callback('op-vehlock:updateLock', false, function(result)
				if result then
					if not isLockpick then TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', "fob_click", 8.0, 8.0, -1, 48, 1, false, false, false) end
					StartVehicleHorn(veh, 30, GetHashKey('NORMAL'), false)
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
					StartVehicleHorn(veh, 30, GetHashKey('NORMAL'), false)
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
					changeLock(Trim(GetVehicleNumberPlateText(vehs[i].vehicle)), vehs[i].vehicle)
				else
					lib.callback('op-vehlock:hasKey', false, function(hasKey)
						if hasKey then
							changeLock(Trim(GetVehicleNumberPlateText(vehs[i].vehicle)), vehs[i].vehicle)
						end
					end, Trim(GetVehicleNumberPlateText(vehs[i].vehicle)))
				end
			end, Trim(GetVehicleNumberPlateText(vehs[i].vehicle)))
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

--[[

#
#	Keys
#

]]

-- GiveKeys
function giveKeys(target, ignoreFlags) -- ignoreFlags is default false, if you want to give keys to a player for a job car then use exports['op-vehlock']:giveKeys(int playerId, bool ignoreFlags)
	if not ignoreFlags then
		if GetPlayerServerId(PlayerId()) == target then
			lib.callback('op-vehlock:isOwner', false, function(isOwner)
				if isOwner then
					lib.notify({type = 'error', title = langSettings[language]['AlreadyHasKeys']})
				else
					lib.notify({type = 'error', title = langSettings[language]['CannotGiveYourself']})
				end
			end, Trim(GetVehicleNumberPlateText(lib.getClosestVehicle(GetEntityCoords(PlayerPedId()), 1.5, true))))
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
									lib.notify({type = 'success', title = (langSettings[language]['KeysGivenTo']):format(Trim(GetVehicleNumberPlateText(veh)), target)})
								end
							else
								lib.notify({type = 'inform', title = (langSettings[language]['TargetAlreadyHasKeys']):format(Trim(GetVehicleNumberPlateText(veh)))})
							end
						end, Trim(GetVehicleNumberPlateText(veh)), target)
					else
					end
				end, Trim(GetVehicleNumberPlateText(veh)), target)
			else
				lib.notify({type = 'inform', title = langSettings[language]['TargetToFar']})
			end
		end
	else
		lib.notify({type = 'error', title = langSettings[language]['VehicleRequired']})
	end
end

exports('giveKeys', giveKeys)

RegisterNetEvent('op-vehlock:giveKeys_TARGETONLY', function(targetParameter)
	lib.callback('op-vehlock:isOwner', false, function(isOwner)
		if isOwner then
			targetSys1 = targetParameter
			lib.showTextUI(langSettings[language]['SelectPlayer'], {
				position = "top-center",
				icon = 'user',
				style = {
					borderRadius = 0,
					backgroundColor = '#141517',
					color = '#909296'
				}
			})

			local timer = 30
			if targetFramework == 'ox' then
				-- Add player option for targetsys2
				exports.ox_target:addGlobalPlayer({
					{
						name = 'op-vehlock:targetsys2GiveKeys',
						icon = 'fa-solid fa-user-lock',
						label = langSettings[language]['GiveKeys'],
						onSelect = function(entity)
							local playerId, playerPed, playerCoords = lib.getClosestPlayer(vector3(entity.coords.x,entity.coords.y,entity.coords.z), 1.5, false)
							targetSys2 = GetPlayerServerId(playerId)
							lib.hideTextUI()
							exports.ox_target:removeGlobalPlayer('op-vehlock:targetsys2GiveKeys')
						end,
						distance = 1.0
					}
				})
				-- Handle removal of target option after all parameters set
			elseif targetFramework == 'qtarget' then
				-- Add player option for targetsys2
				exports.qtarget:Player({
					options = {
						{
							icon = "fas fa-key",
							label = langSettings[language]['GiveKeys'],
							action = function(entity)
								local coords = GetEntityCoords(entity)
								local playerId, playerPed, playerCoords = lib.getClosestPlayer(coords, 1.5, false)
								targetSys2 = GetPlayerServerId(playerId)
								lib.hideTextUI()
								exports.qtarget:RemovePlayer({
									langSettings[language]['GiveKeys'],
								})
							end
						},
					},
					distance = 1.0
				})
			end
			while not targetSys2 and timer > 0 do
				Wait(1000)
				timer = timer - 1
			end
			if targetSys2 then
				lib.callback('op-vehlock:giveKeys', false, function(success)
					if success then
						if fullFunctionality then
							lib.notify({type = 'success', title = (langSettings[language]['KeysGivenTo']):format(Trim(GetVehicleNumberPlateText(targetParameter)), targetSys2)})
						end
					else
						lib.notify({type = 'inform', title = (langSettings[language]['TargetAlreadyHasKeys']):format(Trim(GetVehicleNumberPlateText(targetParameter)))})
					end
				end, Trim(GetVehicleNumberPlateText(targetParameter)), targetSys2)
				Wait(3000)
				targetSys1 = nil
				targetSys2 = nil
			else
				lib.hideTextUI()
				targetSys1 = nil
				targetSys2 = nil
				if usingTarget then
					if targetFramework == 'ox' then exports.ox_target:removeGlobalPlayer('op-vehlock:targetsys2GiveKeys')
					elseif targetFramework == 'qtarget' then exports.qtarget:RemovePlayer({langSettings[language]['GiveKeys'],}) end
				end
			end

		else
			lib.notify({type='error', title=langSettings[language]['ENoAccess']})
		end
	end, Trim(GetVehicleNumberPlateText(targetParameter)))
end)

RegisterNetEvent('op-vehlock:giveKeys',function(target)
	giveKeys(target)
end)

-- RemoveKeys
RegisterNetEvent('op-vehlock:removeKeys', function(targetParameter) -- targetParameter = entity from target
	local veh
	if usingTarget then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			veh = GetVehiclePedIsIn(PlayerPedId(),false)
			lib.callback('op-vehlock:isOwner', false, function(isOwner)
				if isOwner then
					local keys = lib.callback.await('op-vehlock:getKeysOnPlate', false, Trim(GetVehicleNumberPlateText(veh)))
					local keysOnPlate = {}
					if #keys > 0 then
						for i=1, #keys do
							table.insert(keysOnPlate,
							{
								title=lib.callback.await('op-vehlock:getPlayerNameFromIdentifier', false, keys[i].identifier),
								description=langSettings[language]['ClickToRemove'],
								args={plate=Trim(GetVehicleNumberPlateText(veh)), identifier=keys[i].identifier},
								serverEvent='op-vehlock:removeKeyFromPlate',
							})
						end
					end
					if #keysOnPlate > 0 then
						lib.registerContext({
							id = 'op-vehlock-removeKeys',
							title = Trim(GetVehicleNumberPlateText(veh)),
							options = {
								table.unpack(keysOnPlate)
							}
						})
						lib.showContext('op-vehlock-removeKeys')
					else -- No keys on plate
						lib.notify({type='inform', title=(langSettings[language]['NoKeys']):format(Trim(GetVehicleNumberPlateText(veh)))})
					end
				else
					lib.notify({type='error', title=langSettings[language]['ENoAccess']})
				end
			end, Trim(GetVehicleNumberPlateText(veh)))
		else
			lib.callback('op-vehlock:isOwner', false, function(isOwner)
				if isOwner then
					targetSys1 = targetParameter
					lib.showTextUI(langSettings[language]['SelectPlayer'], {
						position = "top-center",
						icon = 'user',
						style = {
							borderRadius = 0,
							backgroundColor = '#141517',
							color = '#909296'
						}
					})

					local timer = 30
					if targetFramework == 'ox' then
						-- Add player option for targetsys2
						exports.ox_target:addGlobalPlayer({
							{
								name = 'op-vehlock:targetsys2RemKeys',
								icon = 'fa-solid fa-user-lock',
								label = langSettings[language]['ClickToRemove'],
								onSelect = function(entity)
									local playerId, playerPed, playerCoords = lib.getClosestPlayer(vector3(entity.coords.x,entity.coords.y,entity.coords.z), 1.5, false)
									targetSys2 = GetPlayerServerId(playerId)
									lib.hideTextUI()
									exports.ox_target:removeGlobalPlayer('op-vehlock:targetsys2RemKeys')
								end,
								distance = 1.0
							}
						})

						-- Handle removal of target option after all parameters set
					elseif targetFramework == 'qtarget' then
						-- Add player option for targetsys2
						exports.qtarget:Player({
							options = {
								{
									icon = "fas fa-key",
									label = langSettings[language]['RemoveKeys'],
									action = function(entity)
										local coords = GetEntityCoords(entity)
										local playerId, playerPed, playerCoords = lib.getClosestPlayer(coords, 1.5, false)
										targetSys2 = GetPlayerServerId(playerId)
										lib.hideTextUI()
										exports.qtarget:RemovePlayer({
											langSettings[language]['RemoveKeys'],
										})
									end
								},
							},
							distance = 1.0
						})
					end
					while not targetSys2 and timer > 0 do
						Wait(1000)
						timer = timer - 1
					end
					-- Has all parameters
					if targetSys2 then
						lib.callback('op-vehlock:hasKey', false, function(hasKey)
							if hasKey then
								TriggerServerEvent('op-vehlock:removeKeysID', Trim(GetVehicleNumberPlateText(targetParameter)), targetSys2)
							else
								lib.notify({type='error',title=(langSettings[language]['TargetAlreadyHasNOKeys']):format(Trim(GetVehicleNumberPlateText(targetParameter)))})
							end
						end, Trim(GetVehicleNumberPlateText(targetParameter)), targetSys2, true)
						Wait(3000)
						targetSys1 = nil
						targetSys2 = nil
					else
						lib.hideTextUI()
						targetSys1 = nil
						targetSys2 = nil
						if usingTarget then
							if targetFramework == 'ox' then exports.ox_target:removeGlobalPlayer('op-vehlock:targetsys2RemKeys')
							elseif targetFramework == 'qtarget' then exports.qtarget:RemovePlayer({langSettings[language]['RemoveKeys'],}) end
						end
					end
				else
					lib.notify({type='error', title=langSettings[language]['ENoAccess']})
				end
			end, Trim(GetVehicleNumberPlateText(targetParameter)))
		end
	elseif IsPedInAnyVehicle(PlayerPedId(), false) then
		veh = GetVehiclePedIsIn(PlayerPedId(),false)
		lib.callback('op-vehlock:isOwner', false, function(isOwner)
			if isOwner then
				local keys = lib.callback.await('op-vehlock:getKeysOnPlate', false, Trim(GetVehicleNumberPlateText(veh)))
				local keysOnPlate = {}
				if #keys > 0 then
					for i=1, #keys do
						table.insert(keysOnPlate,
						{
							title=lib.callback.await('op-vehlock:getPlayerNameFromIdentifier', false, keys[i].identifier),
							description=langSettings[language]['ClickToRemove'],
							args={plate=Trim(GetVehicleNumberPlateText(veh)), identifier=keys[i].identifier},
							serverEvent='op-vehlock:removeKeyFromPlate',
						})
					end
				end
				if #keysOnPlate > 0 then
					lib.registerContext({
						id = 'op-vehlock-removeKeys',
						title = Trim(GetVehicleNumberPlateText(veh)),
						options = {
							table.unpack(keysOnPlate)
						}
					})
					lib.showContext('op-vehlock-removeKeys')
				else -- No keys on plate
					lib.notify({type='inform', title=(langSettings[language]['NoKeys']):format(Trim(GetVehicleNumberPlateText(veh)))})
				end
			else
				lib.notify({type='error', title=langSettings[language]['ENoAccess']})
			end
		end, Trim(GetVehicleNumberPlateText(veh)))
	else
		lib.notify({type='error', title=langSettings[language]['VehicleRequired']})
	end
end)

--[[

#
#	Lockpick
#

]]

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

function doLockpicking(veh)
	local plate = Trim(GetVehicleNumberPlateText(veh))
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

--[[

#
#	Target System
#

]]

if usingTarget then
	if targetFramework == 'ox' then
		local toptions = {
			[2] = {
				name = 'op-vehlock:giveKeysTarget',
				icon = 'fa-solid fa-user-lock',
				label = langSettings[language]['GiveKeys'],
				distance = 1.5,
				onSelect = function(data)
					TriggerEvent('op-vehlock:giveKeys_TARGETONLY',data.entity)
				end
			},
			[3] = {
				name = 'op-vehlock:removeKeysTarget',
				icon = 'fa-solid fa-user-lock',
				label = langSettings[language]['RemoveKeys'],
				distance = 1.5,
				onSelect = function(data)
					TriggerEvent('op-vehlock:removeKeys',data.entity)
				end
			},
			[4] = {
				name = 'op-vehlock:lockPick',
                icon = 'fa-solid fa-handcuffs',
                label = langSettings[language]['UseLockpick'],
                distance = 1.5,
                event = 'op-vehlock:lockpickVehicle',
                items = 'lockpick'
			},
		}
		if lockpickEnabled then
			table.insert(toptions, 1, {
                name = 'op-vehlock:lockVehicle',
                icon = 'fa-solid fa-key',
                label = langSettings[language]['UseKeys'],
                distance = 1.5,
                onSelect = function(data)
                    targetLockSys(data.entity)
                end,
            })
		end
		function targetLockSys(veh) -- ox_target function only
			local result = false
            		local plate = Trim(GetVehicleNumberPlateText(veh))
           		result = lib.callback.await('op-vehlock:isOwner', false, plate)
			if not result and enableKeys then
				result = lib.callback.await('op-vehlock:hasKey', false, plate)
			end
			if result then
				changeLock(plate,veh)
			else
				lib.notify({type='error', title=langSettings[language]['ENoAccess']})
			end
		end
		exports.ox_target:addGlobalVehicle({
            table.unpack(toptions)
        })
	elseif targetFramework == 'qtarget' then
		local toptions = {
			[2] = {
				icon = 'fa-solid fa-key',
				label = langSettings[language]['UseKeys'],
				action = function(entity)
					local plate = Trim(GetVehicleNumberPlateText(entity))
					changeLock(plate,entity)
				end,
			},
			[3] = {
				icon = 'fa-solid fa-user-lock',
				label = langSettings[language]['RemoveKeys'],
				action = function(entity)
					TriggerEvent('op-vehlock:giveKeys_TARGETONLY',entity)
				end
			},
			[4] = {
				icon = 'fa-solid fa-user-lock',
				label = langSettings[language]['RemoveKeys'],
				action = function(entity)
					TriggerEvent('op-vehlock:removeKeys',entity)
				end
			}
		}
		if lockpickEnabled then
			table.insert(toptions, 1, {
				event = 'op-vehlock:lockpickVehicle',
				icon = 'fa-solid fa-handcuffs',
				label = langSettings[language]['UseLockpick'],
				item = 'lockpick',
			})
		end
		exports.qtarget:Vehicle({
			options = {
				table.unpack(toptions)
			},
			distance = 1.5
		})
	else
		print('targetFramework has an invalid option please check the config.lua')
		print('targetFramework has an invalid option please check the config.lua')
		print('targetFramework has an invalid option please check the config.lua')
		print('targetFramework has an invalid option please check the config.lua')
	end
end


--[[

#
#	Handlers / Functions
#

]]

function Trim(value)
	if not value then return nil end
	return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
end

AddEventHandler('entityCreated', function(entity)
    if not DoesEntityExist(entity) then return end
	if GetEntityType(entity) ~= 2 then return end
	lib.callback('op-vehlock:lockNpc', false, function(success)
		if not succes then return end
	end, GetVehicleNumberPlateText(entity))
end)