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

local function debug_descriptor_region(iRegionid, pRscTree)
    print("Regionid:", iRegionid)

    local iSrcMapid = pRscTree:get_field_source()
    local iDestMapid = pRscTree:get_field_destination()
    print("Src: " .. iSrcMapid .. " Dest: " .. iDestMapid)

    local rgiRscs = pRscTree:get_resources()

    print("Rscs:")
    local tpFieldRscs = pRscTree:get_field_nodes()
    for iMapid, pRsc in pairs(tpFieldRscs) do
        local st = ""
        for _, iRscid in pairs(pRsc:get_resources()) do
            local iRscType = math.floor(iRscid / 1000000000)
            local iRscUnit = iRscid % 1000000000

            st = st .. "{" .. iRscType .. ":" .. iRscUnit .. "}" .. ", "
        end

        print("  " .. iMapid .. " : " .. st)
    end
    print("---------")
end

local function debug_descriptor_tree(pRscTree)
    local iSrcMapid = pRscTree:get_field_source()
    local iDestMapid = pRscTree:get_field_destination()

    local tpFieldRscs = pRscTree:get_field_nodes()
    local rgiRscs = pRscTree:get_resources()

    print("DEBUG TREE")
    for iRegionid, pRegionRscTree in pairs(tpFieldRscs) do
        print("DEBUG REGION #" .. iRegionid)
        debug_descriptor_region(iRegionid, pRegionRscTree)
        print("-----")
    end
    print("=====")
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

local function fetch_regional_resources(pLookupTable, iRegionid, pQuestResource)
    --[[
        'pQuestResource' filtering unneeded as 'pLookupTable' holds quest reqs specifically for this instance

        local tiMobs = pQuestResource:get_field_npc()
        local tiItems = pQuestResource:get_field_npc()
        local iFieldCur = pQuestResource:get_field_current()
        local iFieldEnter = pQuestResource:get_field_enter()
        local iFieldNpc = pQuestResource:get_field_npc()
    ]]--

    local tResourceFields = pLookupTable:get_resource_fields(iRegionid)

    local pRegionResource = CSolverRegionResource:new({iRegionid = iRegionid, tResourceFields = tResourceFields})
    return pRegionResource
end

local function create_interregional_resources_descriptor(pQuestResource, rgpPathMapids, rgiTransitRegionids, pLookupTable)
    local tpRegionResources = {}
    local tpPathMapids = {}

    local nTransitRegionids = #rgiTransitRegionids
    if nTransitRegionids > 0 then
        for i = 1, nTransitRegionids, 1 do
            local iRegionid = rgiTransitRegionids[i]

            local pRegionResource = fetch_regional_resources(pLookupTable, iRegionid, pQuestResource)

            local pRegionNode = {}
            pRegionNode["resource"] = pRegionResource
            pRegionNode["regional"] = 1

            tpRegionResources[iRegionid] = pRegionNode

            local pRegionSrcDest = rgpPathMapids[i]
            tpPathMapids[iRegionid] = pRegionSrcDest
        end
    else
        local iRegionid = rgiTransitRegionids[1]
        local pRegionResource = fetch_regional_resources(pLookupTable, iRegionid, pQuestResource)

        tpRegionResources["resource"] = pRegionResource
        tpRegionResources["regional"] = 1
    end

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
    tpRegionResources, tpPathMapids = create_interregional_resources_descriptor(pQuestResource, rgpPathMapids, rgiTransitRegionids, ctSolverLookup)

    local pRscTree = create_tree_interregional_resources(tpRegionResources, tpPathMapids)
    return pRscTree
end
