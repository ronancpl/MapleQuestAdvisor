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
require("solver.lookup.category.entries.tables")
require("solver.lookup.constant")
require("solver.procedures.remaining")

local function create_descriptor_lookup_resources(tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid)
    local pLookupRscs = {}
    pLookupRscs[RLookupCategory.ITEMS] = list_resources_from_entries_item(tiItems)
    pLookupRscs[RLookupCategory.MOBS] = list_resources_from_entries_item(tiMobs)
    pLookupRscs[RLookupCategory.FIELD_ENTER] = list_resources_from_entries_item(tiFieldsEnter)
    pLookupRscs[RLookupCategory.FIELD_NPC] = list_resources_from_entries_static(iQuestNpcMapid)

    return pLookupRscs
end

local function generate_quest_resource_graph(tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid, iPlayerMapid)
    local pLookupRscs = create_descriptor_lookup_resources(tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid)
    local pLookupTable = load_solver_resource_lookup(ctFieldsLandscape, ctLoots, ctMobs, ctMobsGroup, ctReactors, ctQuests, pLookupRscs)

    local pQuestResource = build_quest_resource_bean(tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid, iPlayerMapid)
    local pRscTree = build_quest_resource_graph(pQuestResource, ctFieldsLandscape, ctFieldsDist, ctFieldsLink, pLookupTable, iPlayerMapid, iQuestNpcMapid)

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

local function calc_cost_quest_distance(iDist)
    return iDist * RQuest.FIELD.Curb
end

function evaluate_quest_distance(ctFieldsDist, ctAccessors, pQuestProp, pPlayerState, pQuestRoll)
    local pQuestChkProp = pQuestProp:get_requirement()

    local tiItems = fetch_accessor_remaining_requirement(ctAccessors:get_accessor_by_type(RQuest.ITEMS.name), pPlayerState, pQuestChkProp)
    local tiMobs = fetch_accessor_remaining_requirement(ctAccessors:get_accessor_by_type(RQuest.MOBS.name), pPlayerState, pQuestChkProp)
    local tiFieldsEnter = fetch_accessor_remaining_requirement(ctAccessors:get_accessor_by_type(RQuest.FIELD_ENTER.name), pPlayerState, pQuestChkProp)

    local iPlayerMapid = pPlayerState:get_mapid()
    local iQuestNpcMapid = get_npc_location(pQuestChkProp:get_npc(), iPlayerMapid)

    local iDist = 0
    if iQuestNpcMapid ~= nil then
        local pRscTree = generate_quest_resource_graph(tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid, iPlayerMapid)

        for iRegionid, pRegionRscTree in pairs(pRscTree:get_field_nodes()) do
            local trgiFieldRscs = fetch_regional_field_resource_graph(ctFieldsDist, pRegionRscTree)

            local iRegionDist = evaluate_regional_field_resource_graph(ctFieldsDist, pRegionRscTree, trgiFieldRscs)
            iDist = iDist + iRegionDist
        end

        pQuestRoll:set_resource_tree(pRscTree)
    else
        iDist = U_INT_MAX
    end

    return calc_cost_quest_distance(iDist)
end
