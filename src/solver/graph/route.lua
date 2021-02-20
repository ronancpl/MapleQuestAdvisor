--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("solver.graph.tree.constant")
require("utils.procedure.unpack")
require("utils.struct.priority_queue")
local SSet = require("pl.class").Set

local function get_field_priority(iVal)
    return U_INT_MAX - iVal
end

local function mst_model_quest_resource(ctFieldsDist, rgiMapids, iSrcMapid)
    local tpFrom = {}     -- finds minimum spanning tree
    for _, iMapid in ipairs(rgiMapids) do
        tpFrom[iMapid] = {-1, U_INT_MAX, 0}
    end
    tpFrom[iSrcMapid] = {-1, 0, 0}

    local pQueueFrontierFields = SPriorityQueue:new()
    pQueueFrontierFields:put(iSrcMapid, 0)

    local pSetToExplore = SSet{unpack(rgiMapids)}

    while pSetToExplore:len() > 0 do
        local iCurMapid = pQueueFrontierFields:pop()
        pSetToExplore = pSetToExplore - SSet{iCurMapid}

        local rgiNextMapids = {}
        for _, iMapid in ipairs(rgiMapids) do
            local pSetMapid = SSet{iMapid}
            if pSetMapid:issubset(pSetToExplore) then
                table.insert(rgiNextMapids, iMapid)
            end
        end

        local pCurFrom = tpFrom[iCurMapid]
        for _, iNeighborMapid in ipairs(rgiNextMapids) do
            local iDist = ctFieldsDist:get_field_distance(iCurMapid, iNeighborMapid)

            local pFrom = tpFrom[iNeighborMapid]
            local iPathDist = pCurFrom[2] + iDist
            if iPathDist < pFrom[2] then
                pFrom[1] = iCurMapid
                pFrom[2] = iPathDist
                pFrom[3] = iDist
            end

            pQueueFrontierFields:put(iNeighborMapid, get_field_priority(iDist))
        end
    end

    return tpFrom
end

local function calc_distance_model_quest_resource(ctFieldsDist, trgiFieldRscs, iSrcMapid, iDestMapid)
    local rgiMapids = keys(trgiFieldRscs)

    if trgiFieldRscs[iSrcMapid] == nil then
        table.insert(rgiMapids, iSrcMapid)
    end

    local tpMstPath = mst_model_quest_resource(ctFieldsDist, rgiMapids, iSrcMapid)

    local iMstDist = 0
    for _, pFrom in pairs(tpMstPath) do
        iMstDist = iMstDist + pFrom[3]
    end

    return iMstDist
end

local function evaluate_regions_quest_resource_graph(ctFieldsDist, pRscTree, trgiFieldRscs, pQueueRegionRscTree)
    local iExamineCount = math.min(pQueueRegionRscTree:size(), RQuestResource.DISTANCE_EXAMINE_REGION_COUNT)

    local iDist = 0
    for i = 1, iExamineCount, 1 do
        local pRscRegionTree = pQueueRegionRscTree:pop()

        local iRegionSrcMapid = pRscRegionTree:get_field_source()
        local iRegionDestMapid = pRscRegionTree:get_field_destination()

        iDist = iDist + calc_distance_model_quest_resource(ctFieldsDist, trgiFieldRscs, iRegionSrcMapid, iRegionDestMapid)
    end

    local iSrcMapid = pRscTree:get_field_source()
    local iDestMapid = pRscTree:get_field_destination()
    iDist = iDist + ctFieldsDist:get_field_distance(iSrcMapid, iDestMapid)

    -- an estimative of reaching resource fields in the top 2 region + the quest's overall wire-to-wire field distance
    return iDist
end

function evaluate_regional_field_resource_graph(ctFieldsDist, pRscTree, trgiFieldRscs)
    local pQueueRegionRscTree = SPriorityQueue:new()
    pQueueRegionRscTree:put(pRscTree, pRscTree:get_num_resources())

    local iDist = evaluate_regions_quest_resource_graph(ctFieldsDist, pRscTree, trgiFieldRscs, pQueueRegionRscTree)
    return iDist
end
