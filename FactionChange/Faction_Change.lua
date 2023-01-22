-- Made by JadaDev
-- DO NOT REMOVE CREDITS

local TokenID = 55555
local CreatureEntry = 70000

function OnGossipHello(event, player, object)
    player:GossipMenuAddItem(0, "|TInterface\\icons\\Ability_DualWieldSpecialization:30:30|tFaction Change", 0, 1)
	player:GossipMenuAddItem(0, "|TInterface\\icons\\Spell_Shadow_SacrificialShield:30:30|tNevermind", 0, 2)
    player:GossipSendMenu(1, object)
end

function OnGossipSelect(event, player, object, sender, intid, code)
    if (intid == 1) then
		local TokenName = GetItemLink(TokenID):match("|h%[(.+)]|h")
        if (player:HasItem(TokenID) == true) then
            player:RemoveItem(TokenID, 1)
            player:SetAtLoginFlag(8)
            player:SendBroadcastMessage( TokenName .. " |cffff0000Is Removed, |cff00ff00Relog and change your character faction.")
        else
            player:SendBroadcastMessage( TokenName .. " |cffff0000Is Required to change your faction.")
        end
	elseif (intid == 2) then
		player:GossipComplete()
	end
end

RegisterCreatureGossipEvent(CreatureEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(CreatureEntry, 2, OnGossipSelect)
