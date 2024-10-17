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
            if not info or not info.firstname or not info.lastname then
                
                debugcode('Error decoding charinfo for citizenid: ' .. tostring(id))
                goto continue
            end

            local first = info.firstname
            local last = info.lastname

            local exists = MySQL.scalar.await('SELECT 1 FROM player_houses WHERE citizenid = ?', { id })
            if exists then
                MySQL.update.await('UPDATE player_houses SET playername = ? WHERE citizenid = ?', {
                    first .. ' ' .. last, id
                })
            else
                debugcode('No matching record found in player_houses for citizenid: ' .. tostring(id))
            end

            ::continue::
        end

        local coordinates = MySQL.query.await('SELECT name, coords FROM houselocations')
        for i = 1, #coordinates do
            local var = coordinates[i]
            local houseName = var.name
            local ent = var.coords

            local data = json.decode(ent)
            if not data or not data.enter or not data.enter.x or not data.enter.y then
                debugcode('Error decoding coords for house name: ' .. tostring(houseName))
                goto continue
            end

            local xAxis = tostring(data.enter.x)
            local yAxis = tostring(data.enter.y)

            local exists = MySQL.scalar.await('SELECT 1 FROM player_houses WHERE house = ?', { houseName })
            if exists then
                MySQL.update.await('UPDATE player_houses SET x = ?, y = ? WHERE house = ?', {
                    xAxis, yAxis, houseName
                })
            else
                debugcode('No matching record found in player_houses for house name: ' .. tostring(houseName))
            end

            ::continue::
        end

    elseif Config.FrameWork == 'esx' then
        local plyInfo = MySQL.query.await('SELECT identifier, firstname, lastname FROM users')
        for i = 1, #plyInfo do
            local results = plyInfo[i]
            local id = results.identifier
            local first = results.firstname
            local last = results.lastname

            if first and last then
                local exists = MySQL.scalar.await('SELECT 1 FROM player_houses WHERE citizenid = ?', { id })
                if exists then
                    MySQL.update.await('UPDATE player_houses SET playername = ? WHERE citizenid = ?', {
                        first .. ' ' .. last, id
                    })
                else
                    debugcode('No matching record found in player_houses for identifier: ' .. tostring(id))
                end
            end
        end

        local coordinates = MySQL.query.await('SELECT name, coords FROM houselocations')
        for i = 1, #coordinates do
            local var = coordinates[i]
            local houseName = var.name
            local ent = var.coords
        
            local data = json.decode(ent)
            if not data or not data.enter or not data.enter.x or not data.enter.y then
                debugcode('Error decoding coords for house name: ' .. tostring(houseName))
                goto continue
            end
        
            local xAxis = tostring(data.enter.x)
            local yAxis = tostring(data.enter.y)
        
            local exists = MySQL.scalar.await('SELECT 1 FROM player_houses WHERE house = ?', { houseName })
            if exists then
                MySQL.update.await('UPDATE player_houses SET x = ?, y = ? WHERE house = ?', {
                    xAxis, yAxis, houseName
                })
            else
                debugcode('No matching record found in player_houses for house name: ' .. tostring(houseName))
            end
        
            ::continue::
        end
    end
end

RegisterNetEvent('pullData', function()
    local src = source
    if not src then return end

    local framework = Config.FrameWork
    local Player

    if framework == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        Player = QBCore.Functions.GetPlayer(src)
    elseif framework == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        Player = ESX.GetPlayerFromId(src)
    end

    if not Player then
        debugcode('Player not found for source: ' .. tostring(src))
        return
    end

    local data = MySQL.query.await('SELECT id, playername, x, y from player_houses WHERE menu = ?', { 'true' })
    if not data or #data == 0 then
        debugcode('Database query failed or no data found.')
        return
    end

    TriggerClientEvent('showMenu', src, data)
end)

local function debugcode(message)
    if Config.Debug then 
        print(message)
    end
end
