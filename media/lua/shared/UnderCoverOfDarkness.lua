local DEBUG_MODE = true

local SIGHT_EAGLE = 1
local SIGHT_NORMAL = 2
local SIGHT_POOR = 3

local DUSK_OFFSET = 2
local DAWN_OFFSET = -2

local function isNightTime(climateManager)
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

local function printValues(climateManager)
    local function getZombieSightName()
        local zombieSightNames = {"Eagle", "Normal", "Poor"}
        local zombieSight = getSandboxOptions():getOptionByName("ZombieLore.Sight"):getValue()

        return zombieSightNames[zombieSight]
    end

    local hour = getGameTime():getTimeOfDay()
    local season = climateManager:getCurrentDay():getSeason()

    local nightStartHour = season:getDusk() + DUSK_OFFSET
    local nightEndHour = season:getDawn() + DAWN_OFFSET

    local fogIntensity = climateManager:getFogIntensity()

    print("hour: ", hour)
    print("nightStartHour: ", nightStartHour)
    print("nightEndHour: ", nightEndHour)
    print()
    print("fogIntensity: ", fogIntensity)
    print("minimumFogIntensity: ", SandboxVars.UnderCoverOfDarkness.MinimumFogIntensity)
    print()
    print("isNightTime: ", isNightTime(climateManager))
    print("isFoggy: ", isFoggy(climateManager))
    print("zombieSightName: ", getZombieSightName())
end

local function underCoverOfDarkness(climateManager)
    if isNightTime(climateManager) or isFoggy(climateManager) then
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_POOR)
    else
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_NORMAL)
    end

    if DEBUG_MODE then
        printValues(climateManager)
    end
end

Events.OnClimateTick.Add(underCoverOfDarkness)
