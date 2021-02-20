--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

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

function CGraphDeckQuest:_create_quest_stage(pFromStage, pQuestProp)
    local pQuestStage = CGraphStageQuest:new()
    pQuestStage:set_stage_from(pFromStage)
    pQuestStage:push_stage(pQuestProp, {})

    return pQuestStage
end

function CGraphDeckQuest:get_quest_stage(pQuestProp)
    local m_tpQuestStages = self.tpQuestStages
    return m_tpQuestStages:get_top(pQuestProp)
end

function CGraphDeckQuest:_append_quest_stage(pQuestStage, pQuestProp, rgpNeighborProps)
    pQuestStage:push_stage(pQuestProp, rgpNeighborProps)

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

function CGraphDeckQuest:_create_neighbor_quest_stages(pQuestStage, rgpNeighborProps)
    local rgpNeighborStages = {}
    for _, pNeighborProp in ipairs(rgpNeighborProps) do
        local pNeighborStage = self:_create_quest_stage(pQuestStage, pNeighborProp)
        table.insert(rgpNeighborStages, pNeighborStage)
    end

    return rgpNeighborStages
end

function CGraphDeckQuest:push_node(pQuestStage, pQuestProp, rgpNeighborProps)
    self:_append_quest_stage(pQuestStage, pQuestProp, rgpNeighborProps)

    local rgpNeighborStages = self:_create_neighbor_quest_stages(pQuestStage, rgpNeighborProps)
    return rgpNeighborStages
end

function CGraphDeckQuest:try_pop_node(pQuestStage)
    local pQuestProp = pQuestStage:get_quest_prop()

    if pQuestStage:try_pop_stage() then
        self:_pop_quest_stage(pQuestProp)
        return true
    else
        return false
    end
end

function CGraphDeckQuest:debug_tree_deck_builder(rgpPath)
    local nPath = #rgpPath

    for i = math.max(1, nPath - 5), nPath, 1 do
        local pQuestProp = rgpPath[i]

        local m_tpQuestStages = self.tpQuestStages
        local pQuestStage = m_tpQuestStages:get_top(pQuestProp)
        local nQuestDeckLen = m_tpQuestStages:get_size(pQuestProp)

        if nQuestDeckLen > 0 then
            local st = pQuestProp:get_name(true) .. " deck lv: " .. nQuestDeckLen .. " -> ["
            for k, pNeighborProp in pairs(pQuestStage:get_active_neighbors()) do
                st = st .. pNeighborProp:get_name(true) .. ", "
            end
            st = st .. "]"
            print(st)
        end
    end
end

function CGraphDeckQuest:init(rgpPoolProps)
    local m_tpQuestStages = self.tpQuestStages
    m_tpQuestStages:init(rgpPoolProps)

    local m_tpPendingFroms = self.tpPendingFroms
    m_tpPendingFroms:init(rgpPoolProps)

    local pElementarStage = CGraphStageQuest:new()      -- for quests at base stage, points to token from

    local rgpPoolStages = {}
    for _, pQuestProp in ipairs(rgpPoolProps) do        -- this hubs stack for to-be-charted props
        m_tpPendingFroms:push(pQuestProp, {})

        local pQuestStage = self:_create_quest_stage(pFromStage, pQuestProp)
        pQuestStage:set_stage_from(pElementarStage)

        table.insert(rgpPoolStages, pQuestStage)
    end

    return rgpPoolStages
end
