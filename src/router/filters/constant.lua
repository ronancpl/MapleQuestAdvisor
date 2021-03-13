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

function get_continent_id(iMapid)
    return math.floor(iMapid / 100000000)
end

function get_region_id(iMapid)
    return math.floor(iMapid / 10000000)
end

function math.iclamp(val, min, max)
    return math.floor(math.min(math.max(val, min), max))
end

function math.clamp(val, min, max)
    return math.min(math.max(val, min), max)
end
