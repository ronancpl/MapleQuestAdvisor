--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.path")
require("utils.table")

CGraphTree = createClass({CQuestPath, {
    tpActiveNeighbors = {},
    tpActiveFroms = {}
}})

function CGraphTree:_push_from(pQuestProp, rgpNeighbors)
    local m_tpActiveFroms = self.tpActiveFroms

    for _, pNeighborProp in ipairs(rgpNeighbors) do
        local pNeighborFroms = m_tpActiveFroms[pNeighborProp]
        if pNeighborFroms == nil then
            pNeighborFroms = {}
            m_tpActiveFroms[pNeighborProp] = pNeighborFroms
        end

        table.insert(pNeighborFroms, pQuestProp)
    end
end

function CGraphTree:_push_neighbors(pQuestProp, rgpNeighbors)
    local rgpNeighborsCopy = SArray:new()
    rgpNeighborsCopy:add_all(rgpNeighbors)
    self.tpActiveNeighbors[pQuestProp] = rgpNeighborsCopy
end

function CGraphTree:push_node(pQuestProp, rgpNeighbors)
    self:add(pQuestProp)

    self:_push_neighbors(pQuestProp, rgpNeighbors)
    self:_push_from(pQuestProp, rgpNeighbors)
end

function CGraphTree:_is_empty_active_neighbors(pQuestProp)
    local rgpNeighbors = self.tpActiveNeighbors[pQuestProp]
    return #rgpNeighbors == 0
end

local function fn_value_start_property(pQuestProp)
    return pQuestProp:is_start() and 0 or 1
end

local function fn_compare_active_neighbor(pQuestProp, pOtherProp)
    local iQuestidDiff = pQuestProp:get_quest_id() - pOtherProp:get_quest_id()
    local iStartDiff = fn_value_start_property(pQuestProp) - fn_value_start_property(pOtherProp)

    return 2 * iQuestidDiff + iStartDiff
end

function CGraphTree:_pop_from(pQuestProp)
    local rgpFroms = self.tpActiveFroms[pQuestProp]
    if rgpFroms ~= nil then
        self.tpActiveFroms[pQuestProp] = nil

        for _, pFromProp in ipairs(rgpFroms) do
            local rgFromActiveNeighbors = self.tpActiveNeighbors[pFromProp]

            local iIdx = rgFromActiveNeighbors:bsearch(fn_compare_active_neighbor, pQuestProp, false, true)
            if iIdx > 0 then
                rgFromActiveNeighbors:remove(iIdx, iIdx)
            end
        end
    end
end

function CGraphTree:try_pop_node()
    local m_rgpPath = self.rgpPath
    local pQuestProp = m_rgpPath:get_last()

    if self:_is_empty_active_neighbors(pQuestProp) then
        m_rgpPath:remove_last()
        self:_pop_from(pQuestProp)

        return pQuestProp
    else
        return nil
    end
end
