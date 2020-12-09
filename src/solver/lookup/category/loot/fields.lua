--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function fetch_loot_fields(rgpLoots, ctResources)
    local tFields = {}
    for _, pLoot in ipairs(rgpLoots) do
        local pLootid = pLoot:get_sourceid()

        local rgiMapids = ctResources:get_locations(pLootid)
        for _, iMapid in ipairs(rgiMapids) do
            tFields[iMapid] = 1
        end
    end

    return SSet{keys(tFields)}
end

function fn_get_item_fields(ctItems, tRscItems)
    return function(iId)
        local pFieldsSet = fetch_loot_fields(tRscItems[iId], ctItems)
        return pFieldsSet
    end
end
