local DEBUG_MODE = true

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

local function printValues(climateManager)
    local function getZombieSightName()
        local zombieSightNames = {"Eagle", "Normal", "Poor"}
        local zombieSight = getSandboxOptions():getOptionByName("ZombieLore.Sight"):getValue()

        return zombieSightNames[zombieSight]
    end

    local hour = getGameTime():getTimeOfDay()
    local nightStartHour = SandboxVars.UnderCoverOfDarkness.NightStartHour
    local nightEndHour = SandboxVars.UnderCoverOfDarkness.NightEndHour

    local fogIntensity = climateManager:getFogIntensity()

    print("hour: ", hour)
    print("nightStartHour: ", nightStartHour)
    print("nightEndHour: ", nightEndHour)
    print()
    print("fogIntensity: ", fogIntensity)
    print("minimumFogIntensity: ", SandboxVars.UnderCoverOfDarkness.MinimumFogIntensity)
    print()
    print("isNightTime: ", isNightTime())
    print("isFoggy: ", isFoggy(climateManager))
    print("zombieSightName: ", getZombieSightName())
end

local function underCoverOfDarkness(climateManager)
    if isNightTime() or isFoggy(climateManager) then
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_POOR)
    else
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_NORMAL)
    end

    if DEBUG_MODE then
        printValues(climateManager)
    end
end

Events.OnClimateTick.Add(underCoverOfDarkness)
