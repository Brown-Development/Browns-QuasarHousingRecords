Config = {}

Config.FrameWork = 'esx' -- 'qb' or 'esx'
Config.Menu = 'ox_lib' -- 'qb-menu' or 'ox_lib'
Config.Notifications = 'ox' -- 'qb', 'ox', or 'okok'
Config.Target = 'ox' -- 'qb' or 'ox'

-- Targetable Locations to open the Housing Records Menu (locked to specified jobs)
Config.Locations = { 
    {coords = vector3(441.21, -978.95, 30.69), jobname = 'police', uniqueName = 'policerecords'},
    {coords = vector3(-126.57, -641.72, 168.64), jobname = 'rea', uniqueName = 'realestaterecords'},
    -- {coords = vector3(0, 0, 0), jobname = 'sheriff', uniqueName = 'sheriffrecords'},
    -- add as many as you want
}

Config.Debug = false
