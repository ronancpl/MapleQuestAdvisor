--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")

local SSet = require("pl.Set")

local function fetch_static_fields(rgiSrcLoots)
    local pSetFields = SSet{unpack(rgiSrcLoots)}
    return pSetFields
end

function fn_get_static_fields()
    return function(trgiSrcItems, iSrcid)
        local pSetFields = fetch_static_fields(trgiSrcItems[iSrcid])

        local rgiVals = SSet.values(pSetFields)
        return rgiVals
    end
end

local function fetch_item_fields(iSrcid, ctResources)
    local rgiMapids = ctResources:get_locations(iSrcid)
    return SSet{unpack(rgiMapids)}
end

function fn_get_resource_fields(ctResources)
    return function(trgiSrcItems, iSrcid)
        local pSetFields = fetch_item_fields(iSrcid, ctResources)

        local rgiVals = SSet.values(pSetFields)
        return rgiVals
    end
end

function fn_get_mob_fields(ctMobsGroup, ctMobs)    -- usage of QuestCountGroup found thanks to Shavit, Arnah
    return function(trgiSrcItems, iSrcid)
        local fn_rsc_fields = fn_get_resource_fields(ctMobs)

        local rgiMobs = ctMobsGroup:get_locations(iSrcid)
        if rgiMobs == nil then
            rgiMobs = {iSrcid}
        end

        local pSetFields = SSet{}
        for _, iMobid in ipairs(rgiMobs) do
            local rgiVals = fn_rsc_fields(trgiSrcItems, iMobid)
            pSetFields = pSetFields + SSet{unpack(rgiVals)}
        end

        local rgiVals = SSet.values(pSetFields)
        return rgiVals
    end
end
