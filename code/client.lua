for _, targets in ipairs(Config.Locations) do 
    local coord = targets.coords 
    local jobs = targets.jobname
    local names = targets.uniqueName
    if Config.Target == 'qb' then 
        exports['qb-target']:AddBoxZone(names, coord, 4.0, 4.0, {
            name = names, 
        }, {
            options = {
                {
                    icon = 'fa-solid fa-house', 
                    label = 'Open Housing Records', 
                    job = jobs,
                    action = function()
                        TriggerServerEvent('pullData')
                    end
                }
            },
            distance = 2.5, 
        })
    elseif Config.Target == 'ox' then 
        exports.ox_target:addBoxZone({ 
            coords = coord,
            size = vec3(4, 4, 4),
            debug = false,
            drawSprite = true,
            options = {
                {
                    name = 'HouseRecordsMenu',
                    icon = 'fa-solid fa-house',
                    label = 'Open Housing Records',
                    groups = jobs,
                    onSelect = function()
                        TriggerServerEvent('pullData')
                    end
                }
            }
        })
    end
end

RegisterNetEvent('showMenu', function(data)
    if Config.Menu == 'qb-menu' then 
        local menuItems = {
            {
                header = 'Housing Records',
                icon = 'fa-solid fa-house',
                isMenuHeader = true, 
            }
        }
        for i = 1, #data do
            local row = data[i]
            local name = row.playername
            local id = row.houseID
            local xcoords = row.x
            local ycoords = row.y

            if xcoords and ycoords then
                local menuItem = {
                    header = 'Owner: '..name .. ' (House ID: ' .. id..')',
                    txt = 'Set Waypoint to House',
                    icon = 'fas fa-map-marker-alt',
                    params = {
                        event = 'SetWaypointToCoord',
                        args = {
                            x = xcoords,
                            y = ycoords,
                        }
                    }
                }
                table.insert(menuItems, menuItem)
            end
        end
        exports['qb-menu']:openMenu(menuItems)
    elseif Config.Menu == 'ox_lib' then 
        local contextOptions = {}

        for i = 1, #data do
            local row = data[i]
            local name = row.playername or 'Unknown'
            local id = row.id or 'N/A'
            local xcoords = row.x
            local ycoords = row.y

            debugcode(json.encode(row))
            
            if xcoords and ycoords then
                local contextItem = {
                    title = 'Owner: ' .. name .. '\n' .. ' House ID: ' .. id,
                    description = 'Set Waypoint to House',
                    icon = 'fa-solid fa-house',
                    event = 'SetWaypointToCoord',
                    arrow = true,
                    args = {
                        x = xcoords,
                        y = ycoords,
                    }
                }
                table.insert(contextOptions, contextItem)
            end
        end

        lib.registerContext({
            id = 'housingrecords',
            title = 'Housing Records',
            options = contextOptions,
        })
        lib.showContext('housingrecords')
    end
end)


RegisterNetEvent('SetWaypointToCoord', function(data)
    local x = tonumber(data.x)
    local y = tonumber(data.y)
    SetNewWaypoint(x, y)
    Notify()
end)
function Notify()
    if Config.Notifications == 'qb' then 
        local QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.Notify('House Waypoint Set, Check your GPS', 'success', 10000)
    elseif Config.Notifications == 'ox' then
        lib.notify({
            title = 'Housing Records',
            description = 'House Waypoint Set, Check your GPS',
            type = 'success',
            duration = 10000
        })
    elseif Config.Notifications == 'okok' then 
        exports['okokNotify']:Alert('Housing Records', 'House Waypoint Set, Check your GPS', 10000, 'success', true)
    end
end

local function debugcode(message)
    if Config.Debug then 
        print(message)
    end
end
