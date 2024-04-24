-- Events from Server to Client

RegisterNetEvent("PING:SetTime")
AddEventHandler("PING:SetTime",function(newtime)
    remainingseconds = newtime
end)

RegisterNetEvent("PING:StartDisplayingTime")
AddEventHandler("PING:StartDisplayingTime",function()
    keepTimeThreadRunning = true
    Citizen.CreateThread(function()
        while keepTimeThreadRunning do
            showPingTime()
            Wait(0)
        end
    end)
end)

RegisterNetEvent("PING:StopDisplayingTime")
AddEventHandler("PING:StopDisplayingTime", function()
    keepTimeThreadRunning = false
end)


RegisterNetEvent("PING:StartDisplayingVisibility")
AddEventHandler("PING:StartDisplayingVisibility",function()
    if (role == "Thief") then
        keeptVisibilityThreadRunning = true
        Citizen.CreateThread(function()
            while keeptVisibilityThreadRunning do
                showVisibilityState()
                Wait(0)
            end
        end)
    end
end)

RegisterNetEvent("PING:StopDisplayingVisibility")
AddEventHandler("PING:StopDisplayingVisibility",function()
    keeptVisibilityThreadRunning = false
end)

RegisterNetEvent("PING:SetCoordsforPlayer")
AddEventHandler("PING:SetCoordsforPlayer",function(coords,playerid)
    RemoveBlip(blips[playerid])
    local x,y,z = table.unpack(coords)
    local new_blip = AddBlipForCoord(x,y,z)
    SetBlipColour(new_blip, 1)
    SetBlipCategory(new_blip, 0)
    SetBlipScale(new_blip, 0.85)
    blips[playerid] = new_blip
end)


RegisterNetEvent("PING:SetCoordsforCop")
AddEventHandler("PING:SetCoordsforCop",function(coords,playerid)
    RemoveBlip(copblips[playerid])
    if not addBlipsAllowed then
        return
    end
    local x,y,z = table.unpack(coords)
    local new_blip = AddBlipForCoord(x,y,z)
    SetBlipColour(new_blip, 3)
    SetBlipCategory(new_blip, 0)
    SetBlipScale(new_blip, 0.85)
    copblips[playerid] = new_blip
end)

RegisterNetEvent("PING:RemovePlayerBlip", function(playerid)
    RemoveBlip(copblips[playerid])
    RemoveBlip(blips[playerid])
end)

RegisterNetEvent("PING:HidePlayer")
AddEventHandler("PING:HidePlayer",function(coords,player)
    RemoveBlip(blips[player])

    local x,y,z = table.unpack(coords)
    local radius = HideMarkerRadius
    math.randomseed(GetGameTimer())
    x_add = math.random(0-radius, 0+radius)
    y_add = math.random(0-radius, 0+radius)
    x = x + x_add
    y = y + y_add
    local new_blip = AddBlipForRadius(x,y,z,radius+10)
    SetBlipColour(new_blip, 1)
    SetBlipAlpha(new_blip, 128)
    blips[player] = new_blip
end)

RegisterNetEvent("PING:chatMessage")
AddEventHandler("PING:chatMessage",function(message)
    printToPlayer(message)
end)

RegisterNetEvent("PING:startChase_cl")
AddEventHandler("PING:startChase_cl",function(source)
    createSoppwatchThread()
    if role == "Civi" then
        return
    end
    if role == "Thief" then
        number_of_hides = MAX_NUMBER_HIDES
        MonitorMisterXState()
        showNumberofHides()
        finishtime = setCountdownTime(2)
        while getRemainingCountdownTime(finishtime) > 0 do
            Citizen.Wait(1) 
            DrawHudText("START", StartMessageColor,StartMessageLocationX,StartMessageLocationY,4.0,4.0)
        end
        return
    end
    startCountdown(COUNTDOWNTIME)
    while getremainingTime() > 0 do
        Citizen.Wait(1)
        DrawHudText(getremainingTime(), StartCounterColor,StartCounterLocationX,StartCounterLocationY,4.0,4.0)
            
        -- Disable acceleration/reverse until race starts
        DisableControlAction(2, 71, true)
        DisableControlAction(2, 72, true)
    end
    EnableControlAction(2, 71, true)
    EnableControlAction(2, 72, true)
end)


RegisterNetEvent("PING:slowDown",function()
    Slowdown()
end)

RegisterNetEvent("PING:Update_startTime_cl",function(newtime)
    COUNTDOWNTIME = newtime
end)
-- RegisterNetEvent("PING:Update_NumberOfHides_cl",function(newMaxHides)
--     print(number_of_hides)
--     if role == "Thief" then
--         number_of_hides = tonumber(newMaxHides)
--         print("Asdf")
--         print(number_of_hides)
--     end
-- end)

RegisterNetEvent("PING:ThiefLost_cl", function()
    showTimer = false
    showHides = false
end)

-- variables
remainingseconds  = -1
keepTimeThreadRunning = true
keeptVisibilityThreadRunning = true
blips = {}
copblips = {}
number_of_speedboosts = 0
showTimer = false
number_of_hides = MAX_NUMBER_HIDES

Citizen.CreateThread(function()
    number_of_hides = MAX_NUMBER_HIDES
    hidden = false
    while true do
        Citizen.Wait(1)
        if role == "Thief" and number_of_hides > 0 then
            if IsControlJustPressed(0,73) then
                TriggerServerEvent("PING:UpdateOFF_sv")
                hidden = true
            end
            if IsControlJustReleased(0,73) then
                TriggerServerEvent("PING:UpdateON_sv")
                hidden = false
                number_of_hides = number_of_hides - 1 
            end
            if hidden then
                DisableControlAction(2, 71, true)
                DisableControlAction(2, 72, true)
            else
                EnableControlAction(2, 71, true)
                EnableControlAction(2, 72, true)
            end
        end
    end
end)

