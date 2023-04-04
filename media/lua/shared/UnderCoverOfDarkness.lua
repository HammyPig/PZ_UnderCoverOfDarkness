local function getNightHourOffset()
    local LOW_LIGHT = 1
    local DARK = 2
    local PITCH_BLACK = 3

    local nightHourOffsets = {
        [LOW_LIGHT]=0,
        [DARK]=1,
        [PITCH_BLACK]=2
    }

    return nightHourOffsets[SandboxVars.UnderCoverOfDarkness.MinimumDarknessLevel]
end

local function isNightTime(climateManager)
    local DUSK_OFFSET = 2
    local DAWN_OFFSET = -2

    local hour = getGameTime():getTimeOfDay()
    local season = climateManager:getCurrentDay():getSeason()

    local nightStartHour = season:getDusk() + getNightHourOffset()
    local nightEndHour = season:getDawn() - getNightHourOffset()

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
    if isNightTime(climateManager) or isFoggy(climateManager) then
        getSandboxOptions():set("ZombieLore.Sight", SandboxVars.UnderCoverOfDarkness.ReducedZombieSight)
    else
        getSandboxOptions():set("ZombieLore.Sight", SandboxVars.UnderCoverOfDarkness.NormalZombieSight)
    end
end

Events.OnClimateTick.Add(underCoverOfDarkness)
