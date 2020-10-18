--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("structs.quest.properties")
require("utils.array")
require("utils.class")

CGraphStageQuest = createClass({
    pQuestProp,
    pStageFrom,
    rgpActiveNeighbors = SArray:new()
})

function CGraphStageQuest:_push_neighbors(rgpNeighbors)
    local m_rgpNeighbors = self.rgpActiveNeighbors
    m_rgpNeighbors:add_all(rgpNeighbors)
end

function CGraphStageQuest:push_stage(pQuestProp, rgpNeighbors)
    self.pQuestProp = pQuestProp
    self:_push_neighbors(rgpNeighbors)
end

function CGraphStageQuest:set_stage_from(pStageFrom)
    self.pStageFrom = pStageFrom
end

function CGraphStageQuest:remove_neighbor(pQuestProp)
    local fn_compare_active_neighbor = CQuestProperties.compare
    local iIdx = m_rgpActiveNeighbors:bsearch(fn_compare_active_neighbor, pQuestProp, false, true)
    if iIdx > 0 then
        m_rgpActiveNeighbors:remove(iIdx, iIdx)
    end
end

function CGraphStageQuest:_is_empty_active_neighbors()
    local m_rgpNeighbors = self.rgpActiveNeighbors
    return m_rgpNeighbors:size() == 0
end

function CGraphStageQuest:_pop_from()
    local m_pStageFrom = self.pStageFrom
    local m_pQuestProp = self.pQuestProp

    pStageFrom:remove_neighbor(m_pQuestProp)
end

function CGraphStageQuest:try_pop_stage()
    if self:_is_empty_active_neighbors() then
        self:_pop_from()
        return true
    else
        return false
    end
end
