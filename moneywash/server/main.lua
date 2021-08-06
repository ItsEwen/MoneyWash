local PlayersWashing = {}

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('playerDropped', function()
	PlayersWashing[source] = nil
end)

local function WashMoney(xPlayer)
	SetTimeout(3000, function()
		if #(GetEntityCoords(GetPlayerPed(xPlayer.source)) - MoneyWash.Pos) < 10 then
			if PlayersWashing[xPlayer.source] then
				local xAccount = xPlayer.getAccount('dirtycash')

				if xAccount.money < MoneyWash.Slice then
					TriggerClientEvent('::{korioz#0110}::esx:showNotification', xPlayer.source, ('~b~SeaLife ~w~~n~Vous n\'avez pas assez d\'argent pour blanchir, il vous faut : $%s'):format(MoneyWash.Slice))
				else
					local washedMoney = math.floor(MoneyWash.Slice / MoneyWash.Percentage)
						
					xPlayer.removeAccountMoney('dirtycash', MoneyWash.Slice)
					xPlayer.addAccountMoney('cash', washedMoney)

					WashMoney(xPlayer)
				end
			end
		else
			DropPlayer(xPlayer.source, 'Désynchronisation avec le serveur ou detection de Cheat')
		end
	end)
end

RegisterServerEvent('::{korioz#0110}::esx_moneywash:startWash')
AddEventHandler('::{korioz#0110}::esx_moneywash:startWash', function()
	PlayersWashing[source] = true
	TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, 'Vous êtes en train de blanchir l\'argent sale.')
	WashMoney(ESX.GetPlayerFromId(source))
end)

RegisterServerEvent('::{korioz#0110}::esx_moneywash:stopWash')
AddEventHandler('::{korioz#0110}::esx_moneywash:stopWash', function()
	PlayersWashing[source] = nil
end)