local SIGHT_EAGLE = 1
local SIGHT_NORMAL = 2
local SIGHT_POOR = 3

local function isNightTime()
    local hour = getGameTime():getTimeOfDay()
    local night_start_hour = SandboxVars.UnderCoverOfDarkness.NightStartHour
    local night_end_hour = SandboxVars.UnderCoverOfDarkness.NightEndHour

    if night_start_hour == night_end_hour then
        return false
    end

    if night_start_hour > night_end_hour then
        return hour >= night_start_hour or hour < night_end_hour
    elseif night_start_hour < night_end_hour then
        return hour >= night_start_hour and hour < night_end_hour
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
