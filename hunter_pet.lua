-- Hunter Pet Helper by JadaDev
-- This script gives happiness to your PET and also resets it's talent!

local NPC_ID = XXXXXX

function IsHunter(player)
    return player:GetClass() == 3
end

function OnGossipHello(event, player, unit)
    if IsHunter(player) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "|TInterface\\icons\\Ability_Druid_HealingInstincts:30:30|tIncrease Pet Happiness", 0, 1)
        player:GossipMenuAddItem(0, "|TInterface\\icons\\Ability_Hunter_BeastSoothe:30:30|tRevive Pet", 0, 5)
        player:GossipMenuAddItem(0, "|TInterface\\icons\\Ability_Hunter_BeastTaming:30:30|tReset Pet Talents", 0, 2)
        player:GossipMenuAddItem(0, "|TInterface\\icons\\Ability_Hunter_MarkedForDeath:30:30|tNevermind", 0, 4)
        player:GossipSendMenu(1, unit)
    else
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "|TInterface\\icons\\Ability_Hunter_MarkedForDeath:30:30|tYou're not a Hunter", 0, 3)
        player:GossipSendMenu(1, unit)
    end
end

function OnGossipSelect(event, player, unit, sender, action)
    if action == 1 then
        player:CastSpell(player, 46649, true)
        player:SendBroadcastMessage("Your pet's happiness has increased!")
        player:GossipComplete()
    elseif action == 2 then
        player:ResetPetTalents()
        player:SendBroadcastMessage("Your pet's talents have been reset!")
        player:GossipComplete()
    elseif action == 3 then
        player:SendBroadcastMessage("You're not a Hunter and cannot use these options.")
        player:GossipComplete()
    elseif action == 4 then
        player:GossipComplete()
    elseif action == 5 then
        player:CastSpell(player, 982, true)
        player:SendBroadcastMessage("Your pet has been revived!")
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)
