local SIGHT_EAGLE = 1
local SIGHT_NORMAL = 2
local SIGHT_POOR = 3

local function isNightTime()
    local hour = getGameTime():getTimeOfDay()
    return hour >= 23 or hour < 5
end

local function isFoggy(climateManager)
    local fogIntensity = climateManager:getFogIntensity()
    return fogIntensity >= 0.1
end

local function underCoverOfDarkness(climateManager)
    if isNightTime() or isFoggy(climateManager) then
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_POOR)
    else
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_NORMAL)
    end
end

Events.OnClimateTick.Add(underCoverOfDarkness)
