


AddEventHandler("onResourceStart",function(resouceName)
    if(GetCurrentResourceName() ~= resouceName)then
        return
    end

    print(resouceName," sarted")
    onLoad()
end)

function onLoad()
    Citizen.CreateThread(function()    
        while keepTimeThreadRunning do
            local remainingseconds
            for remainingseconds=updateTime, 1, -1 do
                TriggerClientEvent("PING:SetTime",-1,remainingseconds)
                Citizen.Wait(1000)
            end
            workatqueue()
            updateCoordsofThiefs()
        end
    end) 
end


Citizen.CreateThread(function()
    while true do
        for _,cop in ipairs(cops) do
            local coords = ShowCoordinates(cop)
            for _,cop2 in ipairs(cops) do
                TriggerClientEvent("PING:SetCoordsforCop",cop2,coords,cop)
                
            end
        end
        Citizen.Wait(10)
    end
end)

function ShowCoordinates(source)
    local player = source
    local ped = GetPlayerPed(player)
    local playerCoords = GetEntityCoords(ped)

    return(playerCoords) -- vector3(...)
end

function updateCoordsofThiefs()
    for _,thief in ipairs(thiefs) do
        local coords = ShowCoordinates(thief.source)
        for _,cop in ipairs(cops) do
            if thief.hidden then
                TriggerClientEvent("PING:HidePlayer",cop,coords,thief.source)
            else
                TriggerClientEvent("PING:SetCoordsforPlayer",cop,coords,thief.source)
            end
        end
    end
end

function workatqueue()
    if not queue:isEmpty() then
        local set = queue:dequeue()
        changeHiddenStateOfthief(set.source, set.state)
    end
end

function changeHiddenStateOfthief(source, newstate)
    for index,thief in ipairs(thiefs) do
        if thief.source == source then
            thief.hidden = newstate
            thiefs[index] = thief
        end
    end
end

function utils_Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

-- RegisterCommand("users",function()
--     print("cops:")
--     for _,cop in ipairs(cops) do
--         print(" - ",cop)
--     end
--     print("Thiefs:")
--     for _, t in ipairs(thiefs) do
--         print(" - ",t)
--     end
--     print("hidden:")
--     for _,h in ipairs(hiddenThiefs) do
--         print(" - ",h)
--     end
-- end
-- )

-- RegisterCommand("removeUserfrom",function(oldrole,id)
--     if oldrole == "Thief" then
--         table.remove(thiefs,id)
--     end
--     if oldrole == "Cop" then
--         table.remove(cops,id)
--     end
--     if oldrole == "Hidden" then
--         table.remove(hiddenThiefs,id)
--     end
    
-- end)