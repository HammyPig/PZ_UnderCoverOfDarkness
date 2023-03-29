local SIGHT_EAGLE = 1
local SIGHT_NORMAL = 2
local SIGHT_POOR = 3

local function underCoverOfDarkness()
    local hour = getGameTime():getTimeOfDay()

    if hour < 5 or hour > 23 then
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_POOR)
    else
        getSandboxOptions():set("ZombieLore.Sight", SIGHT_NORMAL)
    end
end

Events.EveryHours.Add(underCoverOfDarkness)
