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

local function fetch_item_fields(iRscid, ctResources)
    local rgiMapids = ctResources:get_locations(iRscid)
    return SSet{unpack(rgiMapids)}
end

function fn_get_item_fields(ctItems)
    return function(trgiRscItems, iRscid)
        local pSetFields = fetch_item_fields(iRscid, ctItems)

        local rgiVals = pSetFields:values()
        return rgiVals
    end
end

function fn_get_mob_fields(ctMobsGroup, ctItems)    -- usage of QuestCountGroup found thanks to Shavit, Arnah
    return function(trgiRscItems, iRscid)
        local fn_item_fields = fn_get_item_fields(ctItems)

        local rgiMobs = ctMobsGroup:get_locations(iRscid)
        if rgiMobs == nil then
            rgiMobs = {iRscid}
        end

        local pSetFields = SSet{}
        for _, iMobid in ipairs(rgiMobs) do
            local rgiVals = fn_item_fields(trgiRscItems, iMobid)
            pSetFields = pSetFields + SSet{unpack(rgiVals)}
        end

        local rgiVals = pSetFields:values()
        return rgiVals
    end
end

function fetch_item_regions(pLandscape, ctResources)
    local tpRegionRscs = {}

    for _, iSrcid in pairs(ctResources:get_keys()) do
        for _, iMapid in pairs(fetch_item_fields(iSrcid, ctResources):values()) do
            local iRegionid = pLandscape:get_region_by_mapid(iMapid)
            if iRegionid > -1 then
                local rgiItems = tpRegionRscs[iRegionid]
                if rgiItems == nil then
                    rgiItems = {}
                    tpRegionRscs[iRegionid] = rgiItems
                end

                local rgpLoots = ctLoots:get_mob_entry(iSrcid)
                if rgpLoots ~= nil then
                    for _, pLoot in pairs(rgpLoots) do
                        local iRscid = pLoot:get_itemid()
                        rgiItems[iRscid] = 1
                    end
                end
            end
        end
    end

    local trgiRegionRscs = {}
    for iRegionid, tRscids in pairs(tpRegionRscs) do
        trgiRegionRscs[iRegionid] = keys(tRscids)
    end

    return trgiRegionRscs
end
