ESX = Core
QBCore = Core

-- Buy here: (4€+VAT) https://store.brutalscripts.com
function notification(title, text, time, type)
    if Config.BrutalNotify then
        exports['brutal_notify']:SendAlert(title, text, time, type)
    else
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(0,1)
        TriggerEvent('QBCore:Notify', text, 'info', 5000)
    end
end

function TextUIFunction(type, text)
    if type == 'open' then
        if Config.TextUI:lower() == 'ox_lib' then
            lib.showTextUI(text)
        elseif Config.TextUI:lower() == 'okoktextui' then
            exports['okokTextUI']:Open(text, 'darkblue', 'right')
        elseif Config.TextUI:lower() == 'esxtextui' then
            ESX.TextUI(text)
        elseif Config.TextUI:lower() == 'qbdrawtext' then
            exports['qb-core']:DrawText(text,'left')
        end
    elseif type == 'hide' then
        if Config.TextUI:lower() == 'ox_lib' then
            lib.hideTextUI()
        elseif Config.TextUI:lower() == 'okoktextui' then
            exports['okokTextUI']:Close()
        elseif Config.TextUI:lower() == 'esxtextui' then
            ESX.HideUI()
        elseif Config.TextUI:lower() == 'qbdrawtext' then
            exports['qb-core']:HideText()
        end
    end
end

function ProgressBarFunction(time, text)
    if Config.ProgressBar:lower() == 'progressbars' then --LINK: https://github.com/EthanPeacock/progressBars/releases/tag/1.0
        exports['progressBars']:startUI(time, text)
    elseif Config.ProgressBar:lower() == 'mythic_progbar' then -- LINK: https://github.com/HarryElSuzio/mythic_progbar
        TriggerEvent("mythic_progbar:client:progress", {name = "policejobduty", duration = time, label = text, useWhileDead = false, canCancel = false})
    elseif Config.ProgressBar:lower() == 'progressbar' then -- LINK: https://github.com/SWRP-PUBLIC/pogressBar
        exports['pogressBar']:drawBar(time, text)
    end
end

function InventoryOpenFunction(type, data)
    if type == 'society' then
        local job = data
        if Config.Inventory:lower() == 'ox_inventory' then
            exports.ox_inventory:openInventory('stash', 'society_'..data)
        elseif Config.Inventory:lower() == 'qb_inventory' then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
            TriggerEvent("inventory:client:SetCurrentStash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
        elseif Config.Inventory:lower() == 'quasar_inventory' then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
            TriggerEvent("inventory:client:SetCurrentStash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
        elseif Config.Inventory:lower() == 'chezza_inventory' then
            TriggerEvent('inventory:openStorage', "Locker", job.."_locker", 1000, 1000, {job})
        end
    elseif type == 'search_player' then
        local target = data
        if Config.Inventory:lower() == 'ox_inventory' then
            exports.ox_inventory:openInventory('player', target)
        elseif Config.Inventory:lower() == 'qb_inventory' then
            TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", target)
        elseif Config.Inventory:lower() == 'quasar_inventory' then
            TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", target)
        elseif Config.Inventory:lower() == 'chezza_inventory' then
            TriggerServerEvent("inventory:openPlayerInventory", target, true)
        end
    elseif type == 'search_vehicle_trunk' then
        local vehicle = data
        local plate = GetVehicleNumberPlateText(vehicle)

        if Config.Inventory:lower() == 'ox_inventory' then
            exports.ox_inventory:openInventory('trunk', {id='trunk'..plate, netid = NetworkGetNetworkIdFromEntity(vehicle)})
        elseif Config.Inventory:lower() == 'qb_inventory' then
            TriggerServerEvent("inventory:server:OpenInventory", "trunk", plate, {maxweight = 1000000, slots = 50})
        elseif Config.Inventory:lower() == 'quasar_inventory' then
            TriggerServerEvent("inventory:server:OpenInventory", "trunk", plate, {maxweight = 1000000, slots = 50})
        elseif Config.Inventory:lower() == 'chezza_inventory' then
            TriggerEvent('inventory:openInventory', {type = "trunk", id = plate, title = "Vehicle Trunk", weight = false, delay = 300, save = true})
        end
    elseif type == 'search_vehicle_glovebox' then
        local vehicle = data
        local plate = GetVehicleNumberPlateText(vehicle)

        if Config.Inventory:lower() == 'ox_inventory' then
            exports.ox_inventory:openInventory('glovebox', {id='glovebox'..plate, netid = NetworkGetNetworkIdFromEntity(vehicle)})
        elseif Config.Inventory:lower() == 'qb_inventory' then
            TriggerServerEvent("inventory:server:OpenInventory", "glovebox", plate)
        elseif Config.Inventory:lower() == 'quasar_inventory' then
            TriggerServerEvent("inventory:server:OpenInventory", "glovebox", plate)
        elseif Config.Inventory:lower() == 'chezza_inventory' then
            TriggerEvent('inventory:openInventory', {type = "glovebox", id = plate, title = "Vehicle Glove Box", weight = false, delay = 300, save = true})
        end
    end
end

function PlayerReviveFunction()
    if Config['Core']:upper() == 'ESX' then
        TriggerEvent('esx_ambulancejob:revive')
    elseif Config['Core']:upper() == 'QBCORE' then
        TriggerEvent('hospital:client:Revive')
    end
end

function ImpoundDeleteVehicle(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    DeleteEntity(vehicle)
end

function HandCuffedEvent(cuffed)
    if cuffed then
        --exports['qs-smartphone']:canUsePhone(false)
    else
        --exports['qs-smartphone']:canUsePhone(true)
    end
end

function BulletProofVest()
    local playerPed = PlayerPedId()

    AddArmourToPed(playerPed, 100)
    SetPedArmour(playerPed, 100)
    SetPedComponentVariation(playerPed, 9, 27, 9, 2)
end

function OpenCloakroomMenuEvent()
    TriggerEvent('qb-clothing:client:openOutfitMenu')
end

function CitizenWear()
    if Config['Core']:upper() == 'ESX' then
        Core.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    elseif Config['Core']:upper() == 'QBCORE' then
       TriggerEvent('qb-clothing:client:openOutfitMenu')
    end
end

function setUniform(uniformTable)
    if Config['Core']:upper() == 'ESX' then
        TriggerEvent('skinchanger:getSkin', function(skin)
            local uniform
            if skin.sex == 0 then
                uniform = uniformTable.male
            else
                uniform = uniformTable.female
            end

            local table = {}

            for k,v in pairs(uniform) do
                if k == 't-shirt' then
                    table.tshirt_1 = uniform['t-shirt'].item
                    table.tshirt_2 = uniform['t-shirt'].texture
                elseif k == 'torso2' then
                    table.torso_1 = uniform['torso2'].item
                    table.torso_2 = uniform['torso2'].texture
                elseif k == 'decals' then
                    table.decals_1 = uniform['decals'].item
                    table.decals_2 = uniform['decals'].texture
                elseif k == 'arms' then
                    table.arms = uniform['arms'].item
                elseif k == 'pants' then
                    table.pants_1 = uniform['pants'].item
                    table.pants_2 = uniform['pants'].texture
                elseif k == 'shoes' then
                    table.shoes_1 = uniform['shoes'].item
                    table.shoes_2 = uniform['shoes'].texture
                elseif k == 'hat' then
                    table.helmet_1 = uniform['hat'].item
                    table.helmet_2 = uniform['hat'].texture
                elseif k == 'accessory' then
                    table.chain_1 = uniform['accessory'].item
                    table.chain_2 = uniform['accessory'].texture
                elseif k == 'ear' then
                    table.ears_1 = uniform['ear'].item
                    table.ears_2 = uniform['ear'].texture
                elseif k == 'mask' then
                    table.mask_1 = uniform['mask'].item
                    table.mask_2 = uniform['mask'].texture
                end
            end

            TriggerEvent('skinchanger:loadClothes', skin, table)
        end)
    elseif Config['Core']:upper() == 'QBCORE' then
        local table = {}
        local gender = QBCore.Functions.GetPlayerData().charinfo.gender
        if gender == 0 then
            table.outfitData = uniformTable.male
        else
            table.outfitData = uniformTable.female
        end

        TriggerEvent('qb-clothing:client:loadOutfit', table)
    end
end

function LockPick(vehicle)
    if Config['Core']:upper() == 'ESX' then
        local playerPed = PlayerPedId()
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
        Wait(1000*10)
        ClearPedTasksImmediately(playerPed)

        NetworkRegisterEntityAsNetworked(vehicle)
        NetworkRequestControlOfEntity(vehicle)
        SetEntityAsMissionEntity(vehicle)

        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
    elseif Config['Core']:upper() == 'QBCORE' then
        TriggerEvent('lockpicks:UseLockpick')
    end
end

function DisableMinimap()
    DisplayRadar(false)
end

function EnableMinimap()
    DisplayRadar(true)
end

function OpenMenuUtil()
    InMenu = true
    SetNuiFocus(true, true)

    Citizen.CreateThread(function()
        while InMenu do
            N_0xf4f2c0d4ee209e20() -- it's disable the AFK camera zoom
            Citizen.Wait(15000)
        end 
    end)

    DisplayRadar(false)
end

function CloseMenuUtil()
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        InMenu = false
    end)

    SetNuiFocus(false, false)

    DisplayRadar(true)
end

function GeneratePolicePlace()
    return string.sub(PlayerData.job.label, 1, 4)..''..math.random(0001, 9999)
end

-----------------------| UTILS TRIGGERS |-----------------------

RegisterNetEvent('brutal_policejob:client:utils:CreateVehicle')
AddEventHandler('brutal_policejob:client:utils:CreateVehicle', function(Vehicle)
    SetVehicleFuelLevel(Vehicle, 100.0)
    DecorSetFloat(Vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(Vehicle))

    if Config['Core']:upper() == 'QBCORE' then
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(Vehicle))
    end
end)

RegisterNetEvent('brutal_policejob:client:utils:DeleteVehicle')
AddEventHandler('brutal_policejob:client:utils:DeleteVehicle', function(Vehicle)

end)