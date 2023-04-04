local function isNightTime(climateManager)
    local DUSK_OFFSET = 2
    local DAWN_OFFSET = -2

    local hour = getGameTime():getTimeOfDay()
    local season = climateManager:getCurrentDay():getSeason()

    local nightStartHour = season:getDusk() + DUSK_OFFSET
    local nightEndHour = season:getDawn() + DAWN_OFFSET

    if nightStartHour > nightEndHour then
        return hour >= nightStartHour or hour < nightEndHour
    else
        return hour >= nightStartHour and hour < nightEndHour
    end
end

local function isFoggy(climateManager)
    local fogIntensity = climateManager:getFogIntensity()
    return fogIntensity >= SandboxVars.UnderCoverOfDarkness.MinimumFogIntensity
end

local function underCoverOfDarkness(climateManager)
    local SIGHT_EAGLE = 1
    local SIGHT_NORMAL = 2
    local SIGHT_POOR = 3
    
    if isNightTime(climateManager) or isFoggy(climateManager) then
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_POOR)
    else
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_NORMAL)
    end
end

Events.OnClimateTick.Add(underCoverOfDarkness)
