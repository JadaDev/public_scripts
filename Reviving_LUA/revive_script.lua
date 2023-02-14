-- Script Made by JadaDev
-- DO NOT REMOVE CREDITS
-- DO NOT SHARE THIS SCRIPT UNLESS YOU HAVE PERMISION FROM JADADEV A SCREENSHOT IS REQUIRED
countdownRunning = false

function OnGettingKilledByCreature(event, killer, killed)
  local resSpellId = killed:GetUInt32Value(1199);
  if (resSpellId > 0) then
      return
  end

  local name = killed:GetName()
  local areaId = killed:GetAreaId()
  if areaId == 2317 or areaId == 876 then -- mall [ Instant Revive ]
    killed:ResurrectPlayer()
  end
  if areaId == 3792 or areaId == 4991 or areaId == 4272  then --Start-- turn off countdown when the player leaves dungeon
    if countdownRunning == true then
      return false
  end 
  countdownRunning = true
  killed:GossipComplete()
  killed:RegisterEvent(OnReviveScripts, 200, 100, object, killed)
  killed:SendBroadcastMessage(name .. " |cffff0000You have been killed!\n|cffff00ffPlease Wait, You're been revived soon...")
  end
end

function OnReviveScripts(event, delay, repeats, player, object)
  local timer = 101 - repeats
  local areaId = player:GetAreaId()
  if areaId == 3792 or areaId == 4991 or areaId == 4272 then --Start-- turn off countdown when the player leaves dungeon
  player:SendAreaTriggerMessage("Reviving "..timer.."%" )
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
