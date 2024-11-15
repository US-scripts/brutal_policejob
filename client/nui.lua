RegisterNUICallback("UseButton", function(data)
	if data.action == 'close' then
		CloseMenuUtil()

		if DoesEntityExist(tab) then
			DeleteEntity(tab)
			ClearPedTasks(GetPlayerPed(-1))
		end
	elseif data.action == 'SetDress' then
		if data.id == 'citizen_wear' then
			CitizenWear()
		else
			local id = tonumber(data.id)
			setUniform(Config.Uniforms[id])
		end
	elseif data.action == 'Armory' then
		CloseMenuUtil()
		InventoryOpenFunction('society', PlayerData.job.name)
	elseif data.action == 'Buy' then
		local Table = {}
		for k,v in pairs(Config.PoliceStations) do
			if v.Job == PlayerData.job.name then
				for _k,_v in pairs(v.Shop) do
					if PlayerData.job.grade >= _v.minGrade then
						table.insert(Table, _v)
					end
				end
				OpenMenuUtil()
				SendNUIMessage({action = "OpenShopMenu", items = Table, moneyform = Config.MoneyForm, card = true})
			end
		end
	elseif data.action == 'SpawnVehicle' then
		CreateVehicleFunction(data.model, tonumber(data.livery), SpawnCoords)
	elseif data.action == 'PoliceMenu' then
		PoliceMenuInteractions(tonumber(data.number), data.id)
	elseif data.action == 'PoliceMenuObject' then
		PoliceMenuInteractions(3)
	elseif data.action == 'PoliceMenuSetObject' then
		if PlacingObject then
			ObjectType = data.id
			CreateDemoObject()
		end
	elseif data.action == 'MDTGetData' then
		TSCB('brutal_policejob:server:policeDatabaseGetData', function(cbdata)
			local DataTable = cbdata.table
	
			if #DataTable > 0 then
				if cbdata.type == 'plate' then
					for k,v in pairs(DataTable) do
						if type(v.model) == 'number' then
							v.model = GetDisplayNameFromVehicleModel(v.model):lower()
						end
	
						v.class = VehicleClasses[GetVehicleClassFromName(v.model)]
					end
				end

				for k,v in pairs(DataTable) do
					if v.sex ~= nil then
						if v.sex == 'm' or tonumber(v.sex) == 0 then
							v.sex = Config.Locales.Male
						else
							v.sex = Config.Locales.Female
						end
					end
				end

				SendNUIMessage({action = "RefreshMDTMenu", table = DataTable})
			else
				SendNUIMessage({action = "RefreshMDTMenu", table = DataTable})
			end
		end, data.type, data.value1, data.value2)
	elseif data.action == 'MDTUserAction' then
		if data.type == 'jail_mdt' then
			TriggerServerEvent('brutal_policejob:server:policeMenuEvent', data.TargetIdentifier, 'jail', tonumber(data.time), data.reason)
			TriggerServerEvent('brutal_policejob:server:AddNewNote', data.TargetIdentifier, '<b>'..Config.Locales.Jail..'</b> <br>'..Config.Locales.Time..': '..tonumber(data.time)..', '..Config.Locales.Reason..': '..data.reason)

			Citizen.Wait(100)
			TSCB('brutal_policejob:server:GetNotes', function(NotesTable)
				SendNUIMessage({action = "MDTRefreshNotes", table = NotesTable})
			end, data.TargetIdentifier)

		elseif data.type == 'jail_marker' then
			CloseMenuUtil()
			TriggerServerEvent('brutal_policejob:server:policeMenuEvent', tonumber(data.TargetIdentifier), 'jail', tonumber(data.time), data.reason)
		elseif data.type == 'unjail' then
			TriggerServerEvent('brutal_policejob:server:policeMenuEvent', data.TargetIdentifier, 'unjail')
		elseif data.type == 'givefine' then
			TriggerServerEvent('brutal_policejob:server:GiveFine', PlayerData.job.name, PlayerData.job.label, data.TargetIdentifier, data.name, data.amount, data.targetname)
		elseif data.type == 'showfines' then
			TSCB('brutal_policejob:server:GetFines', function(FinesTable)
				SendNUIMessage({action = "MDTShowFines", table = FinesTable})
			end, data.TargetIdentifier)
		elseif data.type == 'getlicences' then
			TSCB('brutal_policejob:server:GetLincences', function(LicencesTable)
				local LTable = {}
				if LicencesTable == false then
					LTable = 'false'
				elseif #LicencesTable == 0 then
					LTable = 'none'
				else
					for k,v in pairs(LicencesTable) do
						if Config.Licences[v] ~= nil then
							table.insert(LTable, {type = v, label = Config.Licences[v]})
						else
							table.insert(LTable, {type = v, label = v})
						end
					end
				end

				SendNUIMessage({action = "MDTShowLicences", table = LTable})
			end, data.TargetIdentifier)
		elseif data.type == 'removelicence' then
			TriggerServerEvent('brutal_policejob:server:RemoveLicence', data.TargetIdentifier, data.LicenceType)
		elseif data.type == 'createnote' then
			TriggerServerEvent('brutal_policejob:server:AddNewNote', data.TargetIdentifier, data.Text)

			Citizen.Wait(100)
			TSCB('brutal_policejob:server:GetNotes', function(NotesTable)
				SendNUIMessage({action = "MDTRefreshNotes", table = NotesTable})
			end, data.TargetIdentifier)
		elseif data.type == 'edit_photo' then
			TriggerServerEvent('brutal_policejob:server:AddUserPhoto', data.TargetIdentifier, data.Url)
		end
	elseif data.action == 'MDTVehicleAction' then
		if data.type == 'edit_photo' then
			TriggerServerEvent('brutal_policejob:server:AddVehiclePhoto', data.Plate, data.Url)
		elseif data.type == 'createnote' then
			TriggerServerEvent('brutal_policejob:server:AddNewVehicleNote', data.Plate, data.Text)

			Citizen.Wait(100)
			TSCB('brutal_policejob:server:GetVehicleNotes', function(NotesTable)
				SendNUIMessage({action = "MDTRefreshNotes", table = NotesTable})
			end, data.Plate)
		end
	elseif data.action == 'MDTCitizenCall' then
		if data.type == 'getcalls' then
			TSCB('brutal_policejob:server:GetCitizenCalls', function(CitizenCalls)
				SendNUIMessage({action = "MDTGetCitizenCalls", table = CitizenCalls, myid = GetPlayerServerId(PlayerId())})
			end)
		elseif data.type == 'create' then
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			streetLabel = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
			TriggerServerEvent('brutal_policejob:server:citizencall', data.type, data.text, {x,y,z}, streetLabel, data.time)
		elseif data.type == 'accept' then
			TriggerServerEvent('brutal_policejob:server:citizencall', data.type, data.tableid)
		elseif data.type == 'blip' then
			if CallBlips[data.tableid] == nil then
				local CallBlip = AddBlipForCoord(data.coords[1], data.coords[2], data.coords[3])
				SetBlipSprite(CallBlip, 66)
				SetBlipColour(CallBlip, 1)
				SetBlipScale(CallBlip, 0.65)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName('Call #'..data.tableid)
				EndTextCommandSetBlipName(CallBlip)
				SetBlipAsShortRange(CallBlip, true)
				
				SetNewWaypoint(data.coords[1], data.coords[2])
				

				CallBlips[data.tableid] = CallBlip
			end
		elseif data.type == 'close' then
			TriggerServerEvent('brutal_policejob:server:citizencall', data.type, data.tableid, data.text)
		end
	elseif data.action == 'AreaLock' then
		TriggerServerEvent('brutal_policejob:server:arealock', GetEntityCoords(GetPlayerPed(-1)), data.label, tonumber(data.time), tonumber(data.range), tonumber(data.sprite))
	elseif data.action == 'BuyInShop' then
		local BuyItems = data.BuyItems
        local BuyItemsTable = {}
        local TotalMoney = 0
        for i = 1, #BuyItems do
            TotalMoney += BuyItems[i][2]*BuyItems[i][3]
            table.insert(BuyItemsTable, {item = BuyItems[i][1], label = BuyItems[i][4], amount = BuyItems[i][2], price = BuyItems[i][3]})
        end

        TSCB('brutal_policejob:server:GetPlayerMoney', function(wallet)
			local PlayerMoney = 0
			if data.paytype == 'money' then
				PlayerMoney = wallet.money
			else
				PlayerMoney = wallet.bank
			end

            if PlayerMoney >= TotalMoney and #BuyItemsTable ~= 0 then
                TriggerServerEvent('brutal_policejob:server:AddItem', BuyItemsTable, data.paytype)
            else
                SendNotify(10)
            end
        end)
	elseif data.action == 'ActivateCamera' then
		TriggerEvent('brutal_policejob:client:ActivateCamera', tonumber(data.cameraid))
	end
end)