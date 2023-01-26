--[[
#   Functionality Settings
]]

fullFunctionality = true -- Enable keymapping, eg. being able to use the script as a interactive script and not just handling the locking.
consolePrinting = true -- Print in the serverconsole script outputs like database cleanup etc.
framework = 'esx' -- 'esx', 'qb'

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
useKeyAsItem = false --[[ Supported inventory's = [ox_inventory] ]]
--[[ If you use an other inventory and want this feature please create a issue report in github, or make an ticket on discord ]]

--[[
#   Language Settings
]]

language = 'en'

langSettings = {
    ['en'] = {
        ['keyMappingLabel'] = 'Vehiclelock',
        ['OnCooldown'] = 'You are on cooldown please wait',
        ['Success'] = 'Success',

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
        ['Success'] = 'Successvol',

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
    },
    ['fr'] = {
        ['keyMappingLabel'] = 'Vehiclelock',
        ['OnCooldown'] = 'Vous êtes en cooldown, veuillez patienter',
        ['Success'] = 'Succès',

        -- Keys
        ['CannotGiveYourself'] = 'Vous ne pouvez pas vous donner des clés.',
        ['AlreadyHasKeys'] = 'Vous avez déjà les clés',
        ['VehicleRequired'] = 'Vous devez être dans un véhicule',
        ['TargetAlreadyHasKeys'] = 'La cible a déjà les clés pour %s', -- ( %s = plate)
        ['TargetAlreadyHasNOKeys'] = 'La cible n a pas les clés pour %s', -- ( %s = plate)
        ['KeysGivenTo'] = 'Les clés de la plaque %s ont été données à %s', -- (1st %s = plate, 2nd %s = target identifier)
        ['NoKeys'] = 'Il n y a pas de clés enregistrées sur la plaque %s', -- ( %s = plate )
        ['ClickToRemove'] = 'Cliquez pour supprimer l accès clé',

        -- Target // Keys
        ['UseKeys'] = 'Utiliser les clés', -- only for when target is enabled
        ['RemoveKeys'] = 'Supprimer les clés',
        ['GiveKeys'] = 'Donner les clés',
        ['SelectPlayer'] = 'Sélectionnez un joueur',
        ['KeysRemoved'] = 'Clés de la cible supprimées',

        -- Locks
        ['NowOpen'] = '%s est maintenant ouvert', -- ( %s = plate )
        ['NowLocked'] = '%s est maintenant verrouillé', -- ( %s = plate )

        -- Lockpick
        ['LeaveVehicle'] = 'Vous devez laisser votre véhicule pour ce faire.',
        ['LockPickFailed'] = 'Votre lockpick  s est cassé, la tâche a échoué.',
        ['UseLockpick'] = 'Utiliser un Lock-pick',

        -- Error
        ['TargetNotOnline'] = 'La cible n est pas en ligne',
        ['TargetToFar'] = 'La cible est trop loin',
        ['ETryAgain'] = 'Une erreur s est produite, veuillez réessayer.',
        ['ENoAccess'] = 'Vous n avez pas accès à ce véhicule.',
        ['NoResult'] = 'Aucun résultat trouvé',
    }
}
