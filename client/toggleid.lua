local showIDs = false

RegisterNetEvent('togglePlayerIDs')
AddEventHandler('togglePlayerIDs', function()
    showIDs = not showIDs
    if showIDs then
        TriggerEvent('chat:addMessage', {
            color = { 0, 255, 0 },
            multiline = true,
            args = {"SYSTEM", "Toggle id aktiverat"}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = { 0, 255, 0 },
            multiline = true,
            args = {"SYSTEM", "Toggle id avaktiverat"}
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        if showIDs then
            local players = GetActivePlayers()
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            local myServerId = GetPlayerServerId(PlayerId())

            for _, playerId in ipairs(players) do
                local targetPed = GetPlayerPed(playerId)
                local targetPos = GetEntityCoords(targetPed)
                local distance = #(playerPos - targetPos)
                local serverId = GetPlayerServerId(playerId)

                if serverId ~= myServerId and distance < 100.0 then
                    local steamName = GetPlayerName(playerId)
                    local headPos = GetPedBoneCoords(targetPed, 31086, 0.15, 0.0, 0.0)

                    if NetworkIsPlayerTalking(playerId) then
                        DrawText3D(headPos.x, headPos.y, headPos.z + 0.5, "~g~" .. steamName .. " ~g~| " .. serverId) -- Grönt om pratar
                    else
                        DrawText3D(headPos.x, headPos.y, headPos.z + 0.5, "~w~" .. steamName .. " ~w~| " .. serverId) -- Vitt som standard
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local dist = #(GetGameplayCamCoords() - vector3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.60 * scale, 0.60 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
