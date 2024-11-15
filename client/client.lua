-----------------------------------------------------------
--------------------| Get Player Data |--------------------
-----------------------------------------------------------

PlayerData = {}
PlayerData.job = {name = '', label = ''}
SpawnCoords = nil
InDuty = false
InMenu = false
inPrison = false
isCuffed = false
inDrag = false
inVehicle = false
PlacingObject = false
SpamDuty = false
SpamNotify = false
ShowText = false
ObjectType = nil
RemoveObjects = false
CurrentRemoveObject = nil
menuColors = nil
ObjectHeading = 0.0
jailMinute = 0
PrisonGuards = {}
CopsBlip = {}
SpawnedObjects = {}
CallBlips = {}
InDutyTable = {}

if Config.Metric:lower() == 'kmh' then
    metric = 3.6
elseif Config.Metric:lower() == 'mph' then
    metric = 2.236936 
end

VehicleClasses = {
    [0] = 'Compacts',
    [1] = 'Sedans',
    [2] = 'SUVs',
    [3] = 'Coupes',
    [4] = 'Muscle',
    [5] = 'Sports Classics',
    [6] = 'Sports',
    [7] = 'Super',
    [8] = 'Motorcycles',
    [9] = 'Off-road',
    [10] = 'Industrial',
    [11] = 'Utility',
    [12] = 'Vans',
    [13] = 'Cycles',
    [14] = 'Boats',
    [15] = 'Helicopters',
    [16] = 'Planes',
    [17] = 'Service',
    [18] = 'Emergency',
    [19] = 'Military',
    [20] = 'Commercial',
    [21] = 'Trains',
    [22] = 'Open Wheel'
}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
		GetPlayerData()
    end
end)

RegisterNetEvent(LoadedEvent)
AddEventHandler(LoadedEvent, function(playerData)
    Citizen.Wait(5000)
    GetPlayerData()
end)

RegisterNetEvent(JobUpdateEvent, function(NewJob)
    local copbefore = false
    if PlayerCop() then
        copbefore = true
    end

    PlayerData.job.name = NewJob.name
    PlayerData.job.label = NewJob.label

    if Config['Core']:upper() == 'ESX' then
        PlayerData.job.grade = NewJob.grade
        PlayerData.job.grade_label = NewJob.grade_label
        PlayerData.job.salary = NewJob.grade_salary
    elseif Config['Core']:upper() == 'QBCORE' then
        PlayerData.job.grade = NewJob.grade.level
        PlayerData.job.grade_label = NewJob.grade.name
        PlayerData.job.salary = NewJob.payment
    end

    if PlayerCop() and not copbefore then
        inPoliceJob()
    elseif not PlayerCop() then
        PlayerData.cop = false
        InDuty = false
    end
end)

function GetPlayerData()
    TSCB('brutal_policejob:server:getplayerdatas', function(Table)
        PlayerData.name = Table.playername
        jailMinute = Table.jailminute

        if jailMinute ~= nil and jailMinute > 0 then
            inPrison = true
            sendtoJail()
        end
    end)

    local jobdata = GetPlayerJobDatas()

    while jobdata == nil do
        Citizen.Wait(1)
    end

    PlayerData.job = {}
    PlayerData.job.name = jobdata.name
    PlayerData.job.label = jobdata.label

    if Config['Core']:upper() == 'ESX' then
        PlayerData.job.grade = jobdata.grade
        PlayerData.job.grade_label = jobdata.grade_label
        PlayerData.job.salary = jobdata.grade_salary
    elseif Config['Core']:upper() == 'QBCORE' then
        PlayerData.job.grade = jobdata.grade.level
        PlayerData.job.grade_label = jobdata.grade.name
        PlayerData.job.salary = jobdata.payment
    end

    if PlayerCop() then
        inPoliceJob()
    end
end

function PlayerCop()
    PlayerData.cop = false
    for k,v in pairs(Config.PoliceStations) do
        if v.Job == PlayerData.job.name then
            PlayerData.cop = true
            break
        end
    end

    return PlayerData.cop
end

-----------------------------------------------------------
----------------------| While loop |-----------------------
-----------------------------------------------------------

function inPoliceJob()
    inMarker = false

    for k,v in pairs(Config.PoliceStations) do
        if v.Job == PlayerData.job.name then
            menuColors = v.MenuColors
        end
    end

    Citizen.CreateThread(function()
        while PlayerData.cop do
            sleep = 750
            for k,v in pairs(Config.PoliceStations) do
                if v.Job == PlayerData.job.name then
                    local nearMarker = false
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)

                    if not IsPedInAnyVehicle(playerPed, false) then

                        -- Duty --
                        if #(playerCoords - v.Duty) < 1.5 then
                            sleep = 1

                            inMarker = true
                            nearMarker = true

                            if not ShowText and not InMenu then
                                if not InDuty then
                                    TextUIFunction('open', Config.Texts[5][1])
                                    ShowText = true
                                else
                                    TextUIFunction('open', Config.Texts[5][2])
                                    ShowText = true
                                end
                            end
                            
                            if IsControlJustReleased(0, Config.Texts[5][3]) and not InMenu and not DoesEntityExist(dutyprop) then
                                if not SpamDuty then
                                    SpamDuty = true

                                    ShowText = false

                                    local ped = GetPlayerPed(-1)
                                    local ad = "missheistdockssetup1clipboard@base"
                                    local prop_name = 'prop_notepad_01'
                                    local secondaryprop_name = 'prop_pencil_01'
                                    loadAnimDict(ad)

                                    if not InDuty then
                                        ProgressBarFunction(2500, Config.Progressbar.DutyON)
                                    else
                                        ProgressBarFunction(2500, Config.Progressbar.DutyOFF)
                                    end
                                    
                                    local x,y,z = table.unpack(playerCoords)
                                    dutyprop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                                    dutyprop2 = CreateObject(GetHashKey(secondaryprop_name), x, y, z+0.2,  true,  true, true)
                                    AttachEntityToEntity(dutyprop, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.02, 0.05, 10.0, 0.0, 0.0, true, true, false, true, 1, true)
                                    AttachEntityToEntity(dutyprop2, ped, GetPedBoneIndex(ped, 58866), 0.12, 0.0, 0.001, -150.0, 0.0, 0.0, true, true, false, true, 1, true)
                                    TaskPlayAnim(ped, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                                    FreezeEntityPosition(ped, true)

                                    Citizen.Wait(2500)
                                    FreezeEntityPosition(ped, false)
                                    ClearPedTasks(ped)
                                    DeleteEntity(dutyprop)
                                    DeleteEntity(dutyprop2)

                                    if not InDuty then
                                        InDuty = true
                                        SendNotify(3)
                                    else
                                        InDuty = false
                                        for k,v in pairs(CopsBlip) do
                                            RemoveBlip(v)
                                        end
                                        for k,v in pairs(CallBlips) do
                                            RemoveBlip(v)
                                        end
                                        
                                        SendNotify(4)
                                    end

                                    local DutyBlips = nil
                                    for k,v in pairs(Config.PoliceStations) do
                                        if v.Job == PlayerData.job.name then
                                            DutyBlips = v.DutyBlips
                                        end
                                    end

                                    if Config['Core']:upper() == 'QBCORE' then
                                        TriggerServerEvent("QBCore:ToggleDuty")
                                    end
                                    
                                    TriggerServerEvent('brutal_policejob:server:SetDutyStatus', PlayerData.job.name, InDuty, DutyBlips)

                                    Citizen.CreateThread(function()
                                        Citizen.Wait(1000*10)
                                        SpamDuty = false
                                        SpamNotify = false
                                    end)
                                else
                                   if not SpamNotify then
                                        SendNotify(16)
                                        SpamNotify = true
                                   end
                                end
                            end
                        end

                        if not InMenu and InDuty then

                            -- Cloakrooms --
                            for key,coords in pairs(v.Cloakrooms) do
                                if #(playerCoords - coords) < 1.5 then
                                    sleep = 5

                                    inMarker = true
                                    nearMarker = true
                                    if not ShowText then
                                        TextUIFunction('open', Config.Texts[1][1])
                                        ShowText = true
                                    end
                                    
                                    if IsControlJustReleased(0, Config.Texts[1][2]) then
                                        if Config['Core']:upper() == 'ESX' and not Config.CustomOutfitMenu then
                                            OpenCloakroomMenu(k)
                                        elseif Config['Core']:upper() == 'QBCORE' and not Config.CustomOutfitMenu then
                                            OpenCloakroomMenu(k)
                                        else
                                            OpenCloakroomMenuEvent(k)
                                        end
                                    end
                                end
                            end

                            -- Armorys --
                            for key,coords in pairs(v.Armorys) do
                                if #(playerCoords - coords) < 1.5 then
                                    sleep = 1
                                
                                    inMarker = true
                                    nearMarker = true
                                    if not ShowText then
                                        TextUIFunction('open', Config.Texts[2][1])
                                        ShowText = true
                                    end
                                    
                                    if IsControlJustReleased(0, Config.Texts[2][2]) then
                                        OpenArmoryMenu()
                                    end
                                end
                            end

                            -- Boss Menus --
                            for key,coords in pairs(v.BossMenu.coords) do
                                local permission = false
                                for k,v in pairs(v.BossMenu.grades) do
                                    if PlayerData.job.grade == v then
                                        permission = true
                                        break
                                    end
                                end

                                if #(playerCoords - coords) < 1.5 and permission then
                                    sleep = 1
                                
                                    inMarker = true
                                    nearMarker = true
                                    if not ShowText then
                                        TextUIFunction('open', Config.Texts[15][1])
                                        ShowText = true
                                    end
                                    
                                    if IsControlJustReleased(0, Config.Texts[15][2]) then
                                        if Config['Core']:upper() == 'ESX' then
                                            TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)
                                                menu.close()
                                    
                                                CurrentAction     = 'menu_boss_actions'
                                                CurrentActionMsg  = 'Boss Menu'
                                                CurrentActionData = {}
                                            end, { wash = false })
                                        elseif Config['Core']:upper() == 'QBCORE' then
                                            TriggerEvent('qb-bossmenu:client:OpenMenu')
                                        end
                                    end
                                end
                            end

                            -- Garages --
                            for key,table in pairs(v.Garages) do
                                local coords = table.menu
                                if #(playerCoords - coords) < 15.0 then
                                    sleep = 1
                                    DrawMarker(v.Marker.marker, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, v.Marker.rgb[1], v.Marker.rgb[2], v.Marker.rgb[3], 255, v.Marker.bobUpAndDown, true, 2, v.Marker.rotate, nil, false)

                                    if #(playerCoords - coords) < 2.0 then
                                        inMarker = true
                                        nearMarker = true
                                        if not ShowText then
                                            TextUIFunction('open', Config.Texts[3][1])
                                            ShowText = true
                                        end
                                        
                                        if IsControlJustReleased(0, Config.Texts[3][2]) then
                                            OpenGarageMenu(table)
                                        end
                                    end
                                end
                            end

                            -- Send Player To Jail --
                            if #(playerCoords - Config.Prison.SendPlayerToJail) < 1.5 then
                                sleep = 1
                                
                                inMarker = true
                                nearMarker = true
                                if not ShowText then
                                    TextUIFunction('open', Config.Texts[14][1])
                                    ShowText = true
                                end
                                
                                if IsControlJustReleased(0, Config.Texts[14][2]) then
                                    local closestPlayer, closestDistance = GetClosestPlayerFunction()

                                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                                        OpenMenuUtil()
                                        SendNUIMessage({action = "OpenSendToJailMenu", target = GetPlayerServerId(closestPlayer), menucolors = menuColors})
                                    else
                                        SendNotify(23)
                                    end
                                end
                            end

                            if not PlacingObject and RemoveObjects then
                                local trackedEntities = {
                                    `prop_roadcone02a`,
                                    `prop_barrier_work06a`,
                                    `p_ld_stinger_s`,
                                    `prop_gazebo_03`,
                                    `prop_worklight_03b`
                                }

                                for k,v in pairs(trackedEntities) do
                                    if CurrentRemoveObject == nil then
                                        local object = GetClosestObjectOfType(playerCoords, 3.0, trackedEntities[k], false, false, false)
                                        CurrentRemoveObject = object
                                    end

                                    if CurrentRemoveObject ~= nil or DoesEntityExist(object) then
                                        if #(playerCoords - GetEntityCoords(CurrentRemoveObject)) < 3.0 then
                                            sleep = 1
                                            if not ShowText then
                                                TextUIFunction('open', Config.Texts[8][1])
                                                ShowText = true
                                            end
                                            inMarker = true
                                            nearMarker = true

                                            if IsControlJustReleased(0, Config.Texts[8][2]) then
                                                NetworkRegisterEntityAsNetworked(CurrentRemoveObject)
                                                NetworkRequestControlOfEntity(CurrentRemoveObject)
                                                SetEntityAsMissionEntity(CurrentRemoveObject)
                                                DeleteEntity(CurrentRemoveObject)

                                                nearMarker = false
                                            end
                                        else
                                            CurrentRemoveObject = nil
                                        end
                                    end
                                end
                            end

                        end
                    else

                        -- Garage Deposit --
                        for key,table in pairs(v.Garages) do
                            local coords = table.deposit
                            if #(playerCoords - coords) < 3.5 and not InMenu and InDuty then
                                sleep = 1
                                
                                inMarker = true
                                nearMarker = true
                                if not ShowText then
                                    TextUIFunction('open', Config.Texts[4][1])
                                    ShowText = true
                                end
                                
                                if IsControlJustReleased(0, Config.Texts[4][2]) then
                                    DeleteVehicleFunction(table)
                                end
                            end
                        end

                    end

                    if (inMarker and not nearMarker) or (InMenu and inMarker) then
                        inMarker = false
                        ShowText = false
                        TextUIFunction('hide')
                    end


                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.RemoveObjects.Command ..'', Config.Commands.RemoveObjects.Suggestion)

RegisterCommand(Config.Commands.RemoveObjects.Command, function()
    if not InMenu and InDuty then
        if not RemoveObjects then
            RemoveObjects = true
            SendNUIMessage({action = "RemoveObjects"})
        else
            RemoveObjects = false
            SendNUIMessage({action = "HideRemoveObjects"})
        end 
    end
end)

-----------------------------------------------------------
-----------------------| functions |-----------------------
-----------------------------------------------------------

Citizen.CreateThread(function()
    for k,v in pairs(Config.PoliceStations) do
        local blip = AddBlipForCoord(v.Duty)
        SetBlipSprite(blip, v.Blip.sprite)
        SetBlipColour(blip,v.Blip.color)
        SetBlipScale(blip, v.Blip.size)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(k)
        EndTextCommandSetBlipName(blip)
        SetBlipAsShortRange(blip, true)
    end
end)

RegisterNetEvent('brutal_policejob:client:updateBlip')
AddEventHandler('brutal_policejob:client:updateBlip', function(OneSync, InDutyList)

    for k, v in pairs(CopsBlip) do
        RemoveBlip(v)
    end

    for k,v in pairs(InDutyList) do
        if OneSync == 'infinite' then
            blip = AddBlipForCoord(v.location.x, v.location.y, v.location.z)
            SetBlipSprite(blip, 1)
            ShowHeadingIndicatorOnBlip(blip, true)
            SetBlipRotation(blip, math.ceil(v.location.h))
            SetBlipScale(blip, 0.65)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.label)
            EndTextCommandSetBlipName(blip)

            table.insert(CopsBlip, blip)
        else
            if v == true then
                local id = GetPlayerFromServerId(k)
                if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() and GetPlayerServerId(PlayerId()) ~= id then
                    local ped = GetPlayerPed(id)
                    local blip = GetBlipFromEntity(ped)

                    if not DoesBlipExist(blip) then
                        blip = AddBlipForEntity(ped)
                        SetBlipSprite(blip, 1)
                        ShowHeadingIndicatorOnBlip(blip, true)
                        SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
                        SetBlipNameToPlayerName(blip, id)
                        SetBlipScale(blip, 0.65)
                        SetBlipAsShortRange(blip, true)
                        SetBlipShowCone(blip, true)

                        table.insert(CopsBlip, blip)
                    end
                end
            end
        end
    end
end)

-----------------------------------------------------------
---------------------| police menus |----------------------
-----------------------------------------------------------

function OpenCloakroomMenu(PoliceDepartment)
    local outfits = {}

    table.insert(outfits, {id = 'citizen_wear', label = Config.CitizenWear.label})

    for k,v in pairs(Config.Uniforms) do
        for i = 1, #v.jobs do
            if PlayerData.job.name == Config.Uniforms[k].jobs[i].job then
                for _k,_v in pairs(Config.Uniforms[k].jobs[i].grades) do
                    if PlayerData.job.grade == _v then
                        table.insert(outfits, {id = k, label = v.label})
                    end
                end
            end
        end
    end

    OpenMenuUtil()
    SendNUIMessage({ 
        action = "OpenCloakRoom",
        outfits = outfits,
        menucolors = menuColors
    })
end

function OpenArmoryMenu()
    OpenMenuUtil()
    SendNUIMessage({
        action = "OpenArmory",
        menucolors = menuColors
    })
end

function OpenGarageMenu(data)
    SpawnCoords = data.spawn

    local VehicleTable = {}
    for k,v in pairs(data.vehicles) do
        if PlayerData.job.grade >= v.minRank then
            table.insert(VehicleTable, {model = k, label = v.Label, livery = v.livery})
        end
    end

    if #VehicleTable > 0 then
        OpenMenuUtil()
        SendNUIMessage({ 
            action = "OpenGarage",
            vehicles = VehicleTable,
            menucolors = menuColors
        })
    else
        SendNotify(1)
    end
end

function DeleteVehicleFunction(data)
    DoScreenFadeOut(400)
    Citizen.Wait(400)

    local policeVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    DeleteEntity(policeVehicle)
    Citizen.Wait(300)
    DoScreenFadeIn(600)
end

-----------------------------------------------------------
-------------------| main police menu |--------------------
-----------------------------------------------------------

InteractionsTable = {
    {
        label = Config.Locales.CitizenInteractions,
        icon = '<i class="fa-solid fa-user"></i>',
        table = {
            {label = Config.Locales.Search, icon = '<i class="fa-solid fa-magnifying-glass"></i>', id = 'search'},
            {label = Config.Locales.Cuff, icon = '<i class="fa-solid fa-handcuffs"></i>', id = 'cuff'},
            {label = Config.Locales.Uncuff, icon = '<i class="fa-solid fa-xmark fa-xl"></i>', id = 'uncuff'},
            {label = Config.Locales.Drag, icon = '<i class="fa-solid fa-user"></i>', id = 'drag'},
            {label = Config.Locales.InOutOfVehicle, icon = '<i class="fa-solid fa-car"></i>', id = 'inoutvehicle'},
        }
    },
    {
        label = Config.Locales.VehicleInteractions,
        icon = '<i class="fa-solid fa-car"></i>',
        table = {
            {label = Config.Locales.Lockpick, icon = '<i class="fa-solid fa-lock-open"></i>', id = 'lockpick'},
            {label = Config.Locales.WheelClamp, icon = '<i class="fa-solid fa-circle-radiation fa-lg"></i>', id = 'wheel_clamp'},
            {label = Config.Locales.Impound, icon = '<i class="fa-solid fa-truck-pickup"></i>', id = 'impound'},
            {label = Config.Locales.VehicleSearch, icon = '<i class="fa-solid fa-magnifying-glass"></i>', id = 'vehicle_search'},
        }
    },
    {
        label = Config.Locales.Objects,
        icon = '<i class="fa-solid fa-road-barrier"></i>',
        table = {
            {label = Config.Locales.Cone, icon = '<i class="fa-solid fa-play fa-rotate-270"></i>', id = 'cone'},
            {label = Config.Locales.Barrier, icon = '<i class="fa-solid fa-road-barrier"></i>', id = 'barrier'},
            {label = Config.Locales.Spikestrips, icon = '<i class="fa-solid fa-road-spikes"></i>', id = 'spikestrips'},
            {label = Config.Locales.Tent, icon = '<i class="fa-solid fa-tent"></i>', id = 'tent'},
            {label = Config.Locales.Light, icon = '<i class="fa-solid fa-lightbulb"></i>', id = 'light'},
        }
    },
    {
        label = Config.Locales.MDT, icon = '<i class="fa-solid fa-tablet-screen-button"></i>', id = 'mdt'
    },
}

RegisterKeyMapping(Config.Commands.JobMenu.Command, Config.Commands.JobMenu.Suggestion, "keyboard", Config.Commands.JobMenu.Control)
TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.JobMenu.Command ..'', Config.Commands.JobMenu.Suggestion)

RegisterCommand(Config.Commands.JobMenu.Command, function()
    if not InMenu and InDuty and not IsPedInAnyVehicle(PlayerPedId(), false) then
        InMenu = true
        SendNUIMessage({
            action = "OpenPoliceMenu",
            interactionstable = InteractionsTable,
            menucolors = menuColors
        })

        Citizen.CreateThread(function()
            while InMenu do
                if IsControlJustReleased(0, 188) then
                    SendNUIMessage({
                        action = "ControlReleased",
                        control = 'down'
                    })
                elseif IsControlJustReleased(0, 187) then
                    SendNUIMessage({
                        action = "ControlReleased",
                        control = 'up'
                    })
                elseif IsControlJustReleased(0, 191) then
                    SendNUIMessage({
                        action = "ControlReleased",
                        control = 'enter'
                    })
                elseif IsControlJustReleased(0, 194) then
                    SendNUIMessage({
                        action = "ControlReleased",
                        control = 'backspace'
                    })

                    if PlacingObject then
                        PlacingObject = false
                        DeleteEntity(DemoObject)
                    end

                end
                Citizen.Wait(1)
            end
        end)
    end
end)

function PoliceMenuInteractions(action, type)
    local ped = GetPlayerPed(-1)
    local playerPed = PlayerPedId()

    if action == 1 then
        local closestPlayer, closestDistance = GetClosestPlayerFunction()

        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            if type == 'search' then
                InventoryOpenFunction('search_player', GetPlayerServerId(closestPlayer))
            elseif type == 'cuff' then
                TriggerServerEvent('brutal_policejob:server:policeMenuEvent', GetPlayerServerId(closestPlayer), type, GetPlayerServerId(PlayerId()))
            elseif type == 'uncuff' then
                TriggerServerEvent('brutal_policejob:server:policeMenuEvent', GetPlayerServerId(closestPlayer), type, GetPlayerServerId(PlayerId()))
            elseif type == 'drag' then
                TriggerServerEvent('brutal_policejob:server:policeMenuEvent', GetPlayerServerId(closestPlayer), type, GetPlayerServerId(PlayerId()))
            elseif type == 'inoutvehicle' then
                TriggerServerEvent('brutal_policejob:server:policeMenuEvent', GetPlayerServerId(closestPlayer), type)
            end
        end
    elseif action == 2 then
        local closestVehicle, closestVehicleDistance = GetClosestVehicleFunction()
        local playerInVehicle = IsPedInAnyVehicle(playerPed, false)

        if type == 'lockpick' then
            if closestVehicle ~= -1 and closestVehicleDistance <= 2.0 and not playerInVehicle then
                local coords  = GetEntityCoords(playerPed)
                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
                    LockPick(closestVehicle)
                end
            end
        elseif type == 'wheel_clamp' and not playerInVehicle then
            if closestVehicle ~= -1 and closestVehicleDistance <= 6.0 then
                local closestClamp = GetClosestObjectOfType(GetEntityCoords(playerPed), 5.0, GetHashKey('prop_clamp'), false, false, false)

                
                if not DoesEntityExist(closestClamp) then
                    if IsVehicleSeatFree(closestVehicle, -1) then

                        NetworkRegisterEntityAsNetworked(closestVehicle)
                        NetworkRequestControlOfEntity(closestVehicle)
                        SetEntityAsMissionEntity(closestVehicle)


                        local bonePos = GetWorldPositionOfEntityBone(closestVehicle, GetEntityBoneIndexByName(closestVehicle, "wheel_lf"))

                        TaskGoStraightToCoord(ped, bonePos.x-0.2, bonePos.y-0.2, bonePos.z, 0.2, 4000, GetEntityHeading(closestVehicle)-90, 0.5)
                        Citizen.Wait(3000)
                        ProgressBarFunction(3000, Config.Progressbar.WheelClampPlacing)
                        SetEntityHeading(ped, GetEntityHeading(closestVehicle)-90)
                        TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                        Citizen.Wait(3000)
                        ClearPedTasks(ped)

                        NetworkRegisterEntityAsNetworked(closestVehicle)
                        NetworkRequestControlOfEntity(closestVehicle)
                        SetEntityAsMissionEntity(closestVehicle)


                        RequestSpawnObject('prop_clamp')
                        clampProp = CreateObject(GetHashKey('prop_clamp'), 0.0, 0.0, 0.0, true, true, true)
                        table.insert(SpawnedObjects, clampProp)
                        local boneIndex = GetEntityBoneIndexByName(closestVehicle, "wheel_lf")
                        AttachEntityToEntity(clampProp, closestVehicle, boneIndex, -0.1, 0.028, -0.25, newX, 0.0, 270.0, true, true, false, true, 1, true)

                        FreezeEntityPosition(closestVehicle, true)
                    else
                        SendNotify(29)
                    end
                else

                    local bonePos = GetWorldPositionOfEntityBone(closestVehicle, GetEntityBoneIndexByName(closestVehicle, "wheel_lf"))
                    TaskGoStraightToCoord(ped, bonePos.x-0.2, bonePos.y-0.2, bonePos.z, 0.2, 4000, GetEntityHeading(closestVehicle)-90, 0.5)
                    Citizen.Wait(3000)
                    SetEntityHeading(ped, GetEntityHeading(closestVehicle)-90)
                    TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                    Citizen.Wait(3000)
                    ClearPedTasks(ped)

                    NetworkRegisterEntityAsNetworked(closestClamp)
                    NetworkRequestControlOfEntity(closestClamp)
                    SetEntityAsMissionEntity(closestClamp)
                    Citizen.Wait(1000)
                    DeleteEntity(closestClamp)

                    NetworkRegisterEntityAsNetworked(closestVehicle)
                    NetworkRequestControlOfEntity(closestVehicle)
                    SetEntityAsMissionEntity(closestVehicle)
                    FreezeEntityPosition(closestVehicle, false)
                end
            end
        elseif type == 'impound' and not playerInVehicle then
            local closestClamp = GetClosestObjectOfType(GetEntityCoords(playerPed), 5.0, GetHashKey('prop_clamp'), false, false, false)
                
                if DoesEntityExist(closestClamp) then
                    local ad = "missheistdockssetup1clipboard@base"
                    local prop_name = 'prop_notepad_01'
                    local secondaryprop_name = 'prop_pencil_01'
                    loadAnimDict(ad)
                    
                    local x,y,z = table.unpack(GetEntityCoords(ped))
                    prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                    secondaryprop = CreateObject(GetHashKey(secondaryprop_name), x, y, z+0.2,  true,  true, true)
                    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.02, 0.05, 10.0, 0.0, 0.0, true, true, false, true, 1, true)
                    AttachEntityToEntity(secondaryprop, ped, GetPedBoneIndex(ped, 58866), 0.12, 0.0, 0.001, -150.0, 0.0, 0.0, true, true, false, true, 1, true)
                    TaskPlayAnim(ped, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0)

                    ProgressBarFunction(7000, Config.Progressbar.Impound)

                    Citizen.Wait(7000)
                    ClearPedTasks(ped)
                    DeleteEntity(prop)
                    DeleteEntity(secondaryprop)

                    Citizen.Wait(2000)
                    DeleteEntity(closestClamp)
                    ImpoundDeleteVehicle(closestVehicle)
                else
                    SendNotify(30)
                end
        elseif type == 'vehicle_search' then
            local playerInVehicle = IsPedInAnyVehicle(playerPed, false)
    
            if playerInVehicle then
                InventoryOpenFunction('search_vehicle_glovebox', closestVehicle)
            else
                local trunkDistance = #(GetEntityCoords(playerPed) - GetEntityCoords(closestVehicle))
                if trunkDistance <= 5.0 then
                    InventoryOpenFunction('search_vehicle_trunk', closestVehicle)
                end
            end
        end
    elseif action == 3 then
        PlacingObject = true
        CurrentCoords = nil
        ObjectType = 'cone'
        CreateDemoObject()
        
        Citizen.CreateThread(function()
            while PlacingObject do
                if ObjectType ~= nil then
                    local hit, coords, entity = RayCastGamePlayCamera(20.0)
                    CurrentCoords = coords
        
                    HelpText(Config.Locales.ObjectLabel)
        
                    if hit == 1 then
                        SetEntityCoords(DemoObject, coords.x, coords.y, coords.z)
                    end
                    
                    if IsControlPressed(0, 174) then
                        ObjectHeading = ObjectHeading + 1
                        if ObjectHeading > 360 then ObjectHeading = 0.0 end
                    end
            
                    if IsControlPressed(0, 175) then
                        ObjectHeading = ObjectHeading - 1
                        if ObjectHeading < 0 then ObjectHeading = 360.0 end
                    end
        
                    SetEntityHeading(DemoObject, ObjectHeading)

                    if IsControlJustPressed(0, 191) then
                        PlacingObject = false

                        DeleteEntity(DemoObject)
                        
                        Citizen.Wait(3)
                        RequestSpawnObject(model)
                        Object = CreateObject(model, CurrentCoords.x, CurrentCoords.y, CurrentCoords.z, true, true, false)
                        SetEntityHeading(Object, ObjectHeading)
                        NetworkRegisterEntityAsNetworked(Object)
                        NetworkRequestControlOfEntity(Object)
                        SetEntityAsMissionEntity(Object)
                        table.insert(SpawnedObjects, Object)

                        if ObjectFreeze then
                            SetEntityInvincible(Object, true)
                            FreezeEntityPosition(Object, true)
                        end
                    end
                end

                Citizen.Wait(1)
            end
        end)

    elseif type == 'mdt' then
        InMenu = false
        TriggerEvent('brutal_policejob:client:MDTCommand')
    end
end

RegisterNetEvent('brutal_policejob:client:policeMenuEvent')
AddEventHandler('brutal_policejob:client:policeMenuEvent', function(event, extraData)
    if event == 'jail' then
        if not inPrison then
            inPrison = true
            jailMinute = extraData
            sendtoJail()
        else
            jailMinute += extraData
        end
    elseif event == 'unjail' then
        if inPrison then
            TriggerEvent('brutal_policejob:client:finishJail', 'general')
        end
    elseif event == 'cuff' then
        local ped = GetPlayerPed(-1)
        local playerPed = PlayerPedId()

        if isCuffed == false then
            isCuffed = true
            HandCuffedEvent(isCuffed)
            TriggerServerEvent('brutal_policejob:server:policeMenuEvent', extraData, 'cuffCop')
            
            loadAnimDict('mp_arrest_paired')
            AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(extraData)), 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
            TaskPlayAnim(ped, 'mp_arrest_paired', 'crook_p2_back_left', 8.0, -8.0, 5500, 33, 0, false, false, false)

            Citizen.Wait(3700)
            DetachEntity(ped, true, false)

            loadAnimDict('mp_arresting')

            Citizen.CreateThread(function()
                while isCuffed do
                    if not IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) then
                        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
                        SetEnableHandcuffs(playerPed, true)
                        DisablePlayerFiring(playerPed, true)
                        SetPedCanPlayGestureAnims(playerPed, false)
                        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
                        DisableMinimap() -- cl_utils function

                        if Config.HandCuff.CuffObject then
                            RequestSpawnObject('p_cs_cuffs_02_s')
                            cuffObject = CreateObject(GetHashKey('p_cs_cuffs_02_s'), 0.0, true, true, true)
                            AttachEntityToEntity(cuffObject, ped, GetPedBoneIndex(ped, 57005), 0.04, 0.065, 0.0, 110.0, 180.0, 80.0, true, true, false, false, false, true)
                        end

                        if Config.HandCuff.Freeze then
                            FreezeEntityPosition(playerPed, true)
                        end
                    end
                    Citizen.Wait(1000*5)
                end
            end)

            Citizen.CreateThread(function()
                while isCuffed do
                    for k,v in pairs(Config.HandCuff.DisableControls) do
                        DisableControlAction(0,v,true)
                        DisableControlAction(1,v,true)
                        DisableControlAction(2,v,true)
                    end
                    Citizen.Wait(1)
                end
            end)
        end
    elseif event == 'cuffCop' then
        local playerPed = PlayerPedId()
        loadAnimDict('mp_arrest_paired')
        TaskPlayAnim(playerPed, 'mp_arrest_paired', 'cop_p2_back_left', 8.0, -8.0, 5500, 33, 0, false, false, false)
        Citizen.Wait(3700)
        ClearPedTasks(playerPed)
    elseif event == 'uncuff' then
        local ped = GetPlayerPed(-1)
        local playerPed = PlayerPedId()

        if isCuffed and not inDrag then
            AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(extraData)), 11816, -0.1, 0.65, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
            TriggerServerEvent('brutal_policejob:server:policeMenuEvent', extraData, 'uncuffCop')

            Citizen.Wait(3000)
            DetachEntity(ped, true, false)
            ClearPedTasks(playerPed)
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            DisablePlayerFiring(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
            FreezeEntityPosition(playerPed, false)
            EnableMinimap() -- cl_utils function

            NetworkRegisterEntityAsNetworked(cuffObject)
            NetworkRequestControlOfEntity(cuffObject)
            SetEntityAsMissionEntity(cuffObject)

            if DoesEntityExist(cuffObject) then
                DetachEntity(cuffObject, true, false)
                DeleteEntity(cuffObject)
            end
            isCuffed = false
            HandCuffedEvent(isCuffed)
        end
    elseif event == 'uncuffCop' then
        local playerPed = PlayerPedId()
        loadAnimDict('mp_arresting')
        TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
        Citizen.Wait(3000)
        ClearPedTasks(playerPed)
    elseif event == 'drag' then
        if isCuffed then
            local ped = GetPlayerPed(-1)
            if not inDrag then
                AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(extraData)), 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                inDrag = true
            else
                DetachEntity(ped, true, false)
                inDrag = false
            end
        end
    elseif event == 'inoutvehicle' then
        if isCuffed then
            local playerPed = PlayerPedId()

            if not inVehicle then
                local vehicle, distance = GetClosestVehicleFunction()
                NetworkRegisterEntityAsNetworked(vehicle)
                NetworkRequestControlOfEntity(vehicle)
                SetEntityAsMissionEntity(vehicle)

                local blacklisted = false
                for k,v in pairs(Config.HandCuff.DragBlacklistedVehicles) do
                    if GetHashKey(v:lower()) == GetEntityModel(vehicle) then
                        blacklisted = true
                    end
                end

                if vehicle and distance < 5 and not blacklisted then
                    if inDrag then
                        DetachEntity(ped, true, false)
                        inDrag = false
                    end
                    Citizen.Wait(10)

                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                    for i=maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(vehicle, i) then
                            freeSeat = i
                            break
                        end
                    end

                    if freeSeat then
                        TaskEnterVehicle(playerPed, vehicle, -1, freeSeat, 1.0, 1, 0)
                        inVehicle = true
                    else
                        SendNotify(6)
                    end
                end
            else
                local vehicle = GetVehiclePedIsIn(playerPed, false)
		        TaskLeaveVehicle(playerPed, vehicle, 64)
                inVehicle = false
            end
        end
    end
end)

RegisterNetEvent('brutal_policejob:client:updateAvailabeCops')
AddEventHandler('brutal_policejob:client:updateAvailabeCops', function(DutyTable)
    InDutyTable = DutyTable
end)

RegisterNetEvent('brutal_policejob:client:UseHandCuffKeyItem')
AddEventHandler('brutal_policejob:client:UseHandCuffKeyItem', function()
    local closestPlayer, closestDistance = GetClosestPlayerFunction()

    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('brutal_policejob:server:policeMenuEvent', GetPlayerServerId(closestPlayer), 'uncuff', GetPlayerServerId(PlayerId()))
        TriggerServerEvent('brutal_policejob:server:Removetem', Config.HandCuff.HandcuffKeyItem)
    else
        SendNotify(23)
    end
end)

function getAvailableCopsCount()
    local cops = 0
    for k,v in pairs(InDutyTable) do
        for _k,_v in pairs(v) do
            if _v then
                cops += 1
            end
        end
    end

    return cops
end

function IsHandcuffed()
    return isCuffed
end

function CreateDemoObject()
    if DoesEntityExist(DemoObject) then
        DeleteEntity(DemoObject)
    end

    ObjectFreeze = false

    if ObjectType == 'cone' then
        model = 'prop_roadcone02a'
    elseif ObjectType == 'barrier' then
        model = 'prop_barrier_work06a'
    elseif ObjectType == 'spikestrips' then
        model = 'p_ld_stinger_s'
    elseif ObjectType == 'tent' then
        model = 'prop_gazebo_03'
        ObjectFreeze = true
    elseif ObjectType == 'light' then
        model = 'prop_worklight_03b'
        ObjectFreeze = true
    end

    RequestSpawnObject(model)
    local SpawnCoords = GetEntityCoords(PlayerPedId())
    DemoObject = CreateObject(model, SpawnCoords.x+1.0, SpawnCoords.y, SpawnCoords.z, false, false, false)
    table.insert(SpawnedObjects, DemoObject)

    SetEntityHeading(DemoObject, 0)

    SetEntityAlpha(DemoObject, 150)
    SetEntityCollision(DemoObject, false, false)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        local playerPed = PlayerPedId()
        local ped = GetPlayerPed(-1)

		if isCuffed then
            ClearPedTasks(playerPed)
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            DisablePlayerFiring(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
            FreezeEntityPosition(playerPed, false)
            EnableMinimap() -- cl_utils function

            if DoesEntityExist(cuffObject) then
                DetachEntity(cuffObject, true, false)
                DeleteEntity(cuffObject)
            end
        end

        if inDrag then
            DetachEntity(ped, true, false)
        end

        if inVehicle then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            TaskLeaveVehicle(ped, vehicle, 64)
        end

        if DoesEntityExist(dutyprop) then
            DeleteEntity(dutyprop)
            DeleteEntity(dutyprop2)
        end

        if DoesEntityExist(TunnelNPC) then
            DeleteEntity(TunnelNPC)
        end

        for k,v in pairs(PrisonGuards) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end

        for k,v in pairs(SpawnedObjects) do
            DetachEntity(SpawnedObjects, true, false)
            DeleteObject(v)
        end

        ShowText = false
        TextUIFunction('hide')
        
	end
end)

-----------------------------------------------------------
------------------------| prison |-------------------------
-----------------------------------------------------------

Citizen.CreateThread(function()
    local prisonBlip = AddBlipForCoord(Config.Prison.Coords)
    SetBlipSprite(prisonBlip, Config.Prison.Blip.sprite)
    SetBlipColour(prisonBlip, Config.Prison.Blip.color)
    SetBlipScale(prisonBlip, Config.Prison.Blip.size)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Prison.Blip.label)
    EndTextCommandSetBlipName(prisonBlip)
    SetBlipAsShortRange(prisonBlip, true)
end)

function sendtoJail()
    if inPrison then
        local playerPed = PlayerPedId()
        SetEntityCoords(playerPed, Config.Prison.Coords, true, true, true, false)
        setUniform(Config.PrisonUniform)

        SendNUIMessage({action = "JailHud", jailminute = jailMinute })

        for k,v in pairs(Config.Prison.PrisonGuards) do
            RequestSpawnObject(v.Model)
			local PrisonGuard = CreatePed(4, v.Model, v.Coords[1], v.Coords[2], v.Coords[3]-1, v.Coords[4], false, true)
			FreezeEntityPosition(PrisonGuard, true)
			SetEntityInvincible(PrisonGuard, true)
			SetBlockingOfNonTemporaryEvents(PrisonGuard, true)
            table.insert(PrisonGuards, PrisonGuard)
        end

        prisonHospitalBlip = AddBlipForCoord(Config.Prison.Hospital.Blip.coords)
        SetBlipSprite(prisonHospitalBlip, Config.Prison.Hospital.Blip.sprite)
        SetBlipColour(prisonHospitalBlip, Config.Prison.Hospital.Blip.color)
        SetBlipScale(prisonHospitalBlip, Config.Prison.Hospital.Blip.size)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Prison.Hospital.Blip.label)
        EndTextCommandSetBlipName(prisonHospitalBlip)
        SetBlipAsShortRange(prisonHospitalBlip, true)

        JobBlip = AddBlipForCoord(Config.Prison.Jobs.StartJob)
        SetBlipSprite(JobBlip, Config.Prison.Jobs.Blip.sprite)
        SetBlipColour(JobBlip, Config.Prison.Jobs.Blip.color)
        SetBlipScale(JobBlip, Config.Prison.Jobs.Blip.size)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Prison.Jobs.Blip.label)
        EndTextCommandSetBlipName(JobBlip)
        SetBlipAsShortRange(JobBlip, true)

        PrisonShopBlip = AddBlipForCoord(Config.Prison.Shop.Coords)
        SetBlipSprite(PrisonShopBlip, Config.Prison.Shop.Blip.sprite)
        SetBlipColour(PrisonShopBlip, Config.Prison.Shop.Blip.color)
        SetBlipScale(PrisonShopBlip, Config.Prison.Shop.Blip.size)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Prison.Shop.Blip.label)
        EndTextCommandSetBlipName(PrisonShopBlip)
        SetBlipAsShortRange(PrisonShopBlip, true)

        local NoSaved = 0
        Citizen.CreateThread(function()
            while inPrison do
                jailMinute -= 1
                SendNUIMessage({action = "JailHud", jailminute = jailMinute })

                if jailMinute <= 0 then
                    TriggerServerEvent('brutal_policejob:server:finishJail', GetPlayerServerId(PlayerId()), 'general')
                elseif NoSaved >= Config.Prison.SaveFrequency then
                    NoSaved = 0
                    TriggerServerEvent('brutal_policejob:server:refreshJailTime', GetPlayerServerId(PlayerId()), jailMinute)
                else
                    NoSaved += 1
                end

                Citizen.Wait(1000*60)
            end
        end)

        CurrentJobValue1 = nil
        CurrentJobValue2 = nil
        CurrentJobBlip = nil
        MoneyForJob = 0
        inPrisonJob = false

        inTunnelDistance = false
        Escaping = false
        Escaped = false

        Citizen.CreateThread(function()
            while inPrison do
                local sleep = 750
                local nearMarker = false
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)

                -- Escape from the Prison
                local distance = #(playerCoords - vec3(Config.Prison.Coords[1], Config.Prison.Coords[2], Config.Prison.Coords[3]))

                if distance > Config.Prison.Escape.EscapeDistance then
                    if Config.Prison.Escape.CanEscape or (Escaping or Escaped) then
                        TriggerServerEvent('brutal_policejob:server:finishJail', GetPlayerServerId(PlayerId(), 'escape'))
                    else
                        SetEntityCoords(playerPed, Config.Prison.Coords, true, true, true, false)
                        SendNotify(26)
                    end
                end

                -- Escape by tunnel
                if Config.Prison.Escape.EscapeByTunnel.Use then
                    if not Escaping then
                        local distance = #(playerCoords - vector3(Config.Prison.Escape.EscapeByTunnel.Coords[1], Config.Prison.Escape.EscapeByTunnel.Coords[2], Config.Prison.Escape.EscapeByTunnel.Coords[3]))
                        if distance <= 2.0 then
                            sleep = 1
                            inMarker = true
                            nearMarker = true
                            if not ShowText then
                                TextUIFunction('open', Config.Texts[12][1])
                                ShowText = true
                            end

                            if IsControlJustReleased(0, Config.Texts[12][2]) then
                                TSCB('brutal_policejob:server:GetPlayerMoney', function(wallet)
                                    if wallet.money >= Config.Prison.Escape.EscapeByTunnel.Price then
                                        TriggerServerEvent('brutal_policejob:server:RemoveMoney', 'money', Config.Prison.Escape.EscapeByTunnel.Price)
                                        Escaping = true
                                        SendNotify(15)

                                        loadAnimDict("mp_common") 
                                        TaskPlayAnim(GetPlayerPed(-1), "mp_common", "givetake1_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
                                        TaskPlayAnim(TunnelNPC, "mp_common", "givetake1_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
                                        Citizen.Wait(2000)
                                        ClearPedTasks(GetPlayerPed(-1))
                                        ClearPedTasks(TunnelNPC)
                                        Citizen.Wait(200)

                                        FreezeEntityPosition(TunnelNPC, false)
                                        TaskGoStraightToCoord(TunnelNPC, Config.Prison.Escape.EscapeByTunnel.WalkCoords[1], Config.Prison.Escape.EscapeByTunnel.WalkCoords[2], Config.Prison.Escape.EscapeByTunnel.WalkCoords[3], 0.2, 2500, Config.Prison.Escape.EscapeByTunnel.WalkCoords[4], 0.5)
                                        Citizen.Wait(2500)
                                        FreezeEntityPosition(TunnelNPC, true)

                                        FreezeEntityPosition(TunnelDoor, false)

                                        Citizen.Wait(Config.Prison.Escape.EscapeByTunnel.TimeToEscape)
                                        DeleteEntity(TunnelNPC)
                                        Escaping = false
                                        inTunnelDistance = false

                                        Escaped = true
                                    else
                                        notification(Config.Notify[14][1], Config.Notify[14][2]..' '..Config.Prison.Escape.EscapeByTunnel.Price..' '..Config.MoneyForm, Config.Notify[14][3], Config.Notify[14][4])
                                    end
                                end)
                            end
                        elseif distance > 2.0 and distance < 50.0 then
                            if inTunnelDistance == false then
                                RequestSpawnObject(Config.Prison.Escape.EscapeByTunnel.Model)
                                TunnelNPC = CreatePed(4, Config.Prison.Escape.EscapeByTunnel.Model, Config.Prison.Escape.EscapeByTunnel.Coords, false, true)
                                FreezeEntityPosition(TunnelNPC, true)
                                SetEntityInvincible(TunnelNPC, true)
                                SetBlockingOfNonTemporaryEvents(TunnelNPC, true)
                            end

                            inTunnelDistance = true

                            TunnelDoor = GetClosestObjectOfType(vector3(Config.Prison.Escape.EscapeByTunnel.Coords[1], Config.Prison.Escape.EscapeByTunnel.Coords[2], Config.Prison.Escape.EscapeByTunnel.Coords[3]), 5.0, Config.Prison.Escape.EscapeByTunnel.DoorObject, false, false, false)
                            SetEntityCoords(TunnelDoor, Config.Prison.Escape.EscapeByTunnel.DoorCoords[1], Config.Prison.Escape.EscapeByTunnel.DoorCoords[2], Config.Prison.Escape.EscapeByTunnel.DoorCoords[3], false, false, false, false)
                            SetEntityHeading(TunnelDoor, Config.Prison.Escape.EscapeByTunnel.DoorCoords[4]+180) 
                            FreezeEntityPosition(TunnelDoor, true)
                        else
                            inTunnelDistance = false
                            DeleteEntity(TunnelNPC)
                        end
                    end
                end

                -- Prison Guards
                for k,v in pairs(Config.Prison.PrisonGuards) do
                    if #(playerCoords - vector3(v.Coords[1], v.Coords[2], v.Coords[3])) < v.Distance then
                        DoScreenFadeOut(1500)
                        Citizen.Wait(1500)
                        SetEntityCoords(playerPed, Config.Prison.Coords, true, true, true, false)
                        DoScreenFadeIn(1500)
                        Citizen.Wait(1000)
                        SendNotify(13)
                    end
                end

                -- Prison Shop
                if #(playerCoords - Config.Prison.Shop.Coords) < 1.5 and not InMenu then
                    sleep = 1
                    inMarker = true
                    nearMarker = true
                    if not ShowText then
                        TextUIFunction('open', Config.Texts[13][1])
                        ShowText = true
                    end

                    if IsControlJustReleased(0, Config.Texts[13][2]) then
                        nearMarker = false
                        OpenMenuUtil()
				        SendNUIMessage({action = "OpenShopMenu", items = Config.Prison.Shop.Items, moneyform = Config.MoneyForm, card = false, menucolors = menuColors})
                    end
                end

                -- Prison Job
                if Config.Prison.Jobs.Use then
                    if #(playerCoords - Config.Prison.Jobs.StartJob) < 1.5 then
                        sleep = 1
                        inMarker = true
                        nearMarker = true
                        if not ShowText then
                            if not inPrisonJob then
                                TextUIFunction('open', Config.Texts[9][1])
                                ShowText = true
                            else
                                TextUIFunction('open', Config.Texts[10][1])
                                ShowText = true
                            end
                        end
                            
                        if IsControlJustReleased(0, Config.Texts[9][2]) then
                            if not inPrisonJob then
                                inPrisonJob = true
                                SendNotify(11)
                                CurrentJobValue1 = math.random(1, #Config.Prison.Jobs.Works)
                                CurrentJobValue2 = math.random(1, #Config.Prison.Jobs.Works[CurrentJobValue1].Positions)
                                SetNewJobBlip()
                            else
                                inPrisonJob = false
                                RemoveBlip(CurrentJobBlip)

                                if MoneyForJob > 0 then
                                    notification(Config.Notify[7][1], Config.Notify[7][2]..' '..MoneyForJob..' '..Config.MoneyForm, Config.Notify[7][3], Config.Notify[7][4])
                                    TriggerServerEvent('brutal_policejob:server:prisonJobPay', {amount = MoneyForJob, account = 'money'})
                                end
                            end
                        end
                    end

                    if inPrisonJob then
                        local Current = Config.Prison.Jobs.Works[CurrentJobValue1]
                        if #(playerCoords - Current.Positions[CurrentJobValue2].Coords) < 1.5 then
                            sleep = 1
                            inMarker = true
                            nearMarker = true
                            if not ShowText then
                                TextUIFunction('open', Config.Texts[11][1])
                                ShowText = true
                            end
                                
                            if IsControlJustReleased(0, Config.Texts[11][2]) then
                                nearMarker = false
                                SetEntityHeading(playerPed, Current.Positions[CurrentJobValue2].Heading)
                                TaskStartScenarioInPlace(playerPed, Current.Animation, 0, false)
                                ProgressBarFunction(1000*Current.Time, Config.Progressbar.Working)
                                Wait(1000*Current.Time)

                                ClearPedTasksImmediately(playerPed)

                                MoneyForJob += math.random(Config.Prison.Jobs.Works[CurrentJobValue1].Money.min, Config.Prison.Jobs.Works[CurrentJobValue1].Money.max)

                                if Current.RemoveProp ~= nil then
                                    local animObject = GetClosestObjectOfType(playerCoords, 10.0, GetHashKey(Current.RemoveProp), false, false, false)
                                    NetworkRegisterEntityAsNetworked(animObject)
                                    NetworkRequestControlOfEntity(animObject)
                                    SetEntityAsMissionEntity(animObject)
                                    DeleteEntity(animObject)
                                end

                                while true and inPrison do
                                    newCurrentJobValue1 = math.random(1, #Config.Prison.Jobs.Works)
                                    newCurrentJobValue2 = math.random(1, #Config.Prison.Jobs.Works[newCurrentJobValue1].Positions)

                                    if newCurrentJobValue1 ~= CurrentJobValue1 and newCurrentJobValue2 ~= CurrentJobValue2 then
                                        CurrentJobValue1 = newCurrentJobValue1
                                        CurrentJobValue2 = newCurrentJobValue2
                                        SendNotify(12)
                                        SetNewJobBlip()
                                        break
                                    end
                                    Citizen.Wait(1)
                                end
                            end
                        end
                    end
                end

                if (inMarker and not nearMarker) or (InMenu and inMarker) then
                    inMarker = false
                    ShowText = false
                    TextUIFunction('hide')
                end

                Citizen.Wait(sleep)
            end
        end)
    end
end

function SetNewJobBlip()
    if CurrentJobBlip ~= nil then
        RemoveBlip(CurrentJobBlip)
    end

    CurrentJobBlip = AddBlipForCoord(Config.Prison.Jobs.Works[CurrentJobValue1].Positions[CurrentJobValue2].Coords)
    SetBlipSprite(CurrentJobBlip, Config.Prison.Jobs.Works[CurrentJobValue1].Blip.sprite)
    SetBlipColour(CurrentJobBlip, Config.Prison.Jobs.Works[CurrentJobValue1].Blip.color)
    SetBlipScale(CurrentJobBlip, Config.Prison.Jobs.Works[CurrentJobValue1].Blip.size)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Prison.Jobs.Works[CurrentJobValue1].Blip.label)
    EndTextCommandSetBlipName(CurrentJobBlip)
end

RegisterNetEvent('brutal_policejob:client:finishJail')
AddEventHandler('brutal_policejob:client:finishJail', function(type)
    inPrison = false
    Escaping = false
    Escaped = false
    jailMinute = 0
    RemoveBlip(prisonHospitalBlip)
    RemoveBlip(JobBlip)
    RemoveBlip(PrisonShopBlip)
    SendNUIMessage({action = "HideJailHud"})

    for k,v in pairs(PrisonGuards) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end

    if type == 'general' then
        SendNotify(24)
        SetEntityCoords(PlayerPedId(), Config.Prison.FinishCoords, true, true, true, false)
        CitizenWear()
    else
        SendNotify(25)
    end
end)

if Config['Core']:upper() == 'ESX' then
    AddEventHandler(onPlayerDeath, function()
        if inPrison then
            ReviveFunction()
        end
    end)
elseif Config['Core']:upper() == 'QBCORE' then
    RegisterNetEvent('brutal_policejob:client:PlayerDied')
    AddEventHandler('brutal_policejob:client:PlayerDied', function()
        if inPrison then
            ReviveFunction()
        end
    end)
end

function ReviveFunction()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    Citizen.Wait(5000)
    PlayerReviveFunction()
    FreezeEntityPosition(playerPed, true)
    Citizen.Wait(1500)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)

    if Config.Prison.Hospital.ClearInventory then
        TriggerServerEvent('brutal_policejob:server:ClearInventory')
    end

    local randomBed = math.random(1, #Config.Prison.Hospital.Beds)
    local CurrentBed = Config.Prison.Hospital.Beds[randomBed]
    SetEntityCoords(playerPed, CurrentBed.coords)

    bedObject = GetClosestObjectOfType(playerCoords, 3.0, CurrentBed.prop, false, false, false)
    FreezeEntityPosition(bedObject, true)

    loadAnimDict("anim@gangops@morgue@table@")
    TaskPlayAnim(playerPed, "anim@gangops@morgue@table@" , "body_search", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(playerPed, CurrentBed.heading)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, playerPed, 31085, 0, 1.0, 1.0 , true)
    SetCamFov(cam, 90.0)
    local heading = GetEntityHeading(playerPed)
    heading = (heading > 180) and heading - 180 or heading + 180
    SetCamRot(cam, -45.0, 0.0, heading, 2)

    Citizen.Wait(1500)
    DoScreenFadeIn(1000)

    Citizen.Wait(1000*Config.Prison.Hospital.ReviveTime)


    FreezeEntityPosition(playerPed, false)
    SetEntityInvincible(playerPed, false)
    SetEntityHeading(playerPed, CurrentBed.heading + 90)

    loadAnimDict("switch@franklin@bed")
    TaskPlayAnim(playerPed, 'switch@franklin@bed' , 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Wait(4000)
    ClearPedTasks(playerPed)
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)
end

-----------------------------------------------------------
--------------------------| MDT |--------------------------
-----------------------------------------------------------

TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.MDT.Command ..'', Config.Commands.MDT.Suggestion)

RegisterCommand(Config.Commands.MDT.Command, function()
    TriggerEvent('brutal_policejob:client:MDTCommand')
end)

RegisterNetEvent('brutal_policejob:client:MDTCommand')
AddEventHandler('brutal_policejob:client:MDTCommand', function()
    if InDuty and not InMenu then
        OpenMenuUtil()

        local ped = GetPlayerPed(-1)
                
        tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(tab, ped, GetPedBoneIndex(ped, 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)

        loadAnimDict("amb@world_human_seat_wall_tablet@female@base")
        TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)

        local cops = 0
        if InDutyTable[PlayerData.job.name] then
            for k,v in pairs(InDutyTable[PlayerData.job.name]) do
                if v then
                    cops += 1
                end
            end
        end
        
        local x,y,z = table.unpack(GetEntityCoords(ped))

        SendNUIMessage({
            action = "OpenMDTMenu",
            job = {job = PlayerData.job.name, name = PlayerData.job.label, label = PlayerData.job.grade_label, salary = PlayerData.job.salary},
            street = {GetLabelText(GetNameOfZone(x,y,z)), GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))},
            name = PlayerData.name,
            cops = cops,
            cameras = Config.SecurityCameras.cameras,
            status = CameraStatus(),
            moneyform = Config.MoneyForm,
            menucolors = menuColors
        })
    end
end)


function CameraStatus()
    local SuccessfulProcess = false
    local CamerasStatus = {}

    TSCB('brutal_policejob:server:getSecurityCameraStatus', function(table)
        CamerasStatus = table
        SuccessfulProcess = true
    end)

    while not SuccessfulProcess do
        Citizen.Wait(1)
    end

    return CamerasStatus
end

-----------------------------------------------------------
---------------------| Bullet Proofs |---------------------
-----------------------------------------------------------

RegisterNetEvent('brutal_policejob:client:UseBulletProofItem')
AddEventHandler('brutal_policejob:client:UseBulletProofItem', function(job, onlyjob)
    if onlyjob and PlayerData.job.name ~= job then
        SendNotify(9)
        return
    end

    BulletProofVest()
end)

-----------------------------------------------------------
-------------------| security cameras |--------------------
-----------------------------------------------------------

local currentCameraIndex = 0
local createdCamera = 0

function GetCurrentTime()
    local hours = GetClockHours()
    local minutes = GetClockMinutes()
    if hours < 10 then
        hours = tostring(0 .. GetClockHours())
    end
    if minutes < 10 then
        minutes = tostring(0 .. GetClockMinutes())
    end
    return tostring(hours .. ":" .. minutes)
end

function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Wait(250)
    createdCamera = cam

    Citizen.CreateThread(function()
        while createdCamera ~= 0 do

            HelpText(Config.Locales.CameraLabel)

            SetTimecycleModifier("scanline_cam_cheap")
            SetTimecycleModifierStrength(1.0)

            -- CLOSE CAMERAS
            if IsControlJustPressed(1, 177) then
                DoScreenFadeOut(250)
                while not IsScreenFadedOut() do
                    Wait(0)
                end
                CloseSecurityCamera()
                SendNUIMessage({type = "disablecam"})
                DoScreenFadeIn(250)
            end

            local getCameraRot = GetCamRot(createdCamera, 2)

            -- ROTATE UP
            if IsControlPressed(0, 172) then
                if getCameraRot.x <= 0.0 then
                    SetCamRot(createdCamera, getCameraRot.x + 0.5, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE DOWN
            if IsControlPressed(0, 173) then
                if getCameraRot.x >= -50.0 then
                    SetCamRot(createdCamera, getCameraRot.x - 0.5, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE LEFT
            if IsControlPressed(0, 174) then
                SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z + 0.5, 2)
            end

            -- ROTATE RIGHT
            if IsControlPressed(0, 175) then
                SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z - 0.5, 2)
            end
            Citizen.Wait(1)
        end
    end)
end

function HelpText(text, sound, _end)
    text = tostring(text)
    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(0, 0, (sound == true), 2500)
end

function CloseSecurityCamera()
    EnableMinimap()
    FreezeEntityPosition(PlayerPedId(), false)

    SendNUIMessage({action = "DisableCam"})
    TriggerEvent('brutal_policejob:client:MDTCommand')

    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
    FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end

RegisterNetEvent('brutal_policejob:client:ActivateCamera', function(cameraId)
    if Config.SecurityCameras.cameras[cameraId] then
        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Wait(0)
        end
        DisableMinimap()
        FreezeEntityPosition(PlayerPedId(), true)

        SendNUIMessage({
            action = "EnableCam",
            label = Config.SecurityCameras.cameras[cameraId].label,
            id = cameraId,
            connected = Config.SecurityCameras.cameras[cameraId].isOnline
        })
        
        local firstCamx = Config.SecurityCameras.cameras[cameraId].coords.x
        local firstCamy = Config.SecurityCameras.cameras[cameraId].coords.y
        local firstCamz = Config.SecurityCameras.cameras[cameraId].coords.z
        local firstCamr = Config.SecurityCameras.cameras[cameraId].r
        SetFocusArea(firstCamx, firstCamy, firstCamz, firstCamx, firstCamy, firstCamz)
        ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)
        currentCameraIndex = cameraId

        DoScreenFadeIn(250)
    elseif cameraId == 0 then
        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Wait(0)
        end
        CloseSecurityCamera()
        DoScreenFadeIn(250)
    end
end)

if Config.SecurityCameras.hack.enable then
    RegisterNetEvent('brutal_policejob:client:UseCamHackItem')
    AddEventHandler('brutal_policejob:client:UseCamHackItem', function()
        if not InDuty then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local NearAnyCam = false

            CameraHackingID = nil

            for k,v in pairs(Config.SecurityCameras.cameras) do
                CameraHackingID = k
                local distance = #(playerCoords - v.coords)

                if distance <= Config.SecurityCameras.hack.distance then
                    NearAnyCam = true

                    local ped = GetPlayerPed(-1)
                    
                    tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
                    AttachEntityToEntity(tab, ped, GetPedBoneIndex(ped, 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)

                    loadAnimDict("amb@world_human_seat_wall_tablet@female@base")
                    TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)

                    TriggerEvent("mhacking:show")
                    TriggerEvent("mhacking:start", 4, Config.SecurityCameras.hack.time, SecurityCameraHack)

                    if Config.SecurityCameras.hack.removeItem then
                        TriggerServerEvent('brutal_policejob:server:Removetem', Config.SecurityCameras.hack.item)
                    end

                    break
                end
            end

            if not NearAnyCam then
                SendNotify(17)
            end
        else
            SendNotify(9)
        end
    end)

    function SecurityCameraHack(success)
        ClearPedTasks(GetPlayerPed(-1))
        DeleteEntity(tab)
        TriggerEvent('mhacking:hide')
    
        if success then
            SendNotify(19)
            TriggerServerEvent('brutal_policejob:server:SetCameraStatus', CameraHackingID, false)
        else
            SendNotify(18)
        end
    end
end

TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.CameraRepair.Command ..'', Config.Commands.CameraRepair.Suggestion)

RegisterCommand(Config.Commands.CameraRepair.Command, function()
    if not InMenu and InDuty then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local NearAnyCam = false

        CameraHackingID = nil

        for k,v in pairs(Config.SecurityCameras.cameras) do
            CameraHackingID = k
            local distance = #(playerCoords - v.coords)

            if distance <= Config.SecurityCameras.hack.distance then
                NearAnyCam = true

                local ped = GetPlayerPed(-1)
                
                tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	            AttachEntityToEntity(tab, ped, GetPedBoneIndex(ped, 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)

                loadAnimDict("amb@world_human_seat_wall_tablet@female@base")
                TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)

                Citizen.Wait(6000)
                ClearPedTasks(ped)
                DeleteEntity(tab)
            
                SendNotify(20)
                TriggerServerEvent('brutal_policejob:server:SetCameraStatus', CameraHackingID, true)

                break
            end
        end

        if not NearAnyCam then
            SendNotify(17)
        end
    end
end)

-----------------------------------------------------------
---------------------| speed cameras |---------------------
-----------------------------------------------------------

if Config.SpeedCameras.Use then
    SpeedCameraInVehicle = false

    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        if GetVehiclePedIsIn(PlayerPedId()) > 0 then
            if isSpeedWhitelilistedJob() == false then
                SpeedCameraInVehicle = true
                StartSpeedCameraChecker()
            end
        end

        for k,v in pairs(Config.SpeedCameras.Positions) do
            if v.blip then
                local blip = AddBlipForCoord(v.coords)
                SetBlipSprite(blip, Config.SpeedCameras.Blips.sprite)
                SetBlipColour(blip, Config.SpeedCameras.Blips.color)
                SetBlipScale(blip, Config.SpeedCameras.Blips.size)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(Config.Locales.SpeedCameraBlipLabel..' ['..v.limit..' '..Config.Metric:lower()..']')
                EndTextCommandSetBlipName(blip)
                SetBlipAsShortRange(blip, true)
            end
        end
    end)

    AddEventHandler('gameEventTriggered', function (name, args)
        if name == 'CEventNetworkPlayerEnteredVehicle' then
            if not SpeedCameraInVehicle then
                if isSpeedWhitelilistedJob() == false then
                    SpeedCameraInVehicle = true
                    StartSpeedCameraChecker()
                end
            end
        end
    end)

    function StartSpeedCameraChecker()
        Citizen.CreateThread(function()
            while SpeedCameraInVehicle do
                for k,v in pairs(Config.SpeedCameras.Positions) do
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local playerVehicle = GetVehiclePedIsIn(playerPed)
                    local vehicleDriver = GetPedInVehicleSeat(playerVehicle, -1)
                    local Speed = math.floor(GetEntitySpeed(playerPed)*metric)

                    if playerVehicle > 0 then
                        if vehicleDriver == playerPed then
                            if #(playerCoords - v.coords) < v.radius then
                                if Speed > v.limit then
                                    local amount = v.price
                                    if Speed > v.limit*2 and Speed < v.limit*3 then
                                        amount = amount*2
                                    elseif Speed > v.limit*3 then
                                        amount = amount*3
                                    end

                                    SendNUIMessage({action = "SpeedNotify", speed = Speed, limit = v.limit, amount = amount, metric = Config.Metric:lower(), moneyform = Config.MoneyForm })

                                    TriggerServerEvent('brutal_policejob:server:GiveFine', v.job, JobLabel(v.job), GetPlayerServerId(PlayerId()), Config.Locales.SpeedCameraFine..' '..Speed..' '..Config.Metric:lower(), amount)
                                    Citizen.Wait(10000)
                                end
                            end
                        end
                    else
                        SpeedCameraInVehicle = false
                    end
                end
                Citizen.Wait(60)
            end
        end)
    end
end

function isSpeedWhitelilistedJob()
    local whitelisted = false

    for k,v in pairs(Config.SpeedCameras.OtherWhitelistedJobs) do
        if v:lower() == PlayerData.job.name then
            whitelisted = true
        end
    end

    if InDuty then
        whitelisted = true
    end

    return whitelisted
end

-----------------------------------------------------------
---------------------| siren system |----------------------
-----------------------------------------------------------

-- VehiclePanel Command
TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.VehiclePanel.Command ..'', Config.Commands.VehiclePanel.Suggestion)

RegisterCommand(Config.Commands.VehiclePanel.Command, function()
    if not InMenu and InDuty then
        SetNuiFocus(true, true)
        SendNUIMessage({action = "VehiclePanelEdit", menucolors = menuColors})
    end
end)

-- PlateReader Command

RegisterKeyMapping(Config.Commands.PlateReader.Command, Config.Commands.PlateReader.Suggestion, "keyboard", Config.Commands.PlateReader.Control)
TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.PlateReader.Command ..'', Config.Commands.PlateReader.Suggestion)

RegisterCommand(Config.Commands.PlateReader.Command, function()
    if GameInVehicle and not InMenu and InDuty then
        if not PlateReader then
            PlateReader = true
            SendNUIMessage({action = "PlateReaderStatus", enable = PlateReader})
        else
            PlateReader = false
            SendNUIMessage({action = "PlateReaderStatus", enable = PlateReader})
        end
    end
end)

GameInVehicle = false
PlateReader = false

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    if GetVehiclePedIsIn(PlayerPedId()) > 0 then
        if InDuty then
            GameInVehicle = true
            SirenActivate()
        end
    end
end)

AddEventHandler('gameEventTriggered', function (name, args)
    if name == 'CEventNetworkPlayerEnteredVehicle' then
        if not GameInVehicle then
            if InDuty then
                GameInVehicle = true
                SirenActivate()
            end
        end
    end
end)

function SirenActivate()
    SendNUIMessage({action = "VehiclePanel", menucolors = menuColors})

    Citizen.CreateThread(function()
        while GameInVehicle do
            local playerPed = PlayerPedId()
            local playerVehicle = GetVehiclePedIsIn(playerPed)
            local playerVehicleCoords = GetEntityCoords(playerVehicle)
            local vehicleDriver = GetPedInVehicleSeat(playerVehicle, -1)

            local Whitelisted = false
            if Config.Commands.PlateReader.WhitelistedVehicles == false then
                Whitelisted = true
            else
                for k,v in pairs(Config.Commands.PlateReader.WhitelistedVehicles) do
                    if GetHashKey(v:lower()) == GetEntityModel(playerVehicle) then
                        Whitelisted = true
                    end
                end
            end
            
            if playerVehicle > 0 and Whitelisted then
                if vehicleDriver == GetPlayerPed(-1) then
                    frontPlate = ''
                    rearPlate = ''
                    frontSpeed = 0
                    rearSpeed = 0
                    hornStatus = false
                    siren = false
                    vehicleLight = 'off'

                    if IsControlPressed(0, 38) then
                        hornStatus = true
                    end

                    if IsVehicleSirenOn(playerVehicle) then
                        siren = true
                    end

                    local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(playerVehicle)
                    if vehicleLights == 1 or vehicleHighlights == 1 then
                        vehicleLight = true
                    end

                    if PlateReader then

                        local areas = {5.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0}
                        local frontVehicle = nil

                        for k,v in pairs(areas) do
                            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(playerVehicle, 0.0, v, 0.0))
                            local fvehicle = GetClosestVehicleFunction(vector3(x,y,z))

                            if #(vector3(x,y,z) - GetEntityCoords(fvehicle)) <= v and playerVehicle ~= fvehicle then
                                frontVehicle = fvehicle
                                frontSpeed = math.floor(GetEntitySpeed(frontVehicle)*metric)
                                if GetVehiclePlateType(frontVehicle) ~= 3 then
                                    frontPlate = GetVehicleNumberPlateText(frontVehicle)
                                else
                                    frontPlate = Config.Locales.None
                                end

                                break
                            end
                        end

                        for k,v in pairs(areas) do
                            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(playerVehicle, 0.0, -v, 0.0))
                            local rvehicle = GetClosestVehicleFunction(vector3(x,y,z))
                            local platetype = GetVehiclePlateType(fvehicle)
    
                            if #(vector3(x,y,z) - GetEntityCoords(rvehicle)) <= v and playerVehicle ~= rvehicle then
                                rearVehicle = rvehicle
                                rearSpeed = math.floor(GetEntitySpeed(rearVehicle)*metric)
                                if GetVehiclePlateType(rearVehicle) ~= 3 then
                                    rearPlate = GetVehicleNumberPlateText(rearVehicle)
                                else
                                    rearPlate = Config.Locales.None
                                end

                                break
                            end
                        end
                    end

                    SendNUIMessage({
                        action = "VehicleSystem", 
                        plate = GetVehicleNumberPlateTextIndex(playerVehicle),
                        frontvehicle = {plate = frontPlate, speed = frontSpeed}, 
                        rearvehicle = {plate = rearPlate, speed = rearSpeed},
                        horn = hornStatus,
                        siren = siren,
                        vehiclelight = vehicleLight
                    })
                else
                    GameInVehicle = false
                    SendNUIMessage({action = "HideVehiclePanel"})
                end
            else
                GameInVehicle = false
                SendNUIMessage({action = "HideVehiclePanel"})
            end
            Citizen.Wait(50)
        end
    end)
end

-----------------------------------------------------------
-----------------------| area lock |-----------------------
-----------------------------------------------------------

TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.AreaLock.Command ..'', Config.Commands.AreaLock.Suggestion)

RegisterCommand(Config.Commands.AreaLock.Command, function()
    if not InMenu and InDuty then
        OpenMenuUtil()
        SendNUIMessage({action = "AreaLockMenu", menucolors = menuColors})
    end
end)

RegisterNetEvent('brutal_policejob:client:arealock')
AddEventHandler('brutal_policejob:client:arealock', function(coords, label, time, range, sprite)
    local areablip = AddBlipForCoord(coords)
    SetBlipSprite(areablip, sprite)
    SetBlipColour(areablip, 1)
    SetBlipScale(areablip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(areablip)
    SetBlipAsShortRange(areablip, true)

    local areablip2 = AddBlipForRadius(coords, range+0.0)
	SetBlipHighDetail(areablip2, true)
	SetBlipColour(areablip2, 53)
    SetBlipAlpha(areablip2, 150)
    
    Citizen.CreateThread(function()
        Citizen.Wait(1000*60*time)
        RemoveBlip(areablip)
        RemoveBlip(areablip2)
    end)
end)

-----------------------------------------------------------
---------------------| citizen call |----------------------
-----------------------------------------------------------

TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.CitizenCall.Command ..'', Config.Commands.CitizenCall.Suggestion)

RegisterCommand(Config.Commands.CitizenCall.Command, function()
    OpenMenuUtil()
    SendNUIMessage({action = "CitizenCallMenu"})
end)

RegisterNetEvent('brutal_policejob:client:CitizenCallRefreshTable')
AddEventHandler('brutal_policejob:client:CitizenCallRefreshTable', function(CitizenCalls)
    SendNUIMessage({action = "MDTGetCitizenCalls", table = CitizenCalls, myid = GetPlayerServerId(PlayerId())})
end)

RegisterNetEvent('brutal_policejob:client:RemoveCitizenCallBlip')
AddEventHandler('brutal_policejob:client:RemoveCitizenCallBlip', function(id)
    if InDuty then
        RemoveBlip(CallBlips[id])
        CallBlips[id] = nil
    end
end)

RegisterNetEvent('brutal_policejob:client:CitizenCallArived')
AddEventHandler('brutal_policejob:client:CitizenCallArived', function(id, street)
    if InDuty then
        notification(Config.Notify[27][1], '#'..id..' '..Config.Notify[27][2]..' '..street, Config.Notify[27][3], Config.Notify[27][4])
    end
end)

-----------------------------------------------------------
--------------------| drag animation |---------------------
-----------------------------------------------------------

local dragging_data = {
	InProgress = false,
	target = -1,
	Anim = {
		dict = "combat@drag_ped@",
		start = "injured_pickup_back_",
		loop = "injured_drag_",
		ending = "injured_putdown_"
	}
}

local old_TaskPlayAnim = TaskPlayAnim
function TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration , flag, playbackRate, lockX, lockY, lockZ)
	old_TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration , flag, playbackRate, lockX, lockY, lockZ)
	RemoveAnimDict(animDictionary)
	return
end

function PlayAnim(type, desinence)
	local duration = nil
	if type == "loop" then duration = -1 elseif type == "start" then duration = 6000 elseif type == "ending" then duration = 5000 end

	loadAnimDict(dragging_data.Anim.dict)
	TaskPlayAnim(PlayerPedId(), dragging_data.Anim.dict, dragging_data.Anim[type]..desinence, 8.0, -8.0, duration, 33, 0, 0, 0, 0)

	if duration ~= -1 then
		Wait(duration)
		ClearPedTasks(PlayerPedId())
	end
end

TriggerEvent('chat:addSuggestion', '/'.. Config.Commands.Drag.Command ..'', Config.Commands.Drag.Suggestion)

RegisterCommand(Config.Commands.Drag.Command, function()
    if not InMenu and InDuty then
        DragClosest()
    end
end)

function DragClosest()
	local player = PlayerPedId()
	
	if not dragging_data.InProgress then
        local closestPlayer, closestDistance = GetClosestPlayerFunction()

        if closestPlayer ~= -1 and closestDistance <= 1.2 and IsPedDeadOrDying(closestPlayer)then
            local Ped_ClosestPlayer = GetPlayerPed(closestPlayer)
			local target = GetPlayerServerId(closestPlayer)
			if target ~= -1 then
				dragging_data.InProgress = true
				dragging_data.target = target

				TriggerServerEvent("brutal_policejob:server:drag:sync",target)
				PlayAnim("start", "plyr")
				PlayAnim("loop", "plyr")
			else
				SendNotify(28)
			end
		else
			SendNotify(28)
		end
	else
		local target_ped = GetPlayerPed(GetPlayerFromServerId(dragging_data.target))

		TriggerServerEvent("brutal_policejob:server:drag:stop",dragging_data.target)
		
		DetachEntity(PlayerPedId(), true, false)
		PlayAnim("ending", "plyr")
		ClearPedTasks(target_ped)

		dragging_data.InProgress = false
		dragging_data.target = 0
	end
end

RegisterNetEvent("brutal_policejob:client:drag:syncTarget")
AddEventHandler("brutal_policejob:client:drag:syncTarget", function(target)
	local target_ped = GetPlayerPed(GetPlayerFromServerId(target))
	local player 	 = PlayerPedId()

	dragging_data.InProgress = true

	SetEntityCoords(player, GetOffsetFromEntityInWorldCoords(target_ped, 0.0, 1.2, -1.0))
	SetEntityHeading(player, GetEntityHeading(target_ped))
	PlayAnim("start", "ped")
	ClearPedTasks(player)

	AttachEntityToEntity(player, target_ped, 1816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0)
	PlayAnim("loop", "ped")
end)

RegisterNetEvent("brutal_policejob:client:drag:cl_stop")
AddEventHandler("brutal_policejob:client:drag:cl_stop", function(_target)
	_target = GetPlayerPed(GetPlayerFromServerId(_target))
	dragging_data.InProgress = false

	DetachEntity(PlayerPedId(), true, false)
	SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(_target, 0.0, 0.4, -1.0))
	PlayAnim("ending", "ped")
end)

-----------------------------------------------------------
--------------------| basic functions |--------------------
-----------------------------------------------------------

RegisterNetEvent('brutal_policejob:client:SendNotify')
AddEventHandler('brutal_policejob:client:SendNotify', function(title, text, time, type)
	notification(title, text, time, type)
end)

function SendNotify(Number)
    notification(Config.Notify[Number][1], Config.Notify[Number][2], Config.Notify[Number][3], Config.Notify[Number][4])
end

function JobLabel(job)
    local label = ''
    for k,v in pairs(Config.PoliceStations) do
        if v.Job == job then
            label = k
            break
        end
    end
    return label
end

function CreateVehicleFunction(model, livery, coords)
    local ped = GetPlayerPed(-1)
    local closestVeh = GetClosestVehicleFunction(vector3(coords[1], coords[2], coords[3]))

    if closestVeh == -1 or #(GetEntityCoords(closestVeh) - vector3(coords[1], coords[2], coords[3])) >= 5.0 then
        DoScreenFadeOut(400)
        Citizen.Wait(400)

        while not HasModelLoaded(GetHashKey(model)) do
            RequestModel(GetHashKey(model))
            Citizen.Wait(0)
        end
        PoliceVehicle = CreateVehicle(GetHashKey(model), coords, true, false)
        local id = NetworkGetNetworkIdFromEntity(PoliceVehicle)
        SetNetworkIdCanMigrate(id, true)
        SetEntityAsMissionEntity(PoliceVehicle, true, true)
        SetVehicleHasBeenOwnedByPlayer(PoliceVehicle, true)
        SetVehicleNeedsToBeHotwired(PoliceVehicle, false)
        SetModelAsNoLongerNeeded(model)
        SetVehRadioStation(PoliceVehicle, 'OFF')
        SetVehicleNumberPlateText(PoliceVehicle, GeneratePolicePlace())
        SetVehicleDirtLevel(PoliceVehicle, 0)
        SetPedIntoVehicle(ped, PoliceVehicle, -1)
        SetVehicleLivery(PoliceVehicle, 0)

        Citizen.Wait(300)
        DoScreenFadeIn(600)

        -- Camera Rotation Fix
        SetGameplayCamRelativeHeading(GetEntityHeading(ped)-coords[4])
        SetGameplayCamRelativePitch(90, 1.0)

        TriggerEvent('brutal_policejob:client:utils:CreateVehicle', PoliceVehicle)

        Citizen.Wait(800)

        Citizen.CreateThread(function()
            liveryCount = GetVehicleLiveryCount(PoliceVehicle)
            liveryCurrent = 0

            SendNUIMessage({action = "LiveryMenu", livery = liveryCurrent})

            while true do
                local playerPed = PlayerPedId()

                if GetEntitySpeed(playerPed) > 0.5 then
                    SendNUIMessage({action = "HideLiveryMenu"})
                    break
                end

                if IsControlJustPressed(0, 174) then
                    if liveryCurrent-1 >= 0 then
                        liveryCurrent -= 1
                    else
                        liveryCurrent = liveryCount
                    end
                    SetVehicleLivery(PoliceVehicle, liveryCurrent)
                    SendNUIMessage({action = "LiveryMenu", livery = liveryCurrent})
                end

                if IsControlJustPressed(0, 175) then
                    if liveryCurrent+1 <= liveryCount then
                        liveryCurrent += 1
                    else
                        liveryCurrent = 0
                    end
                    SetVehicleLivery(PoliceVehicle, liveryCurrent)
                    SendNUIMessage({action = "LiveryMenu", livery = liveryCurrent})
                end

                Citizen.Wait(1)
            end
        end)
    else
        SendNotify(5)
    end
    
    return Vehicle
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do        
        Citizen.Wait(1)
    end
end

function RequestSpawnObject(object)
    local hash = GetHashKey(object)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Wait(1)
    end
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return b, c, e
end

function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

-----------------------------------------------------------
-----------------| NOT RENAME THE SCRIPT |-----------------
-----------------------------------------------------------

Citizen.CreateThread(function()
    Citizen.Wait(1000*30)
	if GetCurrentResourceName() ~= 'brutal_policejob' then
		while true do
			Citizen.Wait(1)
			print("Please don't rename the script! Please rename it back to 'brutal_policejob'")
		end
	end
end)