print("funciona server.lua")
local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('obtenerDatosMusica', function(source, cb, id)
    local src = source
    local musicaId = id
    --print("[server] id = " .. musicaId)
    MySQL.Async.fetchAll('SELECT * FROM `musica` WHERE id = @id', {['@id'] = musicaId}, function(result)
        if result[1] then
            cb(result[1])
        else
            cb(result[nil])
        end        
    end)
end)

ESX.RegisterServerCallback("obtenerUsuarioAdmin", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
                  
    if xPlayer.getGroup() == 'admin' then
        cb(true)
    else
        cb(false)
    end
end)


ESX.RegisterServerCallback("obtenerUsuarioDinero", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local banco = xPlayer.getAccount('bank').money   
    --print(banco)     
    if banco then
        cb(banco)
    else
        cb(banco)
    end
end)

ESX.RegisterServerCallback("obtenerUsuarioPesoMax", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local banco = xPlayer.getAccount('bank').money   
    --print(banco)     
    if banco then
        cb(banco)
    else
        cb(banco)
    end
end)



