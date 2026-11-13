AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    -- Schaltet die NUI explizit beim Skriptstart ein
    SendNUIMessage({
        action = "showHUD",
        status = true
    })
end)

local hunger = 100
local thirst = 100

-- ESX / QB-Core Status Event
RegisterNetEvent('esx_status:onTick')
AddEventHandler('esx_status:onTick', function(status)
    if type(status) == 'table' then
        for _, v in pairs(status) do
            if v.name == 'hunger' then hunger = v.percent end
            if v.name == 'thirst' then thirst = v.percent end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)

        local ped = PlayerPedId()
        
        -- Sicherer Ped-Health-Check
        local rawHealth = GetEntityHealth(ped)
        local health = 0
        if rawHealth > 100 then
            health = rawHealth - 100
        elseif rawHealth > 0 then
            health = rawHealth
        end

        local armor = GetPedArmour(ped)

        -- Absicherung gegen Native-Absturz 0xA61C8FC6
        local coords = GetEntityCoords(ped)
        local streetName = "Unknown"
        
        if coords then
            local streetHash, crossHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            
            -- Prüft explizit auf Existenz, Typ und ungleich 0
            if streetHash and type(streetHash) == "number" and streetHash ~= 0 then
                local name = GetStreetNameFromHashKey(streetHash)
                if name and name ~= "" then
                    streetName = name
                end
            end
        end

        -- HUD Daten an NUI senden
        SendNUIMessage({
            action = "updateHUD",
            health = health,
            armor = armor,
            hunger = hunger,
            thirst = thirst,
            cash = 50100273, -- Hier bei Bedarf xPlayer.getMoney() einbinden
            bank = 50100273, -- Hier bei Bedarf xPlayer.getAccount('bank').money
            street = streetName
        })

        -- Fahrzeug Tacho Logik
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            local speed = 0
            if DoesEntityExist(veh) then
                speed = GetEntitySpeed(veh) * 3.6 -- m/s zu KM/H
            end

            SendNUIMessage({
                action = "updateSpeed",
                inVehicle = true,
                speed = speed
            })
        else
            SendNUIMessage({
                action = "updateSpeed",
                inVehicle = false,
                speed = 0
            })
        end
    end
end)