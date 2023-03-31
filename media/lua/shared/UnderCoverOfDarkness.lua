local SIGHT_EAGLE = 1
local SIGHT_NORMAL = 2
local SIGHT_POOR = 3

local function isNightTime()
    local hour = getGameTime():getTimeOfDay()
    local nightStartHour = SandboxVars.UnderCoverOfDarkness.NightStartHour
    local nightEndHour = SandboxVars.UnderCoverOfDarkness.NightEndHour

    if nightStartHour == nightEndHour then
        return false
    end

    if nightStartHour > nightEndHour then
        return hour >= nightStartHour or hour < nightEndHour
    elseif nightStartHour < nightEndHour then
        return hour >= nightStartHour and hour < nightEndHour
    end
end

local function isFoggy(climateManager)
    local fogIntensity = climateManager:getFogIntensity()
    return fogIntensity >= SandboxVars.UnderCoverOfDarkness.MinimumFogIntensity
end

local function underCoverOfDarkness(climateManager)
    if isNightTime() or isFoggy(climateManager) then
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_POOR)
    else
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_NORMAL)
    end
end

Events.OnClimateTick.Add(underCoverOfDarkness)
