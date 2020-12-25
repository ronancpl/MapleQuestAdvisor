--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")

local SSet = require("pl.class").Set

local function fetch_static_fields(rgiSrcLoots)
    local pSetFields = SSet{unpack(rgiSrcLoots)}
    return pSetFields
end

function fn_get_static_fields()
    return function(trgiRscItems, iRscid)
        local pSetFields = fetch_static_fields(trgiRscItems[iRscid])

        local rgiVals = pSetFields:values()
        return rgiVals
    end
end

local function fetch_item_fields(rgiSrcLoots, ctResources)
    local tFields = {}
    for _, iSrcid in ipairs(rgiSrcLoots) do
        local rgiMapids = ctResources:get_locations(iSrcid)
        for _, iMapid in ipairs(rgiMapids) do
            tFields[iMapid] = 1
        end
    end

    return SSet{unpack(keys(tFields))}
end

function fn_get_item_fields(ctItems)
    return function(trgiRscItems, iRscid)
        local pSetFields = fetch_item_fields(trgiRscItems[iRscid], ctItems)

        local rgiVals = pSetFields:values()
        return rgiVals
    end
end
