updateTime = 10
keepTimeThreadRunning = true
cops = {}
thiefs = {}
hiddenThiefs = {}
Queue = {}
function Queue:new()
    local object = {}
    
    object.list = {}
    object.offset = 1
    
    self.__index = self
    return setmetatable(object, self)
end
queue = Queue:new()
changeHiddenStateNextPing = false

RegisterNetEvent("PING:startChase")
AddEventHandler("PING:startChase",function()
    -- startingChase()
    TriggerClientEvent("PING:startChase_cl",-1)
end)

RegisterNetEvent("PING:registerCop_server")
AddEventHandler("PING:registerCop_server",function()
    local added_cop = false
    if #cops > 0 then
        for _,thief in pairs(cops) do
            if thief == source then

            else
                added_cop = true
            end
        end
    else
        added_cop = true
    end
    if added_cop then
        table.insert(cops,source)
        TriggerClientEvent("PING:StartDisplayingTime",source)
    end
end)

RegisterNetEvent("PING:registerThief_server")
AddEventHandler("PING:registerThief_server",function()
    local added_cop = false
    if #thiefs > 0 then
        for _,thief in pairs(thiefs) do
            if thief == source then

            else
                added_cop = true
            end
        end
    else
        added_cop = true
    end
    if added_cop then
        local thiefprop = {
            source = source,
            hdden = false
        }
        table.insert(thiefs,thiefprop)
        TriggerClientEvent("PING:StartDisplayingTime",source)
        -- TriggerClientEvent("PING:StartDisplayingVisibility",source)
    end
end)

RegisterNetEvent("PING:registerCivilian_server")
AddEventHandler("PING:registerCivilian_server",function(oldrole)
    if oldrole == "Thief" then
        for index,thief in ipairs(thiefs) do
            if thief.source == source then
                table.remove(thiefs,index)
            end
        end
    end
    if oldrole == "Cop" then
        for index, cop  in ipairs(cops) do
            if cop == source then
                table.remove(cops,index)
            end
        end
        -- table.remove(cops,source)
    end
    TriggerClientEvent("PING:RemovePlayerBlip",-1,source)
    TriggerClientEvent("PING:StopDisplayingTime",source)
    -- TriggerClientEvent("PING:StopDisplayingVisibility",source)
end)

RegisterNetEvent("PING:Update_Pingtime")
AddEventHandler("PING:Update_Pingtime",function(newtime)
    updateTime = newtime
end)
RegisterNetEvent("PING:Update_startTime",function(newtime)
    TriggerClientEvent("PING:Update_startTime_cl",-1,newtime)
end)

-- RegisterNetEvent("PING:Update_NumberOfHides",function(newMaxHides)
--     TriggerClientEvent("PING:Update_NumberOfHides_cl",-1,newMaxHides)
-- end)

RegisterNetEvent("PING:UpdateOFF_sv")
AddEventHandler("PING:UpdateOFF_sv",function()
    changeHiddenStateNextPing = true
    local set = {source = source, state = true}
    queue:enqueue(set)
    -- for index,thief in ipairs(thiefs) do
    --     if thief.source == source then
    --         thief.hidden = true
    --         thiefs[index] = thief
    --     end
    -- end
end)

RegisterNetEvent("PING:UpdateON_sv")
AddEventHandler("PING:UpdateON_sv",function()
    changeHiddenStateNextPing = true
    local set = {source = source, state = false}
    queue:enqueue(set)
end)


RegisterNetEvent("PING:deliverMessage")
AddEventHandler("PING:deliverMessage",function(message)
    TriggerClientEvent("PING:chatMessage",-1,message)
end)


RegisterNetEvent("PING:ThiefLost", function()
    TriggerClientEvent("PING:ThiefLost_cl",-1)
end)


-- Defining Queue


function Queue:length()
    return #self.list - self.offset
end

function Queue:isEmpty()
    return #self.list == 0
end

function Queue:enqueue(item)
    table.insert(self.list, item)
    return self
end

function Queue:print()
    local str = 'Peek --> '
    for i = 1, #self.list do
        str = i == #self.list and str..tostring(self.list[i]) or str..tostring(self.list[i])..', ' 
    end
    print(str)
end

function Queue:copy()
    if not self:isEmpty() then
        local newQueue = self:new()

        for i = 1, #self.list do
            table.insert(newQueue.list, self.list[i])
        end

    return newQueue
    end
end

function Queue:peek()
    if not self:isEmpty() then
        return self.list[self.offset]
    end
    return nil
end

function Queue:dequeue()
    if self:isEmpty() then return nil end
    
    local item = self.list[self.offset]
    self.offset = self.offset + 1
    if (self.offset * 2) >= #self.list then
        self:optimize()
    end
    return item
end

function Queue:optimize()
    local pos, new = 1, {}
    for i = self.offset, #self.list do
        new[pos] = self.list[i]
        pos = pos + 1
    end
    self.offset = 1
    self.list = new
end