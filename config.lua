--[[
#   Functionality Settings
]]

fullFunctionality = true -- Enable keymapping, eg. being able to use the script as a interactive script and not just handling the locking.
consolePrinting = true -- Print in the serverconsole script outputs like database cleanup etc.

updateTimer = 3 -- In Seconds
cleanupTimer = 60 -- In Seconds ( Wipes any plates from the database that no longer exist in the game )

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
        ['AlreadyHasKeys'] = 'You already have the keys',
        ['VehicleRequired'] = 'You need to be in a vehicle',
        ['TargetAlreadyHasKeys'] = 'Target already has the keys for %s', -- ( %s = plate)
        ['KeysGivenTo'] = 'Keys for plate %s have been given to %s', -- (1st %s = plate, 2nd %s = target identifier)

        -- Locks
        ['NowOpen'] = '%s is now Open', -- ( %s = plate )
        ['NowLocked'] = '%s is now Locked', -- ( %s = plate )

        -- Error
        ['TargetNotOnline'] = 'Target is not online',
        ['TargetToFar'] = 'Target is to far',
    },
    ['nl'] = {
        ['keyMappingLabel'] = 'Voertuig slot',
        ['OnCooldown'] = 'Even wachten',

        -- Keys
        ['AlreadyHasKeys'] = 'Je bezit deze sleutels al',
        ['VehicleRequired'] = 'Je moet in een voertuig zitten',
        ['TargetAlreadyHasKeys'] = 'Speler heeft al de sleutels voor %s', -- ( %s = plate)
        ['KeysGivenTo'] = 'Sleutels voor %s zijn gedeeld met %s', -- (1st %s = plate, 2nd %s = target identifier)

        -- Locks
        ['NowOpen'] = '%s is nu van het slot', -- ( %s = plate )
        ['NowLocked'] = '%s is nu op slot', -- ( %s = plate )

        -- Error
        ['TargetNotOnline'] = 'Speler is niet online',
        ['TargetToFar'] = 'Speler is te ver weg',
    }
}