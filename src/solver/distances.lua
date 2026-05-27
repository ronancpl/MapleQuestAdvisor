--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.quest")
require("router.procedures.constant")
require("router.procedures.world.npc")
require("solver.graph.build")
require("solver.graph.fetch")
require("solver.graph.route")
require("solver.graph.tree.component")
require("solver.lookup.category.field")
require("solver.lookup.constant")
require("solver.procedures.remaining")

local function generate_quest_resource_graph(iNpcid, tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid, iPlayerMapid)
    local pLookupRscs = create_descriptor_lookup_resources(tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid)
    local pLookupTable = load_solver_resource_lookup(ctFieldsLandscape, ctLoots, ctMobs, ctMobsGroup, ctReactors, ctQuests, pLookupRscs)

    local pQuestResource = build_quest_resource_bean(tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid, iPlayerMapid, iNpcid)
    local pRscTree = build_quest_resource_graph(pQuestResource, ctFieldsLandscape, ctFieldsDist, ctFieldsLink, pLookupTable, iPlayerMapid, iQuestNpcMapid)

    return pRscTree
end

local function calc_cost_quest_distance(iDist)
    return iDist * RQuest.FIELD.Curb
end

function evaluate_quest_distance(ctFieldsDist, ctAccessors, pQuestProp, pPlayerState, pQuestRoll)
    local pQuestChkProp = pQuestProp:get_requirement()

    local tiItems = fetch_accessor_remaining_requirement(ctAccessors:get_accessor_by_type(RQuest.ITEMS.name), pPlayerState, pQuestChkProp)
    local tiMobs = fetch_accessor_remaining_requirement(ctAccessors:get_accessor_by_type(RQuest.MOBS.name), pPlayerState, pQuestChkProp)
    local tiFieldsEnter = fetch_accessor_remaining_requirement(ctAccessors:get_accessor_by_type(RQuest.FIELD_ENTER.name), pPlayerState, pQuestChkProp)

    local iNpcid = pQuestChkProp:get_npc()

    local iPlayerMapid = pPlayerState:get_mapid()
    local iQuestNpcMapid = get_npc_location(iNpcid, iPlayerMapid)

    local iDist = 0
    if iQuestNpcMapid ~= nil then
        local pRscTree = generate_quest_resource_graph(iNpcid, tiItems, tiMobs, tiFieldsEnter, iQuestNpcMapid, iPlayerMapid)

        for iRegionid, pRegionRscTree in pairs(pRscTree:get_field_nodes()) do
            local trgiFieldRscs = fetch_regional_field_resource_graph(ctFieldsDist, pRegionRscTree)

            local iRegionDist = evaluate_regional_field_resource_graph(ctFieldsDist, pRegionRscTree, trgiFieldRscs)
            iDist = iDist + iRegionDist
        end

        pQuestRoll:set_resource_tree(pRscTree)
    else
        iDist = U_INT_MAX
        pQuestRoll:set_resource_tree(CSolverTree:new())
    end

    return calc_cost_quest_distance(iDist)
end
