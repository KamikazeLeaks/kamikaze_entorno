--[[

KAMIKAZELEAKS

--]]

displayTime = 300 -- Actualiza Blips cada 5 minutos de forma predeterminada -  
ondutycommand = 'onduty' -- Cambie esto si ya tiene un comando 'onduty' ya configurado -
passwordmode = true -- Cambiando esto a 'falso' hará que necesite una contraseña para estar en servicio - {Para que el 'passwordmode' y la 'password' funcionen, debe tener 'modo onduty' establecido en 'true'} -
password = '123' -- Cambie esto a su contraseña deseada - {Para que el 'passwordmode' y la 'password' funcionen, debe tener 'modo onduty' configurado en 'true'} -

--- CODIGO

blip = nil
blips = {}

local onduty = false

RegisterCommand(ondutycommand, function(source, args)
    if passwordmode then 
        if args[1] == password then
            if not onduty then 
                onduty = true
                TriggerEvent('chatMessage', '', {255,255,255}, '^2Tu estas ahora en ^*Servicio^r^2 y puede recibir llamadas de entorno.')
            else
                onduty = false
                TriggerEvent('chatMessage',  '', {255,255,255}, '^1Tu estas ahora  ^*Fuera de Servicio^r^1 y ya no podrá recibir llamadas de entorno.')
            end
        else
            TriggerEvent('chatMessage', '', {255,255,255}, '^1Contraseña incorrecta')
        end
    else
        if not onduty then 
            onduty = true
            TriggerEvent('chatMessage', '', {255,255,255}, '^2Tu estas en ^*Servicio^r^2 y puede recibir llamadas de entorno.')
        else
            onduty = false
            TriggerEvent('chatMessage', '', {255,255,255}, '^1Estas ahora ^*Fuera de Servicio^r^1 y ya no podrá recibir llamadas de entorno.')
        end
    end 
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/entorno', 'Envia una llamada de entorno a las unidades de Emergencia!', {
    { name="Report", help="Pon aqui lo que a sucedido" }
})
end)

RegisterNetEvent('entorno:setBlip')
AddEventHandler('entorno:setBlip', function(name, x, y, z)
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 66)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Entorno - ' .. name)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
    Wait(displayTime * 1000)
    for i, blip in pairs(blips) do 
        RemoveBlip(blip)
    end
end)

RegisterNetEvent('entorno:sendtoteam')
AddEventHandler('entorno:sendtoteam', function(name, location, msg, x, y, z)
    if onduty then 
        TriggerServerEvent('entorno:sendmsg', name, location, msg, x, y, z)
    end
end)

-- Comando

RegisterCommand('entorno', function(source, args)
    local name = GetPlayerName(PlayerId())
    local ped = GetPlayerPed(PlayerId())
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local street = GetStreetNameAtCoord(x, y, z)
    local location = GetStreetNameFromHashKey(street)
    local msg = table.concat(args, ' ')
    if args[1] == nil then
        TriggerEvent('chatMessage', '^Llamada de Entorno', {255,255,255}, ' ^7Porfavor inserte su ^1situacion.')
    else
        TriggerServerEvent('entorno', location, msg, x, y, z, name)
    end
end)

