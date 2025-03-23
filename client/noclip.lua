local QBCore = exports['qb-core']:GetCoreObject()

local noclip = false
local noclip_speed = 1.0

function getPosition()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    return x, y, z
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end

Citizen.CreateThread(function()
    local ped
    local x, y, z
    local dx, dy, dz
    local speed

    while true do
        Citizen.Wait(0)

        if noclip then
            ped = PlayerPedId()

            x, y, z = getPosition()
            dx, dy, dz = getCamDirection()
            speed = noclip_speed

            SetEntityVisible(ped, false, false)
            SetEntityInvincible(ped, true)
            SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001) 

            if IsControlPressed(0, 21) then  -- Shift
                speed = speed + 3
            end

            if IsControlPressed(0, 19) then  -- Alt
                speed = speed - 0.5
            end

            if IsControlPressed(0, 32) then
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end

            if IsControlPressed(0, 269) then
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        else
            if ped then
                SetEntityVisible(ped, true, false)
                SetEntityInvincible(ped, false)
                ped = nil
            end
        end
    end
end)

RegisterNetEvent('toggleNoclip', function()
    noclip = not noclip  

    local msg = "NoClip avaktiverat"
    if noclip then
        msg = "NoClip aktiverat"
    end

    SetEntityVisible(PlayerPedId(), not noclip, false)

    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"SYSTEM", msg}
    })
end)
