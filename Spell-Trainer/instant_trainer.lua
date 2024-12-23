--|  Script made by JadaDev  |--
--[	    Instant Trainer	     ]--
--[	   TrinityCore 3.3.5     ]--

-- Configurations
local CONFIG = {
    NPC_ID = 70003,                   -- NPC ID of the trainer
    IGNORE_LEVEL_REQUIREMENT = false, -- Ignore level requirement? (true/false)
    IGNORE_PRICE = false,             -- Ignore price for spells? (true/false)
    CUSTOM_PRICE_MULTIPLIER = 1.0,    -- Multiplier for the spell price (ignored if IGNORE_PRICE = true)
    CLASS_TO_TRAINER = {			  -- DO NOT CHANGE UNLESS YOU KNOW WHAT YOU'RE DOING
        [1] = 1, -- Warrior
        [2] = 5, -- Paladin
        [3] = 7, -- Hunter
        [4] = 9, -- Rogue
        [5] = 11, -- Priest
        [6] = 13, -- Death Knight
        [7] = 14, -- Shaman
        [8] = 16, -- Mage
        [9] = 31, -- Warlock
        [11] = 33 -- Druid
    },
    MESSAGE_NO_TRAINER = "|cffff0000Your class doesn't have any available spells.",
    MESSAGE_NO_SPELLS = "|cffff8000You have no missing spells to learn.",
    MESSAGE_NOT_ENOUGH_MONEY = "|cffff0000You don't have enough money to learn all missing spells!",
    MESSAGE_LEARNED_SPELLS = "|cff00ff00You have learned all spells that are available for you!"
}

local function GetDependentSpells(spellId, trainerId)
    local query = string.format(
        "SELECT spellid, moneycost, reqlevel, reqability1, reqability2 FROM trainer_spell WHERE trainerid = %d AND (reqability1 = %d OR reqability2 = %d)",
        trainerId, spellId, spellId
    )
    return WorldDBQuery(query)
end

function Trainer_OnGossipHello(event, player, creature)
    local playerClass = player:GetClass()
    local trainerId = CONFIG.CLASS_TO_TRAINER[playerClass]

    if not trainerId then
        player:SendBroadcastMessage(CONFIG.MESSAGE_NO_TRAINER)
        player:GossipComplete()
        return
    end

    local query = string.format(
        "SELECT spellid, moneycost, reqlevel, reqability1, reqability2 FROM trainer_spell WHERE trainerid = %d",
        trainerId
    )
    local result = WorldDBQuery(query)
    local missingSpells = {}
    local totalCost = 0

    if result then
        local knownSpells = {}
        repeat
            local spellId = result:GetUInt32(0)
            local moneyCost = result:GetUInt32(1)
            local reqLevel = result:GetUInt32(2)
            local reqAbility1 = result:GetUInt32(3)
            local reqAbility2 = result:GetUInt32(4)

            if (CONFIG.IGNORE_LEVEL_REQUIREMENT or player:GetLevel() >= reqLevel) and
                (reqAbility1 == 0 or player:HasSpell(reqAbility1)) and
                (reqAbility2 == 0 or player:HasSpell(reqAbility2)) and
                not player:HasSpell(spellId) then
                if not CONFIG.IGNORE_PRICE then
                    moneyCost = math.floor(moneyCost * CONFIG.CUSTOM_PRICE_MULTIPLIER)
                else
                    moneyCost = 0
                end
                missingSpells[spellId] = { spellId = spellId, cost = moneyCost, reqLevel = reqLevel }
                totalCost = totalCost + moneyCost
                knownSpells[spellId] = true
            end
        until not result:NextRow()

        local addedNewSpells = true
        while addedNewSpells do
            addedNewSpells = false
            for spellId, spellData in pairs(missingSpells) do
                local dependentResult = GetDependentSpells(spellId, trainerId)
                if dependentResult then
                    repeat
                        local depSpellId = dependentResult:GetUInt32(0)
                        local depCost = dependentResult:GetUInt32(1)
                        local depReqLevel = dependentResult:GetUInt32(2)
                        local depReqAbility1 = dependentResult:GetUInt32(3)
                        local depReqAbility2 = dependentResult:GetUInt32(4)

                        if (CONFIG.IGNORE_LEVEL_REQUIREMENT or player:GetLevel() >= depReqLevel) and
                            (depReqAbility1 == 0 or knownSpells[depReqAbility1] or player:HasSpell(depReqAbility1)) and
                            (depReqAbility2 == 0 or knownSpells[depReqAbility2] or player:HasSpell(depReqAbility2)) and
                            not player:HasSpell(depSpellId) and
                            not missingSpells[depSpellId] then
                            if not CONFIG.IGNORE_PRICE then
                                depCost = math.floor(depCost * CONFIG.CUSTOM_PRICE_MULTIPLIER)
                            else
                                depCost = 0
                            end
                            missingSpells[depSpellId] = { spellId = depSpellId, cost = depCost, reqLevel = depReqLevel }
                            totalCost = totalCost + depCost
                            knownSpells[depSpellId] = true
                            addedNewSpells = true
                        end
                    until not dependentResult:NextRow()
                end
            end
        end
    end

    if next(missingSpells) then
        local gold = math.floor(totalCost / 10000)
        local silver = math.floor((totalCost % 10000) / 100)
        local copper = totalCost % 100

        player:GossipMenuAddItem(
            0,
            string.format("|cff0080ffLearn all missing spells for |cffff0000%dg %ds %dc.", gold, silver, copper),
            0,
            1
        )
        player:GossipSendMenu(1, creature)
        creature:SetData("MissingSpells", missingSpells)
    else
        player:SendBroadcastMessage(CONFIG.MESSAGE_NO_SPELLS)
        player:GossipComplete()
    end
end

function Trainer_OnGossipSelect(event, player, creature, sender, intid, code)
    if intid == 1 then
        local missingSpells = creature:GetData("MissingSpells")
        local totalCost = 0

        if missingSpells then
            for _, spellData in pairs(missingSpells) do
                totalCost = totalCost + spellData.cost
            end

            if CONFIG.IGNORE_PRICE or player:GetCoinage() >= totalCost then
                for _, spellData in pairs(missingSpells) do
                    if not player:HasSpell(spellData.spellId) then
                        player:LearnSpell(spellData.spellId)
                    end
                end
                if not CONFIG.IGNORE_PRICE then
                    player:ModifyMoney(-totalCost)
                end
                player:SendBroadcastMessage(CONFIG.MESSAGE_LEARNED_SPELLS)
            else
                player:SendBroadcastMessage(CONFIG.MESSAGE_NOT_ENOUGH_MONEY)
            end
        else
            player:SendBroadcastMessage(CONFIG.MESSAGE_NO_SPELLS)
        end

        creature:SetData("MissingSpells", nil)
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(CONFIG.NPC_ID, 1, Trainer_OnGossipHello)
RegisterCreatureGossipEvent(CONFIG.NPC_ID, 2, Trainer_OnGossipSelect)
