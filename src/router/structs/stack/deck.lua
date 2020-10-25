--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.stack.stage")
require("utils.struct.class")
require("utils.struct.mapstack")

CGraphDeckQuest = createClass({
    tpQuestStages = SMapStack:new(),
    tpPendingFroms = SMapStack:new()
})

function CGraphDeckQuest:init(rgpPoolProps)
    local m_tpQuestStages = self.tpQuestStages
    m_tpQuestStages:init(rgpPoolProps)

    local m_tpPendingFroms = self.tpPendingFroms
    m_tpPendingFroms:init(rgpPoolProps)

    for _, pQuestProp in ipairs(rgpPoolProps) do       -- this hubs stack for to-be-charted props
        m_tpPendingFroms:push(pQuestProp, {})
    end

    local pElementarStage = CGraphStageQuest:new()      -- for quests at base stage, points to token from
    self:_post_froms(pElementarStage, rgpPoolProps)
end

function CGraphDeckQuest:get_quest_stage(pQuestProp)
    local m_tpQuestStages = self.tpQuestStages
    return m_tpQuestStages:get_top(pQuestProp)
end

function CGraphDeckQuest:_append_quest_stage(pQuestProp, pQuestStage)
    local m_tpQuestStages = self.tpQuestStages
    m_tpQuestStages:push(pQuestProp, pQuestStage)

    local m_tpPendingFroms = self.tpPendingFroms
    m_tpPendingFroms:push(pQuestProp, {})
end

function CGraphDeckQuest:_pop_quest_stage(pQuestProp)
    local m_tpQuestStages = self.tpQuestStages
    m_tpQuestStages:pop(pQuestProp)

    local m_tpPendingFroms = self.tpPendingFroms
    m_tpPendingFroms:pop(pQuestProp)
end

function CGraphDeckQuest:_announce_froms(pQuestProp, pQuestStage)
    local m_tpPendingFroms = self.tpPendingFroms

    local rgpStagePendingFroms = m_tpPendingFroms:get_top(pQuestProp)
    local pFromStage = table.remove(rgpStagePendingFroms)

    pQuestStage:set_stage_from(pFromStage)
end

function CGraphDeckQuest:_post_froms(pQuestStage, rgpNeighborProps)
    local m_tpPendingFroms = self.tpPendingFroms

    for _, pNeighborProp in ipairs(rgpNeighborProps) do
        local rgpNeighborPendingFroms = m_tpPendingFroms:get_top(pNeighborProp)
        table.insert(rgpNeighborPendingFroms, pQuestStage)
    end
end

function CGraphDeckQuest:push_node(pQuestProp, rgpNeighborProps)
    local pQuestStage = CGraphStageQuest:new()
    pQuestStage:push_stage(pQuestProp, rgpNeighborProps)

    self:_announce_froms(pQuestProp, pQuestStage)
    self:_post_froms(pQuestStage, rgpNeighborProps)

    self:_append_quest_stage(pQuestProp, pQuestStage)
end

function CGraphDeckQuest:try_pop_node(pQuestProp)
    local pQuestStage = self:get_quest_stage(pQuestProp)
    if pQuestStage:try_pop_stage() then
        self:_pop_quest_stage(pQuestProp)
        return true
    else
        return false
    end
end
