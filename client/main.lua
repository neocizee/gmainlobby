print("funciona client main.lua")
xSound = exports.xsound
local nuevo = false
local ESX = nil

if GetResourceState('es_extended') == 'started' then

    ESX = exports['es_extended']:getSharedObject()

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
        ESX = exports['es_extended']:getSharedObject()
        ESX.PlayerData = xPlayer
    end)

    function repMusica(name, link, volumen, tiempo) 
        --exports['okokNotify']:Alert("Audio", "Audio reproducido: " .. name, 5000, 'info')
        xSound:Destroy(name)
        xSound:PlayUrl(name,link,volumen)
        Citizen.Wait(1000*tiempo)
       -- exports['okokNotify']:Alert("Audio", "Audio completado: " .. name, 5000, 'success')
        xSound:Destroy(name)
    end

    function RespawnPed(ped, coords, heading)
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
        SetPlayerInvincible(ped, false)
        ClearPedBloodDamage(ped)
    
        TriggerServerEvent('esx:onPlayerSpawn')
        TriggerEvent('esx:onPlayerSpawn')
        TriggerEvent('playerSpawned')

        reproducirAudio(8, 3)
    end

    function reproducirAudio(id, duracion)
        --print(id, duracion)
        datos = {}
        ESX.TriggerServerCallback('obtenerDatosMusica', function(result)
            if result then
                datos = {
                    id = result['id'],
                    name = result['name'],
                    link = result['link']
                }
                repMusica(datos.name, datos.link, 0.3, duracion) 
            else
                print("error id = " .. id .. " no existe")
            end
            
        end, id)
    end

    function dump(o)
        if type(o) == 'table' then
           local s = '{ '
           for k,v in pairs(o) do
              if type(k) ~= 'number' then k = '"'..k..'"' end
              s = s .. '['..k..'] = ' .. dump(v) .. ','
           end
           return s .. '} '
        else
           return tostring(o)
        end
     end

    RegisterCommand('lobbymenu', function(source, args, showError)
        ESX.TriggerServerCallback('obtenerUsuarioAdmin', function(group)
            ESX = exports['es_extended']:getSharedObject()
            if group then
                if not nuevo then
                    local nombres, nombreId, nombre, inventory, accounts = pcall(function()
                        return ESX.PlayerData.lastName, ESX.PlayerData.firstName, ESX.PlayerData.inventory, ESX.PlayerData.accounts
                    end)
                    print("Nombre: " .. nombre)
                    print("NombreId: " .. nombreId)
                    print("Admin: " .. tostring(group))
                    print("Es nuevo: " .. tostring(nuevo))
                    print("Monedas: " .. accounts[2].money)
                    pesoActual = 0
                    for i=1, #inventory, 1 do
                        if inventory[i].name then
                            if inventory[i].count > 0 then
                                print("Inventario: ".. dump(inventory[i]))
                                pesoActual += inventory[i].weight
                            end
                        end
                    end
                    print("Peso actual = " .. pesoActual)
                    print("Peso maximo = " .. GetConvar('pesoMaximo'))
                end
            else
                print("usuario no es admin" .. tostring(group))
            end
        end)
    end, false)

    RegisterCommand('audio', function(source, args, showError)
        ESX.TriggerServerCallback('obtenerUsuarioAdmin', function(group)
            if group then
                local id = args[1]
                local duracion = args[2]
                reproducirAudio(id, duracion)
                --print("admin: " .. tostring(group))
            else
                print("usuario no es admin" .. tostring(group))
            end
        end)
    end, false)

    RegisterCommand('revivir', function(source, args, showError)
        ESX.TriggerServerCallback('obtenerUsuarioAdmin', function(group)
            if group then
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)

                local formattedCoords = {
                    x = ESX.Math.Round(coords.x, 1),
                    y = ESX.Math.Round(coords.y, 1),
                    z = ESX.Math.Round(coords.z, 1)
                }

                RespawnPed(playerPed, formattedCoords, 0.0)
            else
                print("usuario no es admin ".. tostring(group))
            end
        end)
    end, false)

    RegisterNetEvent('gmainlobbymsg')
	AddEventHandler('gmainlobbymsg', function(titulo, tipo, msg)
        exports['okokNotify']:Alert(titulo, msg, 5000, tipo)
    end)
    RegisterNetEvent('gmainlobbyaudio')
	AddEventHandler('gmainlobbyaudio', function(id, duracion)
        reproducirAudio(id, duracion)
    end)
end
