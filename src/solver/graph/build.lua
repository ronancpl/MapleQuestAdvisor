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
require("router.procedures.world.abroad")
require("solver.graph.tree.component")
require("solver.graph.recipe.regional")
require("solver.graph.recipe.resource")
require("solver.procedures.lookup")
require("utils.struct.array")

local function is_resource_leaf(tpRegionResources)
    return tpRegionResources["regional"] ~= nil     -- has an array table
end

local function make_remissive_index_field_resources(tpResourceFields)
    local trgiFieldResources = {}

    for iRscid, rgiMapids in pairs(tpResourceFields) do
        for _, iMapid in ipairs(rgiMapids) do
            local rgiRscs = trgiFieldResources[iMapid]
            if rgiRscs == nil then
                rgiRscs = {}
                trgiFieldResources[iMapid] = rgiRscs
            end

            table.insert(rgiRscs, iRscid)
        end
    end

    return trgiFieldResources
end

local function build_descriptor_tree(pRscTree, tpRegionResources, tpPathMapids)
    local rgiTreeResourceids = SArray:new()

    if is_resource_leaf(tpRegionResources) then
        local pRegionResource = tpRegionResources["resource"]
        local iRegionid = pRegionResource:get_regionid()
        local tpSubregionResources = pRegionResource:get_resource_fields()

        for iMapid, rgiResourceids in pairs(make_remissive_index_field_resources(tpSubregionResources)) do
            local pRsc = CSolverResource:new()
            pRsc:set_resources(rgiResourceids)

            rgiTreeResourceids:add_all(rgiResourceids)

            pRscTree:add_field_node(iMapid, pRsc)
        end

        local iSrcMapid
        local iDestMapid
        iSrcMapid, iDestMapid = unpack(tpPathMapids)

        pRscTree:set_field_source(iSrcMapid)
        pRscTree:set_field_destination(iDestMapid)
    else
        local iSrcMapid = U_INT_MAX
        local iDestMapid = -1

        for iRegionid, pRegionNode in pairs(tpRegionResources) do
            local pChildRscTree = CSolverTree:new()

            local tpChildPathMapids = tpPathMapids[iRegionid]
            build_descriptor_tree(pChildRscTree, pRegionNode, tpChildPathMapids)

            local rgiResourceids = pChildRscTree:get_resources():values()
            rgiTreeResourceids:add_all(rgiResourceids)

            pRscTree:add_field_node(iRegionid, pChildRscTree)

            iSrcMapid = math.min(iSrcMapid, pChildRscTree:get_field_source())
            iDestMapid = math.max(iDestMapid, pChildRscTree:get_field_destination())
        end

        pRscTree:set_field_source(iSrcMapid)
        pRscTree:set_field_destination(iDestMapid)
    end

    pRscTree:set_resources(rgiTreeResourceids:list())
end

local function create_tree_interregional_resources(tpRegionResources, tpPathMapids)
    local pRscTree = CSolverTree:new()
    build_descriptor_tree(pRscTree, tpRegionResources, tpPathMapids)

    return pRscTree
end

local function fetch_regional_resources(iRegionid, pQuestResource, pLandscape, ctLoots, ctMobs, ctReactors)
    local iFieldEnter = pQuestResource:get_field_enter()
    local iFieldNpc = pQuestResource:get_field_npc()

    local pLookupTable = solver_resource_lookup_init(pLandscape, ctLoots, ctMobs, ctReactors, iFieldEnter, iFieldNpc)
    local tResourceFields = pLookupTable:get_resource_fields(iRegionid)

    local pRegionResource = CSolverRegionResource:new({iRegionid = iRegionid, tResourceFields = tResourceFields})
    return pRegionResource
end

local function create_interregional_resources_descriptor(pQuestResource, rgpPathMapids, rgiTransitRegionids, pLandscape, ctLoots, ctMobs, ctReactors)
    local tpRegionResources = {}
    local tpPathMapids = {}

    local nTransitRegionids = #rgiTransitRegionids
    if nTransitRegionids > 1 then
        for i = 1, nTransitRegionids, 1 do
            local iRegionid = rgiTransitRegionids[i]

            local pRegionResource = fetch_regional_resources(iRegionid, pQuestResource, pLandscape, ctLoots, ctMobs, ctReactors)

            local pRegionNode = {}
            pRegionNode["resource"] = pRegionResource
            pRegionNode["regional"] = 1

            tpRegionResources[iRegionid] = pRegionNode

            local pRegionSrcDest = rgpPathMapids[i]
            tpPathMapids[iRegionid] = pRegionSrcDest
        end
    else
        local pRegionResource = fetch_regional_resources(rgiTransitRegionids[1], pQuestResource, pLandscape, ctLoots, ctMobs, ctReactors)

        tpRegionResources["resource"] = pRegionResource
        tpRegionResources["regional"] = 1
    end

    return tpRegionResources, tpPathMapids
end

function build_quest_resource_bean(ivtItems, ivtMobs, iFieldEnter, iQuestNpcMapid, iPlayerMapid)
    local pQuestResource = CSolverQuestResource:new({ivtMobs = ivtMobs, ivtItems = ivtItems, iFieldPlayer = iPlayerMapid, iFieldEnter = iFieldEnter, iFieldNpc = iQuestNpcMapid})
    return pQuestResource
end

function build_quest_resource_graph(pQuestResource, ctFieldsLandscape, ctFieldsDist, ctFieldsLink, ctLoots, ctMobs, ctReactors, iSrcMapid, iDestMapid)
    local tiFieldRegion = ctFieldsLandscape:get_field_regions()
    local tWorldNodes = ctFieldsLandscape:get_world_nodes()

    local rgpPathMapids
    local rgiTransitRegionids
    rgpPathMapids, rgiTransitRegionids = fetch_interregional_trajectory(ctFieldsDist, ctFieldsLink, tiFieldRegion, tWorldNodes, iSrcMapid, iDestMapid)

    local tpRegionResources
    local tpPathMapids
    tpRegionResources, tpPathMapids = create_interregional_resources_descriptor(pQuestResource, rgpPathMapids, rgiTransitRegionids, ctFieldsLandscape, ctLoots, ctMobs, ctReactors)

    local pRscTree = create_tree_interregional_resources(tpRegionResources, tpPathMapids)
    return pRscTree
end
