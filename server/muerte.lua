
print("funciona server muerte.lua")
local ESX = exports['es_extended']:getSharedObject()
local IsDead = false


AddEventHandler('playerSpawned', function(spawn)
    IsDead = false
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    TriggerClientEvent('gmainlobbyaudio', source, 7, 5)
    data.victim = source
    IsDead = true

    if data.killedByPlayer then
        local datos = GetPlayerName(data.victim) .. 'has muerto por ' .. GetPlayerName(data.killerServerId) .. ' desde ' .. data.distance .. ' unidades'
        nombre = GetPlayerName(data.victim)
        nombreDeKiller = GetPlayerName(data.killerServerId)
        TriggerClientEvent('gmainlobbymsg', source, 'muerte', 'info', datos)
        TriggerClentEvent('muerte:gmainlobby', source, nombre, nombreDeKiller)
    else
       local datos = GetPlayerName(data.victim) .. ' murio'
       TriggerClientEvent('gmainlobbymsg', source, 'muerte', 'info', datos)
       TriggerClientEvent('muerte:gmainlobby', source, datos)
    end
end)

