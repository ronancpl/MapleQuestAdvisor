--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")
local SSet = require("pl.class").Set

CGraphMilestoneStorage = createClass({
    tStorage = {},
    iRunningId = 0
})

local function make_subpath_set(rgpNeighbors)
    return SSet{unpack(rgpNeighbors)}
end

function CGraphMilestoneStorage:_get_and_inc_path_id()
    self.iRunningId = self.iRunningId + 1
    return self.iRunningId
end

function CGraphMilestoneStorage:_insert(pInsNode, iIdx, rgpSearch, pSearchSet)
    local pSet = pSearchSet
    local nNeighbors = #rgpSearch

    local pCurNode = pInsNode
    for i = iIdx, nNeighbors, 1 do
        local pNeighbor = rgpSearch[i]

        local pNode = {}
        pCurNode[pNeighbor] = pNode

        pCurNode = pNode
    end

    pCurNode["node"] = self:_get_and_inc_path_id()
    return pCurNode
end

local function fn_storage_sort(a, b)
    return a:get_quest_id() < b:get_quest_id()
end

function CGraphMilestoneStorage:_get_node(rgpNeighbors)
    local pSearchSet = make_subpath_set(rgpNeighbors)
    local rgpNeighborVals = pSearchSet:values()
    local nNeighborVals = #rgpNeighborVals

    local pParentNode = self.tStorage
    local pCurNode

    local iEndIdx = nNeighborVals + 1
    for iIdx, pNeighbor in ipairs(rgpNeighborVals) do
        local pCurNode = pParentNode[pNeighbor]
        if pCurNode == nil then
            iEndIdx = iIdx
            break
        end

        pParentNode = pCurNode
    end

    pCurNode = pParentNode
    if iEndIdx <= nNeighborVals or pCurNode["node"] == nil then
        pCurNode = self:_insert(pCurNode, iEndIdx, rgpNeighborVals, pSearchSet)
    end

    return pCurNode
end

function CGraphMilestoneStorage:get(rgpNeighbors)
    local pCurNode = self:_get_node(rgpNeighbors)
    return pCurNode["node"]
end
