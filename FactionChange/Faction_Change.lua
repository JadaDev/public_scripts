-- Made by JadaDev
-- DO NOT REMOVE CREDITS

local TokenID = 55555 -- Change This to the Item_Entry ID
local CreatureEntry = 77777 -- Change this to the Creature_Entry ID

function OnGossipHello(event, player, object)
    player:GossipMenuAddItem(0, "|TInterface\\icons\\Ability_DualWieldSpecialization:30:30|tCustomize Your Character", 0, 1)
    player:GossipMenuAddItem(0, "|TInterface\\icons\\Spell_Shadow_SacrificialShield:30:30|tRename Your Character", 0, 2)
    player:GossipMenuAddItem(0, "|TInterface\\icons\\Ability_Racial_ShadowMeld:30:30|tSwitch Your Race", 0, 3)
    player:GossipMenuAddItem(0, "|TInterface\\icons\\Achievement_BG_winWSG:30:30|tSwitch Your Faction", 0, 4)
    player:GossipMenuAddItem(0, "|TInterface\\icons\\INV_Misc_QuestionMark:30:30|tNevermind", 0, 5)
    player:GossipSendMenu(1, object)
end

function OnGossipSelect(event, player, object, sender, intid, code)
    if (intid == 1) then
        local TokenName = GetItemLink(TokenID):match("|h%[(.+)]|h")
        if (player:HasItem(TokenID) == true) then
            player:RemoveItem(TokenID, 1)
            player:SetAtLoginFlag(8)
            player:SendBroadcastMessage(TokenName .. " |cffff0000is removed, |cff00ff00relog and customize your character.")
        else
            player:SendBroadcastMessage(TokenName .. " |cffff0000is required to customize your character.")
        end
    elseif (intid == 2) then
        local TokenName = GetItemLink(TokenID):match("|h%[(.+)]|h")
        if (player:HasItem(TokenID) == true) then
            player:RemoveItem(TokenID, 1)
            player:SetAtLoginFlag(1)
            player:SendBroadcastMessage(TokenName .. " |cffff0000is removed, |cff00ff00relog and change your character name.")
        else
            player:SendBroadcastMessage(TokenName .. " |cffff0000is required to change your name.")
        end
    elseif (intid == 3) then
        local TokenName = GetItemLink(TokenID):match("|h%[(.+)]|h")
        if (player:HasItem(TokenID) == true) then
            player:RemoveItem(TokenID, 1)
            player:SetAtLoginFlag(128)
            player:SendBroadcastMessage("You will be able to switch your race on your next login.")
        else
            player:SendBroadcastMessage(TokenName .. " |cffff0000is required to change your name.")
        end
    elseif (intid == 4) then
        local TokenName = GetItemLink(TokenID):match("|h%[(.+)]|h")
        if (player:HasItem(TokenID) == true) then
            player:RemoveItem(TokenID, 1)
            player:SetAtLoginFlag(64)
            player:SendBroadcastMessage("You will be switched to the opposite faction on your next login.")
        else
            player:SendBroadcastMessage(TokenName .. " |cffff0000is required to change your name.")
        end
    elseif (intid == 5) then
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(CreatureEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(CreatureEntry, 2, OnGossipSelect)
