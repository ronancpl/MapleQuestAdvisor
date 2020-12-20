--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local SSet = require("pl.class").Set

function fn_get_static_fields()
    return function(tRscItems, iRscid)
        local pFieldsSet = SSet{tRscItems[iRscid]}

        local rgiVals = pFieldsSet:values()
        return rgiVals
    end
end

local function fetch_loot_fields(tpSrcLoots, ctResources)
    local tFields = {}
    for iLootid, _ in pairs(tpSrcLoots) do
        local rgiMapids = ctResources:get_locations(iLootid)
        for _, iMapid in ipairs(rgiMapids) do
            tFields[iMapid] = 1
        end
    end

    return SSet{keys(tFields)}
end

function fn_get_item_fields(ctItems)
    return function(tRscItems, iRscid)
        local pFieldsSet = fetch_loot_fields(tRscItems[iRscid], ctItems)

        local rgiVals = pFieldsSet:values()
        return rgiVals
    end
end
