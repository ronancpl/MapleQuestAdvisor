--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("router.filters.quest")
require("solver.graph.build")
require("solver.graph.fetch")
require("solver.graph.route")
require("solver.procedures.remaining")

local function generate_quest_resource_graph(ivtItems, ivtMobs, iFieldEnter, iQuestNpcMapid, iPlayerMapid)
    local pQuestResource = build_quest_resource_bean(ivtItems, ivtMobs, iFieldEnter, iQuestNpcMapid, iPlayerMapid)

    local pRscTree = build_quest_resource_graph(pQuestResource, ctFieldsLandscape, ctFieldsDist, ctFieldsLink, ctLoots, ctMobs, ctReactors, iPlayerMapid, iQuestNpcMapid)
    return pRscTree
end

local function get_npc_return_locations(iNpcid)
    local tReturnMapids = {}

    for _, iMapid in ipairs(ctNpcs:get_locations(iNpcid)) do
        local iRetMapid = ctFieldsMeta:get_field_return(iMapid) or iMapid
        tReturnMapids[iRetMapid] = iMapid
    end

    return tReturnMapids
end

local function get_npc_location(iNpcid, iPlayerMapid)
    local iPlayerRegionid = ctFieldsLandscape:get_region_by_mapid(iPlayerMapid)

    local rgiAbroadMapids = {}

    local iNpcMapid = nil
    local iNpcFieldDist = U_INT_MAX
    for _, iMapid in pairs(get_npc_return_locations(iNpcid)) do
        local iRegionid = ctFieldsLandscape:get_region_by_mapid(iMapid)
        if iRegionid == iPlayerRegionid then
            local iDist = ctFieldsLandscape:fetch_field_distance(iPlayerMapid, iMapid, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)
            if iDist < iNpcFieldDist then
                iNpcMapid = iMapid
                iNpcFieldDist = iDist
            end
        else
            table.insert(rgiAbroadMapids, iMapid)
        end
    end

    if iNpcMapid == nil then
        for _, iMapid in ipairs(rgiAbroadMapids) do
            local iDist = ctFieldsLandscape:fetch_field_distance(iPlayerMapid, iMapid, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)
            if iDist < iNpcFieldDist then
                iNpcMapid = iMapid
                iNpcFieldDist = iDist
            end
        end
    end

    return iNpcMapid
end

function evaluate_quest_distance(ctFieldsDist, ctAccessors, pQuestProp, pPlayerState)
    local pQuestReqProp = pQuestProp:get_requirement()

    local ivtItems = fetch_accessor_remaining_requirement(ctAccessors:get_accessor_by_type(RQuest.ITEMS.name), pPlayerState, pQuestReqProp)
    local ivtMobs = fetch_accessor_remaining_requirement(ctAccessors:get_accessor_by_type(RQuest.MOBS.name), pPlayerState, pQuestReqProp)
    local iFieldEnter = pQuestReqProp:get_field_enter()
    local iPlayerMapid = pPlayerState:get_mapid()
    local iQuestNpcMapid = get_npc_location(pQuestReqProp:get_npc(), iPlayerMapid)

    local pRscTree = generate_quest_resource_graph(ivtItems, ivtMobs, iFieldEnter, iQuestNpcMapid, iPlayerMapid)
    local trgiFieldRscs = fetch_field_scope_quest_resource_graph(ctFieldsDist, pRscTree)
    local iDist = evaluate_quest_resource_graph(ctFieldsDist, pRscTree, trgiFieldRscs)

    return iDist * RQuest.FIELD.Curb
end
