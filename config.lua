--[[
#   Functionality Settings
]]

fullFunctionality = true -- Enable keymapping, eg. being able to use the script as a interactive script and not just handling the locking.
consolePrinting = true -- Print in the serverconsole script outputs like database cleanup etc.

updateTimer = 3 -- In Seconds
cleanupTimer = 60 -- In Seconds ( Wipes any plates from the database that no longer exist in the game )

lockpickEnabled = true
lockpickLevels = {'medium', 'easy', 'medium'} -- Refering to https://overextended.github.io/docs/ox_lib/Interface/Client/skillcheck

usingTarget = true
targetFramework = 'ox' -- supported: ox, qtarget ( I Suggest ox_target since it is a lot more reliable )

--[[
#   Locks Settings
]]

dbTableLocks = 'op-vehlock'
lockRadius = 5

--[[
#   Keys Settings
]]

dbTableKeys = 'op-vehkeys'
enableKeys = true -- Either enable or disable the keys functionality
wipeKeysOnStartup = false -- Wipe all shared keys on resource startup

--[[
#   Language Settings
]]

language = 'en'

langSettings = {
    ['en'] = {
        ['keyMappingLabel'] = 'Vehiclelock',
        ['OnCooldown'] = 'You are on cooldown please wait',

        -- Keys
        ['CannotGiveYourself'] = 'You cannot give yourself keys.',
        ['AlreadyHasKeys'] = 'You already have the keys',
        ['VehicleRequired'] = 'You need to be in a vehicle',
        ['TargetAlreadyHasKeys'] = 'Target already has the keys for %s', -- ( %s = plate)
        ['TargetAlreadyHasNOKeys'] = 'Target does not have the keys for %s', -- ( %s = plate)
        ['KeysGivenTo'] = 'Keys for plate %s have been given to %s', -- (1st %s = plate, 2nd %s = target identifier)
        ['NoKeys'] = 'There are no keys registered to plate %s', -- ( %s = plate )
        ['ClickToRemove'] = 'Click to remove key access',

        -- Target // Keys
        ['UseKeys'] = 'Use Keys', -- only for when target is enabled
        ['RemoveKeys'] = 'Remove Keys',
        ['GiveKeys'] = 'Give Keys',
        ['SelectPlayer'] = 'Select a player',
        ['KeysRemoved'] = 'Keys of target removed',

        -- Locks
        ['NowOpen'] = '%s is now Open', -- ( %s = plate )
        ['NowLocked'] = '%s is now Locked', -- ( %s = plate )

        -- Lockpick
        ['LeaveVehicle'] = 'You must leave your vehicle to do this.',
        ['LockPickFailed'] = 'Your lockpick broke, task failed.',
        ['UseLockpick'] = 'Use Lock-pick',

        -- Error
        ['TargetNotOnline'] = 'Target is not online',
        ['TargetToFar'] = 'Target is to far',
        ['ETryAgain'] = 'There has been an error, please try again.',
        ['ENoAccess'] = 'You don\'t have access to this vehicle.',
        ['NoResult'] = 'No results found',
    },
    ['nl'] = {
        ['keyMappingLabel'] = 'Voertuig slot',
        ['OnCooldown'] = 'Even wachten',

        -- Keys
        ['CannotGiveYourself'] = 'Je kunt jezelf geen sleutels geven.',
        ['AlreadyHasKeys'] = 'Je bezit deze sleutels al',
        ['VehicleRequired'] = 'Je moet in een voertuig zitten',
        ['TargetAlreadyHasKeys'] = 'Speler heeft al de sleutels voor %s', -- ( %s = plate)
        ['TargetAlreadyHasNOKeys'] = 'Speler heeft geen sleutels voor %s', -- ( %s = plate)
        ['KeysGivenTo'] = 'Keys for plate %s have been given to %s', -- (1st %s = plate, 2nd %s = target identifier)
        ['NoKeys'] = 'There are no keys registered to plate %s', -- ( %s = plate )
        ['ClickToRemove'] = 'Click to remove key access',

        -- Target // Keys
        ['UseKeys'] = 'Use Keys', -- only for when target is enabled
        ['RemoveKeys'] = 'Remove Keys',
        ['GiveKeys'] = 'Give Keys',
        ['SelectPlayer'] = 'Select a player',
        ['KeysRemoved'] = 'Sleutels van speler verwijderd',

        -- Locks
        ['NowOpen'] = '%s is nu van het slot', -- ( %s = plate )
        ['NowLocked'] = '%s is nu op slot', -- ( %s = plate )

        -- Lockpick
        ['LeaveVehicle'] = 'Graag het voertuig verlaten.',
        ['LockPickFailed'] = 'Openbreken gefaalt.',
        ['UseLockpick'] = 'Lockpick gebruiken',

        -- Error
        ['TargetNotOnline'] = 'Speler is niet online',
        ['TargetToFar'] = 'Speler is te ver weg',
        ['ETryAgain'] = 'Er is een error, probeer opnieuw.',
        ['ENoAccess'] = 'Geen toegang tot het slot van dit voertuig.',
        ['NoResult'] = 'Geen resultaat gevonden',
    }
}