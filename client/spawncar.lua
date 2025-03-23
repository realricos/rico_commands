RegisterNetEvent('spawnCar', function(model)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    
    local vehicleModel = GetHashKey(model)
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Wait(500)
    end

    local forwardVector = GetEntityForwardVector(playerPed)
    local spawnPos = playerPos + forwardVector * 5.0

    local vehicle = CreateVehicle(vehicleModel, spawnPos.x, spawnPos.y, spawnPos.z, GetEntityHeading(playerPed), true, false)
    
    local plate = "ADMIN" -- Sätt nummerplåten här
    SetVehicleNumberPlateText(vehicle, plate)

    SetModelAsNoLongerNeeded(vehicleModel)

    local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) 
    exports['qs-vehiclekeys']:GiveKeys(plate, modelName, true) 
end)
