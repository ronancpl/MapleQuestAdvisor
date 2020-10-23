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
    tStorage = {}
})

local function make_subpath_set(rgpNeighbors)
    return SSet{unpack(rgpNeighbors)}
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

    pCurNode["SET"] = pSet
    return pCurNode
end

local function fn_storage_sort(a, b)
    return a:get_quest_id() < b:get_quest_id()
end

function CGraphMilestoneStorage:get(rgpNeighbors)
    local pParentNode = self.tStorage
    if #rgpNeighbors > 0 then
        local pCurNode = nil

        local rgpSearch = rgpNeighbors
        local pSearchSet = make_subpath_set(rgpNeighbors)

        for iIdx, pNeighbor in ipairs(rgpNeighbors) do
            pCurNode = pParentNode[pNeighbor]
            if pCurNode == nil then
                pCurNode = self:_insert(pParentNode, iIdx, rgpSearch, pSearchSet)
                break
            end

            pParentNode = pCurNode
        end

        local pSearchSet = pCurNode["SET"]
        if pSearchSet == nil then
            pSearchSet = make_subpath_set(rgpNeighbors)
            pCurNode["SET"] = pSearchSet
        end

        return pSearchSet
    else
        local pSearchSet = pParentNode["SET"]
        if pSearchSet == nil then
            pSearchSet = make_subpath_set(rgpNeighbors)
            pParentNode["SET"] = pSearchSet
        end

        return pSearchSet
    end
end
