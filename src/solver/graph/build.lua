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
require("solver.graph.component")
require("solver.graph.recipe.regional")
require("solver.graph.recipe.resource")
require("solver.procedures.lookup")
require("utils.struct.array")

local function is_resource_leaf(tpRegionResources)
    return next(tpRegionResources, nil)[2] > 0    -- is an array table
end

local function build_descriptor_tree(pRscTree, tpRegionResources, tpPathMapids)
    local rgiTreeResourceids = SArray:new()

    if is_resource_leaf(tpRegionResources) then
        for iMapid, rgiResourceids in pairs(tpRegionResources) do
            local pRsc = CSolverResource:new()
            pRsc:set_resources(rgiResourceids)

            rgiTreeResourceids:add_all(rgiResourceids)

            pRscTree:add_field_node(iMapid, pRsc)
        end

        local iSrcMapid
        local iDestMapid
        iSrcMapid, iDestMapid = unpack(rgpPathMapids)

        pRscTree:set_field_source(iSrcMapid)
        pRscTree:set_field_destination(iDestMapid)
    else
        local iSrcMapid = U_INT_MAX
        local iDestMapid = -1

        for iRegionid, tpSubregionResources in pairs(trgpRegionResources) do
            local pChildRscTree = CSolverTree:new()

            local tpChildPathMapids = tpPathMapids[iRegionid]
            build_descriptor_tree(pChildRscTree, tpSubregionResources, tpChildPathMapids)

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

local function create_tree_interregional_resources(ttpRegionResources, tpPathMapids)
    local pRscTree = CSolverTree:new()
    build_descriptor_tree(pRscTree, ttpRegionResources, tpPathMapids)

    return pRscTree
end

local function fetch_regional_resources(iRegionid, pQuestResource, pLandscape, ctLoots, ctMobs, ctReactors)
    local ivtMobs = pQuestResource:get_mobs()
    local ivtItems = pQuestResource:get_items()

    local pLookupTable = solver_resource_lookup_init(pLandscape, ctLoots, ctMobs, ctReactors)

    local pLkupMobsTable = pLookupTable:get_mobs()
    local trgpRegionMobRscs = pLkupMobsTable:get_field_resources_by_region_id(iRegionid, ivtMobs)

    local pLkupItemsTable = pLookupTable:get_items()
    local trgpRegionItemRscs = pLkupItemsTable:get_field_resources_by_region_id(iRegionid, ivtItems)

    local iFieldEnter = pQuestResource:get_field_enter()
    if pLandscape:get_region_by_mapid(iFieldEnter) ~= iRegionid then
        iFieldEnter = -1
    end

    local pRegionResource = CSolverRegionResource:new({trgpMobRscs = trgpRegionMobRscs, trgpItemRscs = trgpRegionItemRscs, iFieldEnter = iFieldEnter})
    return pRegionResource
end

local function create_interregional_resources_descriptor(pQuestResource, rgpPathMapids, rgiTransitRegionids, pLandscape, ctLoots, ctMobs, ctReactors)
    local ttpRegionResources
    local tpPathMapids = {}

    local nTransitRegionids = #rgiTransitRegionids
    if nTransitRegionids > 1 then
        for i = 1, nTransitRegionids, 1 do
            local iRegionid = rgiTransitRegionids[i]

            local pRegionResource = fetch_regional_resources(iRegionid, pQuestResource, pLandscape, ctLoots, ctMobs, ctReactors)
            ttpRegionResources[iRegionid] = pRegionResource

            local pRegionSrcDest = rgpPathMapids[i]
            tpPathMapids[iRegionid] = pRegionSrcDest
        end
    else
        ttpRegionResources = tpRegionResources
    end

    return ttpRegionResources, tpPathMapids
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

    local ttpRegionResources
    local tpPathMapids
    ttpRegionResources, tpPathMapids = create_interregional_resources_descriptor(pQuestResource, rgpPathMapids, rgiTransitRegionids, ctFieldsLandscape, ctLoots, ctMobs, ctReactors)

    local pRscTree = create_tree_interregional_resources(ttpRegionResources, tpPathMapids)
    return pRscTree
end
