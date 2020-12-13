--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.assignment.procedures.solve")

local function make_model_row_values(nCols, rgiFieldCols, iRscCost)
    local rgiRowValues = {}

    for i = 1, nCols, 1 do
        rgiRowValues[i] = 0
    end

    for _, iCol in ipairs(rgiFieldCols) do
        rgiRowValues[iCol] = iRscCost
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
        local rgiFieldCols = {}
        for _, iRsc in pairs(pResource:get_resources():values()) do
            local iRscIdx = tiRscIdxs[iRsc]
            table.insert(rgiFieldCols, iRscIdx)
        end

        local iRscCost = ctFieldsDist:get_field_distance(iSrcMapid, iMapid)
        local rgiRowValues = make_model_row_values(nCols, rgiFieldCols, iRscCost)
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

function fetch_field_scope_quest_resource_graph(ctFieldsDist, pRscTree)
    local iSrcMapid = pRscTree:get_field_source()

    local tpFieldRscs = pRscTree:get_field_nodes()
    local rgiRscs = pRscTree:get_resources():values()

    local rgpTableValues
    local rgiMetaFields
    local rgiMetaRscs
    rgpTableValues, rgiMetaFields, rgiMetaRscs = create_model_quest_resource_graph(ctFieldsDist, iSrcMapid, tpFieldRscs, rgiRscs)

    local trgiFieldRscs = traverse_model_quest_resource_graph(rgpTableValues, rgiMetaFields, rgiMetaRscs)
    return trgiFieldRscs
end
