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
require("utils.procedure.iterate")
require("utils.struct.array")
require("utils.struct.class")

CGraphStageQuest = createClass({
    pQuestProp,
    pStageFrom,
    rgpNeighbors = SArray:new(),
    rgpActiveNeighbors = SArray:new()
})

function CGraphStageQuest:get_quest_prop()
    return self.pQuestProp
end

function CGraphStageQuest:get_active_neighbors()
    return self.rgpActiveNeighbors:list()
end

function CGraphStageQuest:set_stage_from(pStageFrom)
    self.pStageFrom = pStageFrom
end

function CGraphStageQuest:_push_neighbors(rgpNeighbors)
    local m_rgpNeighbors = self.rgpNeighbors

    m_rgpNeighbors:remove_all()
    for _, pNeighborProp in rpairs(rgpNeighbors) do
        m_rgpNeighbors:add(pNeighborProp)
    end

    local m_rgpActiveNeighbors = self.rgpActiveNeighbors
    m_rgpActiveNeighbors:remove_all()
    m_rgpActiveNeighbors:add_all(m_rgpNeighbors)
end

function CGraphStageQuest:push_stage(pQuestProp, rgpNeighbors)
    self.pQuestProp = pQuestProp
    self:_push_neighbors(rgpNeighbors)
end

function CGraphStageQuest:remove_neighbor(pQuestProp)
    local m_rgpActiveNeighbors = self.rgpActiveNeighbors
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

    m_pStageFrom:remove_neighbor(m_pQuestProp)
end

function CGraphStageQuest:try_pop_stage()
    if self:_is_empty_active_neighbors() then
        self:_pop_from()
        return true
    else
        return false
    end
end
