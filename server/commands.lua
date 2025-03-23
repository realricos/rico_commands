QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('goto', 'Teleportera till en spelare', {{name = 'id', help = 'Spelarens ID'}}, true, function(source, args)
    local src = source
    local targetId = tonumber(args[1])
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)

    if Player and Target then
        local targetPed = GetPlayerPed(targetId)
        local targetCoords = GetEntityCoords(targetPed)

        TriggerClientEvent('qb-admin:client:goto', src, targetCoords)

        local playerName = GetPlayerName(targetId)
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Server Staff]", "Du teleporteras till "..playerName}
        })

    else
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Server Staff]", "Ogiltigt ID"}
        })
    end
end, 'admin')

QBCore.Commands.Add('bring', 'Ta en spelare till dig', {{name = 'id', help = 'Spelarens ID'}}, true, function(source, args)
    local src = source
    local targetId = tonumber(args[1])
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)

    if Player and Target then
        local adminPed = GetPlayerPed(src)
        local adminCoords = GetEntityCoords(adminPed)

        TriggerClientEvent('qb-admin:client:bring', targetId, adminCoords)

        local playerName = GetPlayerName(targetId)
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Server Staff]", "Du drog "..playerName.." till dig."}
        })

        TriggerClientEvent('chat:addMessage', targetId, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Server Staff]", "Du drogs av "..GetPlayerName(src)}
        })

    else
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Server Staff]", "Ogiltigt ID"}
        })
    end
end, 'admin')

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerClientEvent('chat:addSuggestion', -1, '/goto', 'Teleportera till en spelare', {
            { name = 'id', help = 'Spelarens ID' }
        })

        TriggerClientEvent('chat:addSuggestion', -1, '/bring', 'Ta en spelare till dig', {
            { name = 'id', help = 'Spelarens ID' }
        })
    end
end)


QBCore.Commands.Add('noclip', 'slå på/av noclip- enbart avsedd för staffs.', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player and QBCore.Functions.HasPermission(source, 'admin') or QBCore.Functions.HasPermission(source, 'god') then
        TriggerClientEvent('toggleNoclip', source)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"SYSTEM", "Du har inte tillräckliga rättigheter för att använda NoClip!"}
        })
    end
end, 'admin')





QBCore.Commands.Add('spawnveh', 'Spawna ett fordon framför dig', {{name = 'model', help = 'Modellnamn på fordonet'}}, true, function(source, args)
    local model = args[1]
    local Player = QBCore.Functions.GetPlayer(source)

    if QBCore.Functions.HasPermission(source, 'admin') then
        TriggerClientEvent('spawnCar', source, model)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Du har inte behörighet att använda detta kommando.', 'error')
    end
end)



QBCore.Commands.Add('toggleid', 'Visa eller dölj Steam-namn och ID över spelare', {}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)

    if QBCore.Functions.HasPermission(source, 'admin') then
        TriggerClientEvent('togglePlayerIDs', source)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Du har inte behörighet att använda detta kommando.', 'error')
    end
end)




AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then

        -- Lägg till förslag för befintliga kommandon
        TriggerClientEvent('chat:addSuggestion', -1, '/goto', 'Teleportera till en spelare', {
            { name = 'id', help = 'Spelarens ID' }
        })

        TriggerClientEvent('chat:addSuggestion', -1, '/bring', 'Ta en spelare till dig', {
            { name = 'id', help = 'Spelarens ID' }
        })


        TriggerClientEvent('chat:addSuggestion', -1, '/kick', 'Sparka en spelare från servern', {
            { name = 'id', help = 'Spelarens ID' },
            { name = 'reason', help = 'Anledning' }
        })

        TriggerClientEvent('chat:addSuggestion', -1, '/car', 'Spawna en bil framför dig', {
            { name = 'model', help = 'Modellnamn på fordonet' }
        })
    end
end)

assert(GetCurrentResourceName() == "rico_commands", "The Script can't start because you have changed the name of it!")
