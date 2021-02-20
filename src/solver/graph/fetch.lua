--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.assignment.procedures.solve")
require("solver.graph.resource.measure")

local function fetch_model_resource_field_values(ctFieldsLandscape, ctRetrieveLootMobs, ctRetrieveLootReactors, iEntryMapid, pResource, tiRscIdxs)
    local rgiFieldCols = {}
    local rgiFieldCosts = {}

    for _, iRsc in ipairs(pResource:get_resources()) do
        local iRscIdx = tiRscIdxs[iRsc]
        local iRscUtilCost = calc_resource_retrieve_utility_cost(ctFieldsLandscape, ctRetrieveLootMobs, ctRetrieveLootReactors, iEntryMapid, iRsc)

        table.insert(rgiFieldCols, iRscIdx)
        table.insert(rgiFieldCosts, iRscUtilCost)
    end

    return rgiFieldCols, rgiFieldCosts
end

local function make_model_row_values(nCols, rgiFieldCols, rgiFieldCosts, iRscDistCost)
    local rgiRowValues = {}

    for i = 1, nCols, 1 do
        rgiRowValues[i] = 0
    end

    for i, iCol in ipairs(rgiFieldCols) do
        local iRscUtilCost = rgiFieldCosts[i]
        rgiRowValues[iCol] = calc_resource_retrieve_cost(iRscUtilCost, iRscDistCost)
    end

    return rgiRowValues
end

local function create_model_quest_resource_graph(ctFieldsDist, iSrcMapid, tpFieldRscs, rgiRegionRscs)
    local rgpTableValues = {}

    local rgiMetaFields = {}
    local rgiMetaRscs = {}

    local tiRscIdxs = {}
    for iIdx, iRsc in ipairs(rgiRegionRscs) do
        tiRscIdxs[iRsc] = iIdx
        table.insert(rgiMetaRscs, iRsc)
    end

    local nCols = #rgiMetaRscs
    for iMapid, pResource in pairs(tpFieldRscs) do
        local rgiFieldCols
        local rgiFieldCosts
        rgiFieldCols, rgiFieldCosts = fetch_model_resource_field_values(ctFieldsLandscape, ctRetrieveLootMobs, ctRetrieveLootReactors, iSrcMapid, pResource, tiRscIdxs)

        local iRscDist = ctFieldsLandscape:fetch_field_distance(iSrcMapid, iMapid, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)
        local iRscDistCost = calc_resource_field_cost(iRscDist)

        local rgiRowValues = make_model_row_values(nCols, rgiFieldCols, rgiFieldCosts, iRscDistCost)
        table.insert(rgpTableValues, rgiRowValues)

        table.insert(rgiMetaFields, iMapid)
    end

    return rgpTableValues, rgiMetaFields, rgiMetaRscs
end

local function traverse_model_quest_resource_graph(rgpTableValues, rgiMetaFields, rgiMetaRscs)
    local trgiAgentTasks = run_assignment_case(rgpTableValues)

    local trgiFieldRscs = {}
    for iAgentid, rgiTasks in pairs(trgiAgentTasks) do
        local iMapid = rgiMetaFields[iAgentid]

        local rgiRscs = {}
        trgiFieldRscs[iMapid] = rgiRscs

        for _, iTask in ipairs(rgiTasks) do
            local iRscid = rgiMetaRscs[iTask]
            table.insert(rgiRscs, iRscid)
        end
    end

    return trgiFieldRscs
end

function fetch_regional_field_resource_graph(ctFieldsDist, pRscTree)
    local iSrcMapid = pRscTree:get_field_source()

    local tpFieldRscs = pRscTree:get_field_nodes()
    local rgiRscs = pRscTree:get_resources()

    local rgpTableValues
    local rgiMetaFields
    local rgiMetaRscs
    rgpTableValues, rgiMetaFields, rgiMetaRscs = create_model_quest_resource_graph(ctFieldsDist, iSrcMapid, tpFieldRscs, rgiRscs)

    local trgiFieldRscs = traverse_model_quest_resource_graph(rgpTableValues, rgiMetaFields, rgiMetaRscs)
    return trgiFieldRscs
end
