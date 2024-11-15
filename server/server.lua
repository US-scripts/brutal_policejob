OneSync = GetConvar("onesync", "off")
if (OneSync ~= "off" and OneSync ~= "legacy") then 
    OneSync = 'infinite'
end

-----------------------------------------------------------
-------------------------| jail |--------------------------
-----------------------------------------------------------

RESCB("brutal_policejob:server:getplayerdatas",function(source,cb)
    local jailMinute = 0

    if Config['Core']:upper() == 'ESX' then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', { ['@identifier'] = GetIdentifier(source)}, function(results)
            if results[1] then
                jailMinute = results[1].jail_time
            end
        end)
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.Async.fetchAll('SELECT * FROM players WHERE citizenid = @citizenid', { ['@citizenid'] = GetIdentifier(source)}, function(results)
            if results[1] then
                jailMinute = results[1].jail_time
            end
        end)
    end
    
    Citizen.Wait(1000)
    cb({jailminute = jailMinute, playername = GetPlayerNameFunction(source)})
end)

RegisterNetEvent("brutal_policejob:server:finishJail")
AddEventHandler("brutal_policejob:server:finishJail", function(targetID, type)
    if Config['Core']:upper() == 'ESX' then
        MySQL.Async.execute('UPDATE users SET jail_time = @jail_time, jail_reason = @jail_reason WHERE identifier = @identifier', {
            ["@identifier"] = GetIdentifier(targetID), 
            ["@jail_time"] = 0,
            ["@jail_reason"] = "",
        }, nil)
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.Async.execute('UPDATE players SET jail_time = @jail_time, jail_reason = @jail_reason WHERE citizenid = @citizenid', {
            ["@citizenid"] = GetIdentifier(targetID), 
            ["@jail_time"] = 0,
            ["@jail_reason"] = "",
        }, nil)
    end

    TriggerClientEvent('brutal_policejob:client:finishJail', targetID, type)
end)

RegisterNetEvent("brutal_policejob:server:refreshJailTime")
AddEventHandler("brutal_policejob:server:refreshJailTime", function(targetID, time)
    if Config['Core']:upper() == 'ESX' then
        MySQL.Async.execute('UPDATE users SET jail_time = @jail_time WHERE identifier = @identifier', {
            ["@identifier"] = GetIdentifier(targetID), 
            ["@jail_time"] = time
        }, nil)
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.Async.execute('UPDATE players SET jail_time = @jail_time WHERE citizenid = @citizenid', {
            ["@citizenid"] = GetIdentifier(targetID), 
            ["@jail_time"] = time
        }, nil)
    end
end)

RegisterNetEvent("brutal_policejob:server:prisonJobPay")
AddEventHandler("brutal_policejob:server:prisonJobPay", function(data)
    AddMoneyFunction(source, data.account, data.amount)
end)

-----------------------------------------------------------
--------------------------| MDT |--------------------------
-----------------------------------------------------------

RESCB("brutal_policejob:server:policeDatabaseGetData",function(source, cb, type, value1, value2)
    local Table = {}
    local sql = false
    if type == 'plate' then
        local plate = '%'..value1..'%'

        if Config['Core']:upper() == 'ESX' then
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate LIKE @plate', { ['@plate'] = plate}, function(results)
                for k,v in pairs(results) do
                    local vehicleOwner = GetPlayerByIdentifier(results[k].owner)
                    
                    table.insert(Table, {model = json.decode(results[k].vehicle).model, plate = results[k].plate, owner = vehicleOwner.name, photo = results[k].mdt_photo, notes = json.decode(results[k].mdt_notes), class = ''})
                end
                sql = true
            end)
        elseif Config['Core']:upper() == 'QBCORE' then
            MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate LIKE @plate', { ['@plate'] = plate}, function(results)
                for k,v in pairs(results) do
                    local vehicleOwner = GetPlayerByIdentifier(results[k].citizenid).PlayerData.charinfo
                    
                    table.insert(Table, {model = results[k].vehicle, plate = results[k].plate, owner = vehicleOwner.lastname..' '..vehicleOwner.firstname, photo = results[k].mdt_photo, notes = json.decode(results[k].mdt_notes), class = ''})
                end
                sql = true
            end)
        end
    elseif type == 'firstname' then
        local firstname = '%'..value1..'%'
        if Config['Core']:upper() == 'ESX' then
            MySQL.Async.fetchAll('SELECT * FROM users WHERE firstname LIKE @firstname', { ['@firstname'] = firstname}, function(results)
                for k,v in pairs(results) do
                    table.insert(Table, {identifier = results[k].identifier, firstname = results[k].firstname, lastname = results[k].lastname, sex = results[k].sex, dateofbirth = results[k].dateofbirth, photo = results[k].mdt_photo, notes = json.decode(results[k].mdt_notes), jail_time = results[k].jail_time, jail_reason = results[k].jail_reason})
                end
                sql = true
            end) 
        elseif Config['Core']:upper() == 'QBCORE' then
            MySQL.Async.fetchAll('SELECT * FROM players WHERE LOWER(CONCAT(JSON_VALUE(charinfo, "$.firstname"))) LIKE @firstname', { ['@firstname'] = firstname:lower()}, function(results)
                for k,v in pairs(results) do
                   local charinfo = json.decode(results[k].charinfo)
                   table.insert(Table, {identifier = results[k].citizenid, firstname = charinfo.firstname, lastname = charinfo.lastname, sex = charinfo.gender, dateofbirth = charinfo.birthdate, photo = results[k].mdt_photo, notes = json.decode(results[k].mdt_notes), jail_time = results[k].jail_time, jail_reason = results[k].jail_reason})
                end
                sql = true
            end) 
        end
    elseif type == 'lastname' then
        local lastname = '%'..value2..'%'
        if Config['Core']:upper() == 'ESX' then
            MySQL.Async.fetchAll('SELECT * FROM users WHERE lastname LIKE @lastname', { ['@lastname'] = lastname}, function(results)
                for k,v in pairs(results) do
                    table.insert(Table, {identifier = results[k].identifier, firstname = results[k].firstname, lastname = results[k].lastname, sex = results[k].sex, dateofbirth = results[k].dateofbirth, photo = results[k].mdt_photo, notes = json.decode(results[k].mdt_notes), jail_time = results[k].jail_time, jail_reason = results[k].jail_reason})
                end
                sql = true
            end)
        elseif Config['Core']:upper() == 'QBCORE' then
            MySQL.Async.fetchAll('SELECT * FROM players WHERE LOWER(CONCAT(JSON_VALUE(charinfo, "$.lastname"))) LIKE @lastname', { ['@lastname'] = lastname:lower()}, function(results)
                for k,v in pairs(results) do
                   local charinfo = json.decode(results[k].charinfo)
                   table.insert(Table, {identifier = results[k].citizenid, firstname = charinfo.firstname, lastname = charinfo.lastname, sex = charinfo.gender, dateofbirth = charinfo.birthdate, photo = results[k].mdt_photo, notes = json.decode(results[k].mdt_notes), jail_time = results[k].jail_time, jail_reason = results[k].jail_reason})
                end
                sql = true
            end) 
        end
    elseif type == 'fullname' then
        local firstname = '%'..value1..'%'
        local lastname = '%'..value2..'%'
        if Config['Core']:upper() == 'ESX' then
            MySQL.Async.fetchAll('SELECT * FROM users WHERE firstname LIKE @firstname AND lastname LIKE @lastname', {['@firstname'] = firstname,['@lastname'] = lastname}, function(results)
                for k,v in pairs(results) do
                    table.insert(Table, {identifier = results[k].identifier, firstname = results[k].firstname, lastname = results[k].lastname, sex = results[k].sex, dateofbirth = results[k].dateofbirth, photo = results[k].mdt_photo, notes = json.decode(results[k].mdt_notes), jail_time = results[k].jail_time, jail_reason = results[k].jail_reason})
                end
                sql = true
            end)
        elseif Config['Core']:upper() == 'QBCORE' then
            MySQL.Async.fetchAll('SELECT * FROM players WHERE LOWER(CONCAT(JSON_VALUE(charinfo, "$.firstname"))) LIKE @firstname AND LOWER(CONCAT(JSON_VALUE(charinfo, "$.lastname"))) LIKE @lastname', { ['@firstname'] = firstname, ['@lastname'] = lastname}, function(results)
                for k,v in pairs(results) do
                   local charinfo = json.decode(results[k].charinfo)
                   table.insert(Table, {identifier = results[k].citizenid, firstname = charinfo.firstname, lastname = charinfo.lastname, sex = charinfo.gender, dateofbirth = charinfo.birthdate, photo = results[k].mdt_photo, notes = json.decode(results[k].mdt_notes), jail_time = results[k].jail_time, jail_reason = results[k].jail_reason})
                end
                sql = true
            end)
        end
    end

    while sql == false do
        Citizen.Wait(1)
    end

    cb({table = Table, type = type})
end)

RegisterServerEvent('brutal_policejob:server:GiveFine')
AddEventHandler('brutal_policejob:server:GiveFine', function(job, jobname, targetIdentifier, name, price, targetname)
    if targetname == nil then
        targetname = GetPlayerNameFunction(source)
    end

    if type(targetIdentifier) == 'number' then
        targetIdentifier = GetIdentifier(targetIdentifier)
    end

    if Config.Billing:lower() == 'esx_billing' then
        MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {targetIdentifier, 'society_'..job, 'society', 'society_'..job, name, price})
    elseif Config.Billing:lower() == 'okokbilling' then
        MySQL.insert('INSERT INTO okokbilling (ref_id, fees_amount, receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, sent_date, limit_pay_date) VALUES (CONCAT("OK", UPPER(LEFT(UUID(), 8))), 0, @receiver_identifier, @receiver_name, @author_identifier, @author_name, @society, @society_name, @item, @invoice_value, @status, @notes, CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY))', {
            ['@receiver_identifier'] = targetIdentifier,
            ['@receiver_name'] = targetname,
            ['@author_identifier'] = 'society_'..job,
            ['@author_name'] = name,
            ['@society'] = 'society_'..job,
            ['@society_name'] = jobname,
            ['@item'] = name,
            ['@invoice_value'] = price,
            ['@status'] = 'unpaid',
            ['@notes'] = ''
        })
    elseif Config.Billing:lower() == 'jaksam_billing' then
        MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {targetIdentifier, 'society_'..job, 'society', 'society_'..job, name, price})
    end

    TriggerClientEvent('brutal_policejob:client:SendNotify', source, Config.Notify[22][1], Config.Notify[22][2], Config.Notify[22][3], Config.Notify[22][4])
    DiscordWebhook('FineCreated', '**'.. Config.Webhooks.Locale['Text'] ..':** '..name..'\n**'.. Config.Webhooks.Locale['Amount'] ..':** '..price..' '..Config.MoneyForm..'\n\n**__'.. Config.Webhooks.Locale['Receiver']..'__**\n**'.. Config.Webhooks.Locale['PlayerName'] ..':** '..targetname..'\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '..targetIdentifier..'\n\n**__'.. Config.Webhooks.Locale['Assistant']..'__**\n**'.. Config.Webhooks.Locale['Job']..':** '.. job ..'\n**'.. Config.Webhooks.Locale['PlayerName']..':** '.. GetPlayerNameFunction(source)..' ['.. source ..']\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '.. GetIdentifier(source))
end)

RESCB("brutal_policejob:server:GetFines",function(source, cb, targetIdenfifier)
    FinesTable = {}
    sql = false
    if Config.Billing:lower() == 'esx_billing' then
        MySQL.query('SELECT amount, label FROM billing WHERE identifier = ?', {targetIdenfifier},
        function(results)
            for k,v in pairs(results) do
                table.insert(FinesTable, {amount = results[k].amount, label = results[k].label})
            end
            sql = true
        end)
    elseif Config.Billing:lower() == 'okokbilling' then
        MySQL.query('SELECT invoice_value, item, status FROM okokbilling WHERE receiver_identifier = ?', {targetIdenfifier},
        function(results)
            for k,v in pairs(results) do
                if results[k].status == 'unpaid' then
                    table.insert(FinesTable, {amount = results[k].invoice_value, label = results[k].item})
                end
            end
            sql = true
        end)
    elseif Config.Billing:lower() == 'jaksam_billing' then
        MySQL.query('SELECT amount, label FROM billing WHERE identifier = ?', {targetIdenfifier},
        function(results)
            for k,v in pairs(results) do
                table.insert(FinesTable, {amount = results[k].amount, label = results[k].label})
            end
            sql = true
        end)
    end

    while sql == false do
        Citizen.Wait(1)
    end

    cb(FinesTable)
end)

RESCB("brutal_policejob:server:GetLincences",function(source, cb, identifier)
    local target = GetPlayerByIdentifier(identifier)
    local targetSource = nil

    if target ~= nil then
        if Config['Core']:upper() == 'ESX' then
            targetSource = target.source
        elseif Config['Core']:upper() == 'QBCORE' then
            targetSource = target.PlayerData.source
        end
    end

    LicencesTable = {}

    if Config['Core']:upper() == 'ESX' then
        sql = false
        MySQL.query('SELECT type FROM user_licenses WHERE owner = ?', {identifier},
        function(results)
            for k,v in pairs(results) do
                table.insert(LicencesTable, results[k].type)
            end
            sql = true
        end)
        
        while sql == false do
            Citizen.Wait(1)
        end
    elseif targetSource ~= nil then
        for k,v in pairs(Config.Licences) do
            if target.PlayerData.metadata["licences"][k] then
                table.insert(LicencesTable, k)
            end
        end
    else
        LicencesTable = false
    end

    cb(LicencesTable)
end)

RegisterServerEvent('brutal_policejob:server:RemoveLicence')
AddEventHandler('brutal_policejob:server:RemoveLicence', function(identifier, licensetype)
    if Config['Core']:upper() == 'ESX' then
        MySQL.Async.execute('DELETE FROM user_licenses WHERE type = ? AND owner = ?', {licensetype, identifier})
    elseif Config['Core']:upper() == 'QBCORE' then
        local target = GetPlayerByIdentifier(identifier)

        if target ~= nil then
            local licenses = {[licensetype] = false, ["business"] = target.PlayerData.metadata["licences"]["business"], ["weapon"] = target.PlayerData.metadata["licences"]["weapon"]}
            target.Functions.SetMetaData("licences", licenses)
        end
    end
end)

-- User Notes

RegisterServerEvent('brutal_policejob:server:AddNewNote')
AddEventHandler('brutal_policejob:server:AddNewNote', function(identifier, text)
    local src = source
    if Config['Core']:upper() == 'ESX' then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', { ['@identifier'] = identifier}, function(results)
            local NotesTable = json.decode(results[1].mdt_notes)
            if NotesTable == nil then
                NotesTable = {}
            end

            table.insert(NotesTable, {text = text, name = GetPlayerNameFunction(src), date = os.date(Config.DateFormat)})
            MySQL.query.await('UPDATE users SET mdt_notes = ? WHERE identifier = ?',{json.encode(NotesTable), identifier})
        end)
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.Async.fetchAll('SELECT * FROM players WHERE citizenid = @citizenid', { ['@citizenid'] = identifier}, function(results)
            local NotesTable = json.decode(results[1].mdt_notes)
            if NotesTable == nil then
                NotesTable = {}
            end

            table.insert(NotesTable, {text = text, name = GetPlayerNameFunction(src), date = os.date(Config.DateFormat)})
            MySQL.query.await('UPDATE players SET mdt_notes = ? WHERE citizenid = ?',{json.encode(NotesTable), identifier})
        end)
    end
end)

RESCB("brutal_policejob:server:GetNotes",function(source, cb, identifier)
    NotesTable = {}
    sql = false
    if Config['Core']:upper() == 'ESX' then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', { ['@identifier'] = identifier}, function(results)
            NotesTable = json.decode(results[1].mdt_notes)
            sql = true
        end)
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.Async.fetchAll('SELECT * FROM players WHERE citizenid = @citizenid', { ['@citizenid'] = identifier}, function(results)
            NotesTable = json.decode(results[1].mdt_notes)
            sql = true
        end)
    end

    while sql == false do
        Citizen.Wait(1)
    end

    cb(NotesTable)
end)

-- Vehicle Notes

RegisterServerEvent('brutal_policejob:server:AddNewVehicleNote')
AddEventHandler('brutal_policejob:server:AddNewVehicleNote', function(plate, text)
    local src = source
    if Config['Core']:upper() == 'ESX' then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', { ['@plate'] = plate}, function(results)
            local NotesTable = json.decode(results[1].mdt_notes)
            if NotesTable == nil then
                NotesTable = {}
            end

            table.insert(NotesTable, {text = text, name = GetPlayerNameFunction(src), date = os.date(Config.DateFormat)})
            MySQL.query.await('UPDATE owned_vehicles SET mdt_notes = ? WHERE plate = ?',{json.encode(NotesTable), plate})
        end)
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = @plate', { ['@plate'] = plate}, function(results)
            local NotesTable = json.decode(results[1].mdt_notes)
            if NotesTable == nil then
                NotesTable = {}
            end

            table.insert(NotesTable, {text = text, name = GetPlayerNameFunction(src), date = os.date(Config.DateFormat)})
            MySQL.query.await('UPDATE player_vehicles SET mdt_notes = ? WHERE plate = ?',{json.encode(NotesTable), plate})
        end)
    end
end)

RESCB("brutal_policejob:server:GetVehicleNotes",function(source, cb, plate)
    NotesTable = {}
    sql = false
    if Config['Core']:upper() == 'ESX' then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', { ['@plate'] = plate}, function(results)
            NotesTable = json.decode(results[1].mdt_notes)
            sql = true
        end)
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = @plate', { ['@plate'] = plate}, function(results)
            NotesTable = json.decode(results[1].mdt_notes)
            sql = true
        end)
    end

    while sql == false do
        Citizen.Wait(1)
    end

    cb(NotesTable)
end)

-- Photos

RegisterServerEvent('brutal_policejob:server:AddVehiclePhoto')
AddEventHandler('brutal_policejob:server:AddVehiclePhoto', function(plate, url)
    local src = source
    if Config['Core']:upper() == 'ESX' then
        MySQL.query.await('UPDATE owned_vehicles SET mdt_photo = ? WHERE plate = ?',{url, plate})
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.query.await('UPDATE player_vehicles SET mdt_photo = ? WHERE plate = ?',{url, plate})
    end
end)

RegisterServerEvent('brutal_policejob:server:AddUserPhoto')
AddEventHandler('brutal_policejob:server:AddUserPhoto', function(identifier, url)
    local src = source
    if Config['Core']:upper() == 'ESX' then
        MySQL.query.await('UPDATE users SET mdt_photo = ? WHERE identifier = ?',{url, identifier})
    elseif Config['Core']:upper() == 'QBCORE' then
        MySQL.query.await('UPDATE players SET mdt_photo = ? WHERE citizenid = ?',{url, identifier})
    end
end)

-----------------------------------------------------------
-----------------------| area lock |-----------------------
-----------------------------------------------------------

RegisterServerEvent('brutal_policejob:server:arealock')
AddEventHandler('brutal_policejob:server:arealock', function(coords, label, time, range, sprite)
    TriggerClientEvent('brutal_policejob:client:arealock', -1, coords, label, time, range, sprite)
end)

-----------------------------------------------------------
---------------------| Citizen Call |----------------------
-----------------------------------------------------------

CitizenCalls = {}

RegisterServerEvent('brutal_policejob:server:citizencall')
AddEventHandler('brutal_policejob:server:citizencall', function(type, data1, data2, data3, data4)
    local src = source
    if type == 'create' then
        CitizenCalls[#CitizenCalls+1] = {
            text = data1,
            coords = data2,
            street = data3,
            time = data4,
            cops = {},
            closed = false,
            reason = ''
        }
        DiscordWebhook('CitizenCallOpen', '**'.. Config.Webhooks.Locale['Callid'] ..':** #'..#CitizenCalls..'\n**'.. Config.Webhooks.Locale['Text'] ..':** '..data1..'\n**'.. Config.Webhooks.Locale['PlayerName']..':** '.. GetPlayerNameFunction(source)..' ['.. source ..']\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '.. GetIdentifier(source))

        TriggerClientEvent('brutal_policejob:client:SendNotify', src, Config.Notify[21][1], Config.Notify[21][2], Config.Notify[21][3], Config.Notify[21][4])

        TriggerClientEvent('brutal_policejob:client:CitizenCallArived', -1, #CitizenCalls, data3)
    elseif type == 'accept' then
        table.insert(CitizenCalls[data1].cops, {id = src, name = GetPlayerNameFunction(src)})
    elseif type == 'close' then
        CitizenCalls[data1].closed = true
        CitizenCalls[data1].reason = data2
        DiscordWebhook('CitizenCallClose', '**'.. Config.Webhooks.Locale['Callid'] ..':** #'..data1..'\n**'.. Config.Webhooks.Locale['Text'] ..':** '..CitizenCalls[data1].text..'\n\n**__'.. Config.Webhooks.Locale['Assistant']..'__**\n**'.. Config.Webhooks.Locale['CloseReason']..':** '.. CitizenCalls[data1].reason ..'\n**'.. Config.Webhooks.Locale['PlayerName']..':** '.. GetPlayerNameFunction(source)..' ['.. source ..']\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '.. GetIdentifier(source))
        TriggerClientEvent('brutal_policejob:client:RemoveCitizenCallBlip', -1, data1)
    end

    TriggerClientEvent('brutal_policejob:client:CitizenCallRefreshTable', src, CitizenCalls)
end)

RESCB("brutal_policejob:server:GetCitizenCalls",function(source, cb)
    cb(CitizenCalls)
end)

-----------------------------------------------------------
-------------------------| shop |--------------------------
-----------------------------------------------------------

RegisterServerEvent('brutal_policejob:server:AddItem')
AddEventHandler('brutal_policejob:server:AddItem', function(ItemTable, Paytype)
    local Text = ''
    local TotalMoney = 0
    for k, v in pairs(ItemTable) do
        if Text == '' then
            Text = v.amount..'x '..v.label
        else
            Text = Text..', '..v.amount..'x '..v.label
        end
        if v.price ~= nil then 
            TotalMoney += v.price*v.amount
        end

        AddItem(source, v.item, v.amount)
    end

    DiscordWebhook('ItemBought', '**'.. Config.Webhooks.Locale['PlayerName']..':** '.. (source)..' ['.. source ..']\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '.. GetIdentifier(source) ..'\n**'.. Config.Webhooks.Locale['Items'] ..':** '..Text)
    if TotalMoney == 0 then
        TriggerClientEvent('brutal_policejob:client:SendNotify', source, Config.Notify[7][1], Config.Notify[7][2]..' '..Text, Config.Notify[7][3], Config.Notify[7][4])
    else
        RemoveAccountMoney(source, Paytype, TotalMoney)
        TriggerClientEvent('brutal_policejob:client:SendNotify', source, Config.Notify[7][1], Config.Notify[7][2]..' '..Text..''..Config.Notify[8][2]..' '..TotalMoney..''..Config.MoneyForm, Config.Notify[7][3], Config.Notify[7][4])
    end
end)

RegisterServerEvent('brutal_policejob:server:RemoveMoney')
AddEventHandler('brutal_policejob:server:RemoveMoney', function(Paytype, TotalMoney)
    RemoveAccountMoney(source, Paytype, TotalMoney)
end)

-----------------------------------------------------------
----------------------| duty status |----------------------
-----------------------------------------------------------

InDuty = {}

RESCB('brutal_policejob:server:getAvailableCopsCount', function(source, cb)
    local cops = 0
    for k,v in pairs(InDuty) do
        for _k,_v in pairs(v) do
            if _v then
                cops += 1
            end
        end
    end

    cb(cops)
end)

RegisterNetEvent("brutal_policejob:server:GetDutyStatus")
AddEventHandler('brutal_policejob:server:GetDutyStatus', function(source, playerJob, cb)
    if InDuty[playerJob] == nil then
        InDuty[playerJob] = {}
    end
    
    local cop = false
    for k,v in pairs(Config.PoliceStations) do
        if v.Job == playerJob then
            cop = true
        end
    end

    if cop then
        if InDuty[playerJob][source] then
            return cb(true)
        else
            return cb(false)
        end
    else
        return cb(true)
    end
end)

RegisterNetEvent("brutal_policejob:server:SetDutyStatus")
AddEventHandler("brutal_policejob:server:SetDutyStatus", function(playerjob, status, useblip)
    local src = source
    local playerJob = playerjob
    if InDuty[playerJob] == nil then
        InDuty[playerJob] = {}
    end

    InDuty[playerJob][src] = status

    if useblip then
        if OneSync == 'infinite' then
            Citizen.CreateThread(function()
                while InDuty[playerJob][src] do
                    local Table = {}
                    for k,v in pairs(InDuty[playerJob]) do
                        if v == true and k ~= src then
                            local playerPed = GetPlayerPed(k)
                            local coords = GetEntityCoords(playerPed)
                            local heading = GetEntityHeading(playerPed)
                            table.insert(Table, {
                                label = GetPlayerNameFunction(k),
                                location = {
                                    x = coords.x,
                                    y = coords.y,
                                    z = coords.z,
                                    h = heading
                                }
                            })
                        end
                    end

                    TriggerClientEvent('brutal_policejob:client:updateBlip', src, OneSync, Table)
                    Citizen.Wait(5000)
                end
            end)
        else
            for k,v in pairs(InDuty[playerJob]) do
                if InDuty[playerJob][k] then
                    TriggerClientEvent('brutal_policejob:client:updateBlip', k, OneSync, InDuty[playerJob])
                end
            end
        end
    end

    TriggerClientEvent('brutal_policejob:client:updateAvailabeCops', -1, InDuty)
end)

AddEventHandler('playerDropped', function()
    if dragging[source] then
        dragging[source] = nil
        dragged[source]  = nil
    end
    
    for k,v in pairs(InDuty) do
        for _k,_v in pairs(v) do
            if _k == source then
                InDuty[k][source] = false
            end
        end
    end

    TriggerClientEvent('brutal_policejob:client:updateAvailabeCops', -1, InDuty)
end)

-----------------------------------------------------------
---------------------| other events |----------------------
-----------------------------------------------------------

RESCB("brutal_policejob:server:GetPlayerMoney",function(source,cb)
    local wallet = {money = GetAccountMoney(source, 'money'), bank = GetAccountMoney(source, 'bank')}
    cb(wallet)
end)

RegisterNetEvent("brutal_policejob:server:policeMenuEvent")
AddEventHandler("brutal_policejob:server:policeMenuEvent", function(target, event, extraData, extraData2)
    local src = source
    local targetSource = nil
    local targetIdentifier = nil

    if type(target) == 'number' then
        targetSource = target
        targetIdentifier = GetIdentifier(target)
    else
        targetIdentifier = target
        local TargetTable = GetPlayerByIdentifier(target)
        if TargetTable ~= nil then
            if Config['Core']:upper() == 'ESX' then
                targetSource = tonumber(TargetTable.source)
            elseif Config['Core']:upper() == 'QBCORE' then
                targetSource = tonumber(TargetTable.PlayerData.source)
            end
        end
    end

    if event == 'jail' then
        if Config['Core']:upper() == 'ESX' then
            MySQL.query.await('UPDATE users SET jail_time = ?, jail_reason = ? WHERE identifier = ?',{extraData, extraData2, targetIdentifier})
        elseif Config['Core']:upper() == 'QBCORE' then
            MySQL.query.await('UPDATE players SET jail_time = ?, jail_reason = ? WHERE citizenid = ?',{extraData, extraData2, targetIdentifier})
        end

        DiscordWebhook('Jail', '**'.. Config.Webhooks.Locale['Amount'] ..':** '..extraData..'\n**'.. Config.Webhooks.Locale['Reason'] ..':** '..extraData2..'\n\n**__'.. Config.Webhooks.Locale['Receiver']..'__**\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '..targetIdentifier..'\n\n**__'.. Config.Webhooks.Locale['Assistant']..'__**\n**'.. Config.Webhooks.Locale['PlayerName']..':** '.. GetPlayerNameFunction(src)..' ['.. src ..']\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '.. GetIdentifier(src))

        if Config.Prison.ClearInventory and targetSource ~= nil then 
            ClearPlayerInventory(targetSource)
        end
    elseif event == 'unjail' then
        if Config['Core']:upper() == 'ESX' then
            MySQL.query.await('UPDATE users SET jail_time = ?, jail_reason = ? WHERE identifier = ?',{0, "", targetIdentifier})
        elseif Config['Core']:upper() == 'QBCORE' then
            MySQL.query.await('UPDATE players SET jail_time = ?, jail_reason = ? WHERE citizenid = ?',{0, "", targetIdentifier})
        end

        if GetIdentifier(src) ~= targetIdentifier then
            DiscordWebhook('Unjail', '**__'.. Config.Webhooks.Locale['Receiver']..'__**\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '..targetIdentifier..'\n\n**__'.. Config.Webhooks.Locale['Assistant']..'__**\n**'.. Config.Webhooks.Locale['PlayerName']..':** '.. GetPlayerNameFunction(src)..' ['.. src ..']\n**'.. Config.Webhooks.Locale['Identifier'] ..':** '.. GetIdentifier(src))
        end
    end

    if targetSource ~= nil then
        value1 = targetSource
        value2 = event
        value3 = extraData

        TriggerClientEvent('brutal_policejob:client:policeMenuEvent', value1, value2, value3)
    end
end)

Citizen.CreateThread(function()
    if Config.BulletProofs.Use then
        for i=1,#Config.BulletProofs.Items do
            RUI(Config.BulletProofs.Items[i].item, function(source)
                TriggerClientEvent('brutal_policejob:client:UseBulletProofItem', source, Config.BulletProofs.Items[i].job, Config.BulletProofs.Items[i].onlyjob)
                RemoveItem(source, Config.BulletProofs.Items[i].item, 1)
            end)
        end
    end
end)

RegisterNetEvent("brutal_policejob:server:ClearInventory")
AddEventHandler("brutal_policejob:server:ClearInventory", function()
    if source ~= nil then
        ClearPlayerInventory(source)
    end
end)

RUI(Config.HandCuff.HandcuffKeyItem, function(source)
    TriggerClientEvent('brutal_policejob:client:UseHandCuffKeyItem', source)
end)

RegisterNetEvent("brutal_policejob:server:Removetem")
AddEventHandler("brutal_policejob:server:Removetem", function(item)
    RemoveItem(source, item, 1)
end)

-----------------------------------------------------------
--------------------| security camera |--------------------
-----------------------------------------------------------

CamerasStatus = {}

Citizen.CreateThread(function()
    for k,v in pairs(Config.SecurityCameras.cameras) do
        CamerasStatus[#CamerasStatus+1] = true
    end
end)

if Config.SecurityCameras.hack.enable then
    RegisterNetEvent("brutal_policejob:server:SetCameraStatus")
    AddEventHandler("brutal_policejob:server:SetCameraStatus", function(CAM_ID, Status)
        CamerasStatus[CAM_ID] = Status
    end)

    RESCB("brutal_policejob:server:getSecurityCameraStatus",function(source,cb)
        cb(CamerasStatus)
    end)

    RUI(Config.SecurityCameras.hack.item, function(source)
        TriggerClientEvent('brutal_policejob:client:UseCamHackItem', source)
    end)
end

-----------------------------------------------------------
--------------------- drag animation ----------------------
-----------------------------------------------------------

dragging = {}
dragged = {}

RegisterServerEvent("brutal_policejob:server:drag:sync")
AddEventHandler("brutal_policejob:server:drag:sync", function(targetSrc)
    if targetSrc > 0 and #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetSrc))) < 20.0 then
        if Config.ReloadDeath then
            TriggerClientEvent("reload_death:stopAnim", targetSrc)
        end
        TriggerClientEvent("brutal_policejob:client:drag:syncTarget", targetSrc, source)
        dragging[source] = targetSrc
        dragged[targetSrc] = source
    end
end)

RegisterServerEvent("brutal_policejob:server:drag:stop")
AddEventHandler("brutal_policejob:server:drag:stop", function(targetSrc)
	local source = source

	if dragging[source] then
	    TriggerClientEvent("brutal_policejob:client:drag:cl_stop", targetSrc, source)

	    if Config.ReloadDeath then
	    Citizen.Wait(5100)
			TriggerClientEvent("reload_death:startAnim", targetSrc)
		end
		dragging[source] = nil
		dragged[targetSrc] = nil
	end
end)

-----------------------------------------------------------
--------------------| discord webhook |--------------------
-----------------------------------------------------------

function DiscordWebhook(TYPE, MESSAGE)
    if Config.Webhooks.Use then
        local information = {
            {
                ["color"] = Config.Webhooks.Colors[TYPE],
                ["author"] = {
                    ["icon_url"] = 'https://i.ibb.co/KV7XX6m/brutal-scripts.png',
                    ["name"] = 'Brutal Police Job - Logs',
                },
                ["title"] = '**'.. Config.Webhooks.Locale[TYPE] ..'**',
                ["description"] = MESSAGE,
                ["fields"] = {
                    {
                        ["name"] = Config.Webhooks.Locale['Time'],
                        ["value"] = os.date('%d/%m/%Y - %X')
                    }
                },
                ["footer"] = {
                    ["text"] = 'Brutal Scripts - Made by Keres & Dév',
                    ["icon_url"] = 'https://i.ibb.co/KV7XX6m/brutal-scripts.png'
                }
            }
        }
        PerformHttpRequest(GetWebhook(), function(err, text, headers) end, 'POST', json.encode({avatar_url = IconURL, username = BotName, embeds = information}), { ['Content-Type'] = 'application/json' })
    end
end