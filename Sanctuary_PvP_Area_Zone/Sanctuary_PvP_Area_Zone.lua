-- Made by JadaDev Added Areas Also [ DO NOT REMOVE CREDITS ] 
-- Sanctuary Zones & Areas works on all
-- PVP Areas Works on all except Shattrath and Dalaran somehow ? who knows! Maybe DBC effects.
local SanctuaryZoneIDs =
{
    -- Zone : Stranglethorn Vale you could add as following {33, 1, 2} etc..
    33
}
-- Sanctuary Areas
local SanctuaryAreaIDs =
{
    -- Area : Battle Ring you could add as following {2177, 1, 2} etc..
    2177
}
-- PVP Zones [You can Edit to else have it fanctions pvp only or ffa]
local PvPZoneIDs =
{
    -- Zone : Durator you could add as following {14, 1, 2} etc..
    14
}
-- PVP Areas [You can Edit to else have it fanctions pvp only or ffa]
local PvPAreaIDs =
{
    -- Area : Durator you could add as following {14, 1, 2} etc..
    14
}
local function MakeZoneSanctuary(event, player, newZone)
    for _,v in pairs (SanctuaryZoneIDs) do
        if newZone == v then
            player:SetSanctuary(true)
        end
    end
end

local function MakeAreaSanctuary(event, player, newArea)
    for _,v in pairs (SanctuaryAreaIDs) do
        if newArea == v then
            player:SetSanctuary(true)
        end
    end
end

local function MakePvPZone(event, player, newZone)
    for _,v in pairs (PvPZoneIDs) do
        if newZone == v then
            player:SetFFA(true) -- This will set everyone on PVP like Battle Ring in Gurubashi Arena
           -- player:SetPvP(true) -- This will set PVP (fanctions)
        end
    end
end

local function MakePvPArea(event, player, newArea)
    for _,v in pairs (PvPAreaIDs) do
        if newArea == v then
            player:SetFFA(true) -- This will set everyone on PVP like Battle Ring in Gurubashi Arena
           -- player:SetPvP(true) -- This will set PVP (fanctions)
        end
    end
end

RegisterPlayerEvent(27, MakeZoneSanctuary)
RegisterPlayerEvent(27, MakeAreaSanctuary)
RegisterPlayerEvent(27, MakePvPZone)
RegisterPlayerEvent(27, MakePvPArea)
