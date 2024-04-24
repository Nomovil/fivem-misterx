function disp_time(time)
    local days = math.floor(time/86400)
    local remaining = time % 86400
    local hours = math.floor(remaining/3600)
    remaining = remaining % 3600
    local minutes = math.floor(remaining/60)
    remaining = remaining % 60
    local seconds = remaining
    if (hours < 10) then
      hours = "0" .. tostring(hours)
    end
    if (minutes < 10) then
      minutes = "0" .. tostring(minutes)
    end
    if (seconds < 10) then
      seconds = "0" .. tostring(seconds)
    end
    answer = tostring(hours)..'h:'..minutes..'m:'..seconds..'s'
    return answer
end

function checkPlayerIsInVehicle()
    local ped = GetPlayerPed(-1)
    return GetVehiclePedIsIn(ped,false) > 0
end


function startCountdown(time_to_count_down)
    time = GetGameTimer() + time_to_count_down*1000
end

function getremainingTime()
    return math.floor((time-GetGameTimer())/1000)
end

function setCountdownTime(time_to_count_down)
    return GetGameTimer() + time_to_count_down*1000
end

function getRemainingCountdownTime(finishtime)
   return math.floor((finishtime - GetGameTimer())/1000) 
end

function MonitorMisterXState()
    Citizen.CreateThread(function()
        -- while( checkPlayerIsInVehicle()) do
        --     Wait(100)
        -- end
        startTime = GetGameTimer()
        showTimer = true
        while (showTimer and checkPlayerIsInVehicle()) do
            seconds = math.ceil((GetGameTimer()-startTime)/1000)
            seconds_text = disp_time(seconds)
            drawTxt(seconds_text, 4,{255,255,255},0.7,0.85,0.01)
            Citizen.Wait(0)
        end
        local message = ("MisterX escaped for: %s"):format(seconds_text)
        -- printToPlayer(mesage)
        TriggerServerEvent("PING:deliverMessage",message)


        TriggerServerEvent("PING:ThiefLost")
    end)
end

function createSoppwatchThread()
    Citizen.CreateThread(function()
        startTime = GetGameTimer()
        showTimer = true
        while (showTimer) do
            seconds = math.ceil((GetGameTimer()-startTime)/1000)
            seconds_text = disp_time(seconds)
            drawTxt(seconds_text, 4,{255,255,255},0.7,0.85,0.01)
            Citizen.Wait(0)
        end
        -- local message = ("MisterX escaped for: %s"):format(seconds_text)
        -- -- printToPlayer(mesage)
        -- TriggerServerEvent("PING:deliverMessage",message)
    end)
end