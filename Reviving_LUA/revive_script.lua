-- Script Made by JadaDev
-- DO NOT REMOVE CREDITS
-- DO NOT SHARE THIS SCRIPT UNLESS YOU HAVE PERMISION FROM JADADEV A SCREENSHOT IS REQUIRED
countdownRunning = false
instantReviveAreas = {2317, 876} -- This where your Mall Area ID's Should be IN.
countdownReviveAreas = {3792, 4991, 4272} -- This is where Your Dungeons AreaID or Locations that you want the players to be revived while fighting creature or getting reflective damage from friendly or getting killed by a player in general.

function OnGettingKilledByCreature(event, killer, killed)
    local resSpellId = killed:GetUInt32Value(1199)
    if (resSpellId > 0) then
        return
    end

    local name = killed:GetName()
    local areaId = killed:GetAreaId()

    if table.contains(instantReviveAreas, areaId) then
        killed:ResurrectPlayer()
    elseif table.contains(countdownReviveAreas, areaId) then
        if countdownRunning == true then
            return false
        end
        countdownRunning = true
        killed:GossipComplete()
        killed:RegisterEvent(OnReviveScripts, 200, 100, object, killed)
        killed:SendBroadcastMessage(
            name .. " |cffff0000You have been killed!\n|cffff00ffPlease Wait, You're been revived soon..."
        )
    end
end

function OnReviveScripts(event, delay, repeats, player, object)
    local timer = 101 - repeats
    local areaId = player:GetAreaId()

    if table.contains(countdownReviveAreas, areaId) then
        player:SendAreaTriggerMessage("Reviving " .. timer .. "%")
        if (timer == 100) then
            local chance = 100
            if (chance <= 100) then
                player:SendBroadcastMessage("|cff00c600You have been revived!")
                player:ResurrectPlayer()
                countdownRunning = false
            end
        end
    end
end

RegisterPlayerEvent(8, OnGettingKilledByCreature) -- On Creature Kill Player
RegisterPlayerEvent(6, OnGettingKilledByCreature) -- On Player Kill Player (Player KIlls Himself as Reflective Damage or Getting Killed by Friendly Reflective Damage.)
