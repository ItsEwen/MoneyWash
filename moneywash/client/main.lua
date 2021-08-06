Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

local inBlanchiment = false
local Counter = false
Citizen.CreateThread(function()
	while true do
		local isProche = false
		local dist = Vdist2(GetEntityCoords(PlayerPedId(), false), MoneyWash.Pos)


		if dist > 50 then
			if inBlanchiment then
				TriggerServerEvent('::{korioz#0110}::esx_moneywash:stopWash')
				inBlanchiment = false
				ESX.ShowNotification('~b~SeaLife ~w~~n~Vous vous êtes éloigner du points')
				Counter = true
			end
		end
		if dist < 50 then
			isProche = true
			DrawMarker(25, MoneyWash.Pos.x, MoneyWash.Pos.y, MoneyWash.Pos.z-0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.55, 0.55, 0.55, 255, 147, 0, 255, false, false, 2, false, false, false, false)
		end
		if dist < 3 then
			ESX.ShowHelpNotification("~b~SeaLife\n~b~Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
			if IsControlJustPressed(1,51) then
				if not inBlanchiment then
					if not Counter then
						inBlanchiment = true
						TriggerServerEvent('::{korioz#0110}::esx_moneywash:startWash')
					else
						ESX.ShowNotification('~b~SeaLife ~y~~n~ANTI GLITCH~n~~w~Vous allez trop vite pour le système')
					end
				else
					TriggerServerEvent('::{korioz#0110}::esx_moneywash:stopWash')
					inBlanchiment = false
					ESX.ShowNotification('~b~SeaLife ~w~~n~Vous avez arrêter de blanchir')
					Counter = true
				end
			end
		end
		
		if inBlanchiment then
			isProche = true
			DrawMissionText("~g~Appuyez sur ~w~E ~g~pour arrêter l\'activité", 100)
		end

		if isProche then
			Wait(0)
		else
			Wait(750)
		end
	end
end)

Citizen.CreateThread(function()
	while true do 
		Wait(5000)
		Counter = false
	end
end)

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end