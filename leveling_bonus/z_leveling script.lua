--Script made by JADADEV - JADA#2723

local function GiveLevelingBonus(event, player, oldLevel)
    local PLevel = player:GetLevel()
    local query = WorldDBQuery("SELECT item, count, money FROM z_leveling_bonus WHERE level = " .. PLevel)
    if query then
        local itemString = query:GetString(0)
        local itemCountString = query:GetString(1)
        local moneyCount = query:GetUInt32(2)
        
        local itemIDs = {}
        for id in itemString:gmatch("%d+") do
            table.insert(itemIDs, tonumber(id))
        end
        
        local itemCounts = {}
        for count in itemCountString:gmatch("%d+") do
            table.insert(itemCounts, tonumber(count))
        end
        
        for i, itemID in ipairs(itemIDs) do
            local itemCount = itemCounts[i] or 1
            player:AddItem(itemID, itemCount)
            player:SendBroadcastMessage("|cffffff00You have received |cff00ff00" .. itemCount .. " x |cffff0000" .. GetItemLink(itemID) .. " for reaching |cff00ff00level " .. PLevel)
        end
        
        if moneyCount then
            player:ModifyMoney(moneyCount)
            local gold = math.floor(moneyCount / 10000)
            local silver = math.floor((moneyCount - (gold * 10000)) / 100)
            local copperRemainder = moneyCount - (gold * 10000) - (silver * 100)
            local result = ""
            if gold > 0 then
              result = result .. gold .. " |cffffff00gold |cffffff00"
            end
            if silver > 0 then
              result = result .. silver .. " |cff9d9d9dsilver |cffffff00"
            end
            result = result .. copperRemainder .. " |cffec7062copper"
            player:SendBroadcastMessage("|cffffff00You have received " .. result .. " |cffffff00for reaching |cff00ff00level " .. PLevel)
        end
    end
end

RegisterPlayerEvent(13, GiveLevelingBonus)
