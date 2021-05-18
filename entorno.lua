--[[

KAMIKAZELEAKS

--]]

displayLocation = true  -- Si cambias a 'false' hara que no salga la ubicacion en el chat 
blips = true -- Si cambias a  'false' desabilitara las llamadas de entorno con blips haciendo que la ubicacion no se muestre en el mapa
disableChatCalls = false -- Al cambiar esto a 'false', la llamada al /entorno no se mostrará en el chat (se recomienda tener la configuración de Discord Webhook para deshabilitar esto) 

ondutymode = false -- Al cambiar esto a 'true', solo los Servicios de Emergencia y las personas que han usado el comando 'de guardia' pueden ver las llamadas y señales acústicas al 911:

--  CODIGO

local onduty = false

RegisterServerEvent('entorno')
AddEventHandler('entorno', function(location, msg, x, y, z, name, ped)
	local playername = GetPlayerName(source)
	local ped = GetPlayerPed(source)
	if displayLocation == false then
		if disableChatCalls == false then
			TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^*^4Entorno | Identificador: ^r' .. playername .. '^*^4 | Reportado: ^r' .. msg)
			sendDiscord('Entorno', '**Entorno | Identificador: **' .. playername .. '** | Reportado: **' .. msg)  
		else
			sendDiscord('Entorno ', '**Entorno | Identificador: **' .. playername .. '** | Reportado: **' .. msg)  
		end
	else
		if disableChatCalls == false then
			if ondutymode then
				TriggerClientEvent('entorno:sendtoteam', -1, playername, location, msg, x, y, z)
				TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^4Entorno | Identificador: ^r' .. playername .. '^*^4 | Localizacion: ^r' .. location .. '^*^4 | Reportado: ^r' .. msg)
				TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1Esta llamada ha sido enviada a los servicios de Emergencia.')
			else 
				TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^*^4911 | Identificador: ^r' .. playername .. '^*^4 | Localizacion: ^r' .. location .. '^*^4 | Reportado: ^r' .. msg)
			end
			sendDiscord('Entorno', '**Entorno | Identificador: **' .. playername .. '** | Localizacion: **' .. location .. '** | Reportado: **' .. msg)
		else
			sendDiscord('Entorno', '**Entorno | Identificador: **' .. playername .. '** | Localizacion: **' .. location .. '** | Reportado: **' .. msg)
		end
		if blips == true then
			if not ondutymode then
				TriggerClientEvent('entorno:setBlip', -1, name, x, y, z)
			end 
		end
	end
end)

RegisterServerEvent('entorno:sendmsg')
AddEventHandler('entorno:sendmsg', function(name, location, msg, x, y, z)
	TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^3Base: ^Entorno |  Identificador: ^r' .. name .. '^*^4 | Localizacion: ^r' .. location .. '^*^4 | Reportado: ^r' .. msg)
	if blips then
		TriggerClientEvent('entorno:setBlip', source, name, x, y, z)
	end
end)

-- Log discord

function sendDiscord(name, message)
	local content = {
        {
        	["color"] = '5015295',
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Comando de /entorno",
            },
        }
    }
  	PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end


	
