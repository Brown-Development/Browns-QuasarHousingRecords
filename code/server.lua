AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        updateData()
    end
end)
function updateData()
    if Config.FrameWork == 'qb' then
        local plyInfo = MySQL.query.await('SELECT charinfo, citizenid FROM players')
        for i = 1, #plyInfo do 
            local results = plyInfo[i]
            local id = results.citizenid
            local characterInfo = results.charinfo
            local info = json.decode(characterInfo)
            local first = info.firstname
            local last = info.lastname 
            MySQL.update.await('UPDATE player_houses SET playername = ? WHERE citizenid = ?', {
                first .. ' ' .. last, id
            })
        end
        local coordinates = MySQL.query.await('SELECT houseID, coords FROM houselocations')
        for i = 1, #coordinates do 
            local var = coordinates[i]
            local houseIdent = var.houseID
            local ent = var.coords
            local data = json.decode(ent)
            local xAxis = json.decode(data.enter.x)
            local yAxis = json.decode(data.enter.y)
            print(xAxis)
            MySQL.update.await('UPDATE player_houses SET x = ? WHERE houseID = ?', {
                xAxis, houseIdent
            })
            MySQL.update.await('UPDATE player_houses SET y = ? WHERE houseID = ?', {
                yAxis, houseIdent
            })
        end
    elseif Config.FrameWork == 'esx' then

        local plyInfo = MySQL.query.await('SELECT identifier, firstname, lastname FROM users')
        for i = 1, #plyInfo do 
            local results = plyInfo[i]
            local id = results.identifier
            local first = results.firstname
            local last = results.lastname
            if first and last then
                MySQL.update.await('UPDATE player_houses SET playername = ? WHERE citizenid = ?', {
                    first .. ' ' .. last, id
                })
            end
        end
        local coordinates = MySQL.query.await('SELECT houseID, coords FROM houselocations')
        for i = 1, #coordinates do 
            local var = coordinates[i]
            local houseIdent = var.houseID
            local ent = var.coords
            local data = json.decode(ent)
            local xAxis = json.decode(data.enter.x)
            local yAxis = json.decode(data.enter.y)
            print(xAxis)
            MySQL.update.await('UPDATE player_houses SET x = ? WHERE houseID = ?', {
                xAxis, houseIdent
            })
            MySQL.update.await('UPDATE player_houses SET y = ? WHERE houseID = ?', {
                yAxis, houseIdent
            })
        end
    end
end

RegisterNetEvent('pullData', function()
    if Config.FrameWork == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local src = source 
        local Player = QBCore.Functions.GetPlayer(src)
        local data = MySQL.query.await('SELECT houseID, playername, x, y from player_houses WHERE menu = ?', {
            'true'
        })
        TriggerClientEvent('showMenu', src, data)
    elseif Config.FrameWork == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        local src = source 
        local Player = ESX.GetPlayerFromId(src)
        local data = MySQL.query.await('SELECT houseID, playername, x, y from player_houses WHERE menu = ?', {
            'true'
        })
        TriggerClientEvent('showMenu', src, data)
    end
end)
