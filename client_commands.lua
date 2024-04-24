role = "Civi"
showTimer = true
addBlipsAllowed = true
showRole = false
showHides = false

RegisterCommand("cop",function(source)
    if role == "Civi" then
        role = "Cop"
        addBlipsAllowed = true
        TriggerServerEvent("PING:registerCop_server")
        showRole = true
        showRoleTxt()
        -- printToPlayer("Registered as Cop")
    else
        printToPlayer("Can't be a Cop if you are a Thief")
    end
end,false)

RegisterCommand("misterx",function(source)
    if role == "Civi" then
        role = "Thief"
        TriggerServerEvent("PING:registerThief_server")
        showRole = true
        showRoleTxt()
        -- printToPlayer("You are now Mister X")
    else
        printToPlayer("Can't be Mister X if you are a Cop")
    end
end,false)

RegisterCommand("normal",function(source)
    TriggerServerEvent("PING:registerCivilian_server",role)
    role = "Civi"
    addBlipsAllowed = false
    showRole = false
    for index,blip in ipairs(blips) do
        RemoveBlip(blip)
    end
    for index,blip in ipairs(copblips) do
        RemoveBlip(blip)
    end
end,false)

RegisterCommand("newPingTime",function(source,args)
    if #args >= 1 then
        TriggerServerEvent("PING:Update_Pingtime",args[1])
        local message = ("Updated Ping Time to  %ss"):format(args[1])
        TriggerServerEvent("PING:deliverMessage",message)
    end
end,false)

RegisterCommand("newStartTime",function(source,args)
    if #args >= 1 then
        TriggerServerEvent("PING:Update_startTime",args[1])
        local message = ("Updated Start Time to  %ss"):format(args[1])
        TriggerServerEvent("PING:deliverMessage",message)
    end
end,false)

-- RegisterCommand("number_of_hides",function(source,args)
--     if #args >= 1 then
--         TriggerServerEvent("PING:Update_NumberOfHides",args[1])
--         local message = ("Updated Number of hides to  %ss"):format(args[1])
--         TriggerServerEvent("PING:deliverMessage",message)
--     end
-- end,false)

RegisterCommand("startChase",function(source)
    TriggerServerEvent("PING:startChase")
end,false)

RegisterCommand("endChase",function(source)
    -- showTimer = false
    TriggerServerEvent("PING:deliverMessage","Stopped Chase Manually")
    TriggerServerEvent("PING:ThiefLost")
end,false)
