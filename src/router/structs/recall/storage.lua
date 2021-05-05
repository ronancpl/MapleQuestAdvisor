--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")
local SSet = require("pl.Set")

CGraphMilestoneStorage = createClass({
    tStorage = {},
    iRunningOid = 1
})

local function make_subpath_set(rgpNeighbors)
    return SSet{unpack(rgpNeighbors)}
end

function CGraphMilestoneStorage:_insert(pInsNode, iIdx, rgpSearch, pSetSearch)
    local pSet = pSetSearch
    local nNeighbors = #rgpSearch

    local pCurNode = pInsNode
    for i = iIdx, nNeighbors, 1 do
        local pNeighbor = rgpSearch[i]

        local pNode = {}
        pCurNode[pNeighbor] = pNode

        pCurNode = pNode
    end

    local iRunningOid = self.iRunningOid
    pCurNode["ID"] = iRunningOid
    self.iRunningOid = iRunningOid + 1

    return pCurNode
end

function CGraphMilestoneStorage:_get_node(rgpNeighbors)
    local pSetSearch = make_subpath_set(rgpNeighbors)
    local rgpNeighborVals = SSet.values(pSetSearch)

    local pParentNode = self.tStorage
    local pCurNode

    local nNeighborVals = #rgpNeighborVals
    if nNeighborVals > 0 then
        local iEndIdx = nNeighborVals + 1
        for iIdx, pNeighbor in ipairs(rgpNeighborVals) do
            pCurNode = pParentNode[pNeighbor]
            if pCurNode == nil then
                iEndIdx = iIdx
                break
            end

            pParentNode = pCurNode
        end

        if iEndIdx <= nNeighborVals or not pParentNode["ID"] then
            pCurNode = self:_insert(pParentNode, iEndIdx, rgpNeighborVals, pSetSearch)
        else
            pCurNode = pParentNode
        end
    else
        pCurNode = self:_insert(pParentNode, 1, rgpNeighborVals, pSetSearch)
    end

    return pCurNode
end

function CGraphMilestoneStorage:get(rgpNeighbors)
    local pCurNode = self:_get_node(rgpNeighbors)
    return pCurNode["ID"]
end
