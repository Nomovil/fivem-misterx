function showPingTime()
    local text = ("%ds"):format(math.ceil(remainingseconds))
    drawTxt(text, fontNumber, locationColorText, scaleFactor, screenPosX,screenPosY)
end

function showVisibilityState()
    if playerIsVisible then
        drawTxt("Visibile",fontNumber,{255,0,0},0.4,screenPosX+0.02,screenPosY)
    else
        drawTxt("Hidden",fontNumber,{0,255,0},0.4,screenPosX+0.02,screenPosY)
    end
end

function DrawHudText(text,colour,coordsx,coordsy,scalex,scaley)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scalex, scaley)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(0, 0, 0, 0, coloura)
    SetTextEdge(1, 0, 0, 0, coloura)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(coordsx,coordsy)
end


function helpMessage(text, duration)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, duration or 5000)
end

function drawTxt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function printToPlayer(msg)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"[Ping]", msg}
        }
    )
end

function notifyPlayer(source,msg)
    TriggerClientEvent('chatMessage', source, "[Ping]", {255, 0, 0}, msg)
end



function showRoleTxt()
    
    Citizen.CreateThread(function()
        while (showRole) do
            if role == "Thief" then
                drawTxt(MisterXRoleName, fontNumber,MisterXColor,RoleNameScale,RoleNameLocationX,RoleNameLocationY)
            else
                drawTxt(CopRoleName, fontNumber,CopColor,RoleNameScale,RoleNameLocationX,RoleNameLocationY)
            end
            Citizen.Wait(0)
        end
    end)
end

function showNumberofHides()
    showHides = true
    Citizen.CreateThread(function()
        while (showHides) do
            local message = ("Hides Left: %s"):format(number_of_hides)
            drawTxt(message, fontNumber,HideCounterColor,HideCounterScale,HideCounterLocationX,HideCounterLocationY)
            Citizen.Wait(0)
        end
    end)
end