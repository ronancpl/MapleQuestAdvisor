--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

U_INT_MIN = -0x80000000
U_INT_MAX = 0x7FFFFFFF

U_QUEUE_SIZE_INC = 25

S_WORLDMAP_BASE = "WorldMap"

require("utils.procedure.iterate")

function get_continent_id(iMapid)
    return math.floor(iMapid / 100000000)
end

function get_region_id(iMapid)
    return math.floor(iMapid / 10000000)
end

function math.iclamp(val, min, max)
    if min > max then
        error("[ERROR] ICLAMP: Minimum value provided is higher than maximum.")
    end

    return math.floor(math.min(math.max(val, min), max))
end

function math.clamp(val, min, max)
    return math.min(math.max(val, min), max)
end

function math.range(val, dec, inc)
    return val + dec, val + inc
end

function math.between(val, lwr, upr)
    return val >= lwr and val <= upr
end

function math.dlist(val)
    local rgiDs = {}

    local cur = math.abs(math.floor(val))
    repeat
        local i = cur % 10
        table.insert(rgiDs, i)

        cur = math.floor(cur / 10)
    until (cur < 1.0)

    local rgiVal = {}
    for _, i in rpairs(rgiDs) do
        table.insert(rgiVal, i)
    end

    return rgiVal
end
