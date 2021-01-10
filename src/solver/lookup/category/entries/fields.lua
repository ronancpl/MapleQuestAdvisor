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
    return function(trgiSrcItems, iSrcid)
        local pSetFields = fetch_static_fields(trgiSrcItems[iSrcid])

        local rgiVals = pSetFields:values()
        return rgiVals
    end
end

local function fetch_item_fields(iSrcid, ctResources)
    local rgiMapids = ctResources:get_locations(iSrcid)
    return SSet{unpack(rgiMapids)}
end

function fn_get_item_fields(ctItems)
    return function(trgiSrcItems, iSrcid)
        local pSetFields = fetch_item_fields(iSrcid, ctItems)

        local rgiVals = pSetFields:values()
        return rgiVals
    end
end

function fn_get_mob_fields(ctMobsGroup, ctItems)    -- usage of QuestCountGroup found thanks to Shavit, Arnah
    return function(trgiSrcItems, iSrcid)
        local fn_item_fields = fn_get_item_fields(ctItems)

        local rgiMobs = ctMobsGroup:get_locations(iSrcid)
        if rgiMobs == nil then
            rgiMobs = {iSrcid}
        end

        local pSetFields = SSet{}
        for _, iMobid in ipairs(rgiMobs) do
            local rgiVals = fn_item_fields(trgiSrcItems, iMobid)
            pSetFields = pSetFields + SSet{unpack(rgiVals)}
        end

        local rgiVals = pSetFields:values()
        return rgiVals
    end
end
