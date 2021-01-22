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
require("solver.lookup.constant")
require("solver.procedures.lookup")
require("utils.procedure.unpack")
require("utils.struct.array")
local SSet = require("pl.class").Set

local function is_resource_leaf(tpRegionResources)
    return tpRegionResources["regional"] ~= nil     -- contains regional descriptor node
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

local function build_descriptor_tree(pRscTree, tpTreeResources, tpPathMapids)
    local rgiTreeResourceids = SArray:new()

    if is_resource_leaf(tpTreeResources) then
        local pRegionResource = tpTreeResources["resource"]
        local iRegionid = pRegionResource:get_regionid()
        local tpRegionResources = pRegionResource:get_resource_fields()

        for iMapid, rgiResourceids in pairs(make_remissive_index_field_resources(tpRegionResources)) do
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

        for iRegionid, pRegionNode in pairs(tpTreeResources) do
            local pChildRscTree = CSolverTree:new()

            local tpChildPathMapids = tpPathMapids[iRegionid]
            build_descriptor_tree(pChildRscTree, pRegionNode, tpChildPathMapids)

            local rgiResourceids = pChildRscTree:get_resources()
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

local function get_tab_resource_id(iTabId, iRscid)
    return (iTabId * 1000000000) + iRscid
end

local function append_resource_regions(tRegions, iTabId, iRscid, tRscRegions)
    local rgiRegions = tRscRegions[get_tab_resource_id(iTabId, iRscid)]
    if rgiRegions ~= nil then
        for _, iRegionid in ipairs(rgiRegions) do
            tRegions[iRegionid] = 1
        end
    end
end

local function append_resource_table_regions(tRegions, iTabId, tiRscs, tRscRegions)
    for iRscid, _ in pairs(tiRscs) do
        append_resource_regions(tRegions, iTabId, iRscid, tRscRegions)
    end
end

local function fetch_regions_with_resources(pQuestResource, tRscRegions)
    local tRegions = {}

    local tiMobs = pQuestResource:get_mobs()
    append_resource_table_regions(tRegions, RLookupCategory.MOBS, tiMobs, tRscRegions)

    local tiItems = pQuestResource:get_items()
    append_resource_table_regions(tRegions, RLookupCategory.ITEMS, tiItems, tRscRegions)

    local iFieldEnter = pQuestResource:get_field_enter()
    append_resource_regions(tRegions, RLookupCategory.FIELD_ENTER, iFieldEnter, tRscRegions)

    local iFieldNpc = pQuestResource:get_field_npc()
    append_resource_regions(tRegions, RLookupCategory.FIELD_NPC, iFieldNpc, tRscRegions)

    return keys(tRegions)
end

local function fetch_regional_resources(pLookupTable, pQuestResource)
    local tRscRegions = pLookupTable:get_resource_regions()

    local rgpRegionResources = {}
    local rgiRegions = fetch_regions_with_resources(pQuestResource, tRscRegions)
    for _, iRegionid in ipairs(rgiRegions) do
        local tResourceFields = pLookupTable:get_resource_fields(iRegionid)

        local pRegionResource = CSolverRegionResource:new({iRegionid = iRegionid, tResourceFields = tResourceFields})
        table.insert(rgpRegionResources, pRegionResource)
    end

    return rgpRegionResources
end

local function fetch_regional_resources_descriptor(pLookupTable, pQuestResource)
    local tpRegionResources = {}

    local rgpRegionResources = fetch_regional_resources(pLookupTable, pQuestResource)
    for _, pRegionResource in ipairs(rgpRegionResources) do
        local iRegionid = pRegionResource:get_regionid()

        local pRegionNode = {}
        pRegionNode["resource"] = pRegionResource
        pRegionNode["regional"] = 1

        tpRegionResources[iRegionid] = pRegionNode
    end

    return tpRegionResources
end

local function get_region_priority(iVal)
    return U_INT_MAX - iVal
end

local function fetch_region_neighbors(iRegionid, ctFieldsLandscape)
    local tWorldNodes = ctFieldsLandscape:get_world_nodes()
    return keys(tWorldNodes[iRegionid])
end

local function init_path_regions(rgiTransitRegionids, rgiRegionids)
    local tpFrom = {}
    for _, iRegionid in ipairs(rgiRegionids) do
        tpFrom[iRegionid] = {-1, U_INT_MAX, 0}
    end

    local nTransitRegionids = #rgiTransitRegionids
    if nTransitRegionids > 0 then
        local iFromRegionid = rgiTransitRegionids[1]
        tpFrom[iFromRegionid] = {-1, 0, 0}

        for i = 2, nTransitRegionids, 1 do
            local iFromRegionid = rgiTransitRegionids[i - 1]
            local iToRegionid = rgiTransitRegionids[i]

            tpFrom[iToRegionid] = {iFromRegionid, 0, 0}     -- original path assume zero-cost value
        end
    end

    return tpFrom
end

local function fetch_path_region_resources(rgiTransitRegionids, rgiRegionids, ctFieldsLandscape)
    local tpFrom = init_path_regions(rgiTransitRegionids, rgiRegionids)    -- finds minimum spanning tree

    local pQueueFrontierRegions = SPriorityQueue:new()
    for _, iRegionid in ipairs(rgiTransitRegionids) do
        pQueueFrontierRegions:put(iRegionid, get_region_priority(0))     -- to calculate MST's new interregion links according to nearest in original path
    end

    local pSetToExplore = SSet{unpack(rgiRegionids)}
    while pQueueFrontierRegions:size() > 0 do
        local iCurRegionid = pQueueFrontierRegions:pop()
        pSetToExplore = pSetToExplore - SSet{iCurRegionid}

        local rgiNextRegionids = {}

        local rgiNeighborRegionids = fetch_region_neighbors(iCurRegionid, ctFieldsLandscape)
        for _, iRegionid in ipairs(rgiNeighborRegionids) do
            local pSetRegionid = SSet{iRegionid}
            if pSetRegionid:issubset(pSetToExplore) then
                table.insert(rgiNextRegionids, iRegionid)
            end
        end

        local pCurFrom = tpFrom[iCurRegionid]
        for _, iNeighborRegionid in ipairs(rgiNextRegionids) do
            local iDist = 1     -- adjacency cost of neighbor regions

            local pFrom = tpFrom[iNeighborRegionid]
            local iPathDist = pCurFrom[2] + iDist
            if iPathDist < pFrom[2] then
                pFrom[1] = iCurRegionid
                pFrom[2] = iPathDist
                pFrom[3] = iDist

                pQueueFrontierRegions:put(iNeighborRegionid, get_region_priority(iPathDist))
            end
        end
    end

    return tpFrom
end

local function fetch_path_region_inbound_link(tpRegionBcktPath, tpPathMapids, iRegionid, ctFieldsLandscape, ctFieldsLink)
    local pFrom = tpRegionBcktPath[iRegionid]
    local iFromRegionid = pFrom[1]

    local pRegionSrcDest = tpPathMapids[iFromRegionid]
    if pRegionSrcDest == nil then
        tpPathMapids[iFromRegionid] = {-1, -1}
        pRegionSrcDest = fetch_path_region_inbound_link(tpRegionBcktPath, tpPathMapids, iFromRegionid, ctFieldsLandscape, ctFieldsLink)
    end

    local iFromRegionSrcMapid = pRegionSrcDest[1]  -- fetch station to access the path-unbound region

    local tiFieldRegion = ctFieldsLandscape:get_field_regions()

    local rgpMapLinks = ctFieldsLink:get_stations_to_region(tiFieldRegion, iFromRegionSrcMapid, iRegionid)

    local iToStationMapid
    if #rgpMapLinks > 0 then
        local pStationMapLink = rgpMapLinks[1]
        _, iToStationMapid = unpack(pStationMapLink)
    else
        iToStationMapid = -1
    end

    local pCurRegionSrcDest = {iToStationMapid, iToStationMapid}    -- same ingress station is the leaving one
    tpPathMapids[iRegionid] = pCurRegionSrcDest
    return pCurRegionSrcDest
end

local function trace_outlying_path_resources(tpPathMapids, tpRegionBcktPath, rgiOutlyingRegionids)
    table.sort(rgiOutlyingRegionids, function (iR1, iR2) return tpRegionBcktPath[iR1][2] - tpRegionBcktPath[iR2][2] end)

    for _, iRegionid in ipairs(rgiOutlyingRegionids) do
        fetch_path_region_inbound_link(tpRegionBcktPath, tpPathMapids, iRegionid, ctFieldsLandscape, ctFieldsLink)
    end
end

local function trace_path_resources_descriptor(rgpPathMapids, rgiTransitRegionids, rgiResourceRegionids, rgiRegionids, ctFieldsLandscape, ctFieldsLink)
    local tpPathMapids = {}

    local nTransitRegionids = #rgiTransitRegionids
    for i = 1, nTransitRegionids, 1 do
        local iRegionid = rgiTransitRegionids[i]
        local pRegionSrcDest = rgpPathMapids[i]

        tpPathMapids[iRegionid] = pRegionSrcDest
    end

    end
    local rgiOutlyingRegionids = {}
    for _, iRegionid in ipairs(rgiResourceRegionids) do
        local pRegionSrcDest = tpPathMapids[iRegionid]
        if pRegionSrcDest == nil then
            table.insert(rgiOutlyingRegionids, iRegionid)
        end
    end

    if #rgiOutlyingRegionids > 0 then
        local tpRegionBcktPath = fetch_path_region_resources(rgiTransitRegionids, rgiRegionids, ctFieldsLandscape)
        trace_outlying_path_resources(tpPathMapids, tpRegionBcktPath, rgiOutlyingRegionids)
    end

    return tpPathMapids
end

local function create_interregional_resources_descriptor(pQuestResource, rgpPathMapids, rgiTransitRegionids, pLookupTable, ctFieldsLandscape, ctFieldsLink)
    local tpRegionResources = fetch_regional_resources_descriptor(pLookupTable, pQuestResource)
    local rgiResourceRegionids = keys(tpRegionResources)
    local rgiRegionids = keys(ctFieldsLandscape:get_world_nodes())

    local tpPathMapids = trace_path_resources_descriptor(rgpPathMapids, rgiTransitRegionids, rgiResourceRegionids, rgiRegionids, ctFieldsLandscape, ctFieldsLink)
    return tpRegionResources, tpPathMapids
end

function build_quest_resource_bean(tiItems, tiMobs, iFieldEnter, iQuestNpcMapid, iPlayerMapid)
    local pQuestResource = CSolverQuestResource:new({tiMobs = tiMobs, tiItems = tiItems, iFieldPlayer = iPlayerMapid, iFieldEnter = iFieldEnter, iFieldNpc = iQuestNpcMapid})
    return pQuestResource
end

function build_quest_resource_graph(pQuestResource, ctFieldsLandscape, ctFieldsDist, ctFieldsLink, ctSolverLookup, iSrcMapid, iDestMapid)
    local tiFieldRegion = ctFieldsLandscape:get_field_regions()
    local tWorldNodes = ctFieldsLandscape:get_world_nodes()

    local rgpPathMapids
    local rgiTransitRegionids
    rgpPathMapids, rgiTransitRegionids = fetch_interregional_trajectory(ctFieldsDist, ctFieldsLink, tiFieldRegion, tWorldNodes, iSrcMapid, iDestMapid)

    local tpRegionResources
    local tpPathMapids
    tpRegionResources, tpPathMapids = create_interregional_resources_descriptor(pQuestResource, rgpPathMapids, rgiTransitRegionids, ctSolverLookup, ctFieldsLandscape, ctFieldsLink)

    local pRscTree = create_tree_interregional_resources(tpRegionResources, tpPathMapids)
    return pRscTree
end
