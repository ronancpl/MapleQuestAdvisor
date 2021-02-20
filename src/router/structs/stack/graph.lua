--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.stack.deck")
require("router.structs.stack.node")
require("utils.struct.class")

CGraphDeckArranger = createClass({
    tQuestDecks = {},
    pDeckBuilder = CGraphDeckQuest:new()
})

function CGraphDeckArranger:_fetch_quest_deck_node(pQuestProp)
    local m_tQuestDecks = self.tQuestDecks

    local pQuestDeckNode = m_tQuestDecks[pQuestProp]
    if pQuestDeckNode == nil then
        pQuestDeckNode = {}
        m_tQuestDecks[pQuestProp] = pQuestDeckNode
    end

    return pQuestDeckNode
end

function CGraphDeckArranger:_propagate_quest_deck(pQuestDeckItem, iStPathLen, iCurPathLen)
    local pQuestStageFirst = pQuestDeckItem:get()
    local pQuestProp = pQuestStageFirst:get_quest_prop()

    for i = iStPathLen, iCurPathLen, 1 do
        local pQuestStageNext = pQuestStageFirst
        while true do
            local rgpNeighborProps = pQuestStageNext:get_active_neighbors()
            self:push_node(pQuestProp, i, rgpNeighborProps)

            pQuestStageNext = pQuestDeckItem:get()
            if pQuestStageFirst == pQuestStageNext then
                break
            end
        end
    end
end

function CGraphDeckArranger:_get_quest_deck(pQuestProp, iCurPathLen)
    local pQuestDeckNode = self:_fetch_quest_deck_node(pQuestProp)
    local pQuestDeckItem

    local iIdxDeck = 1
    for i = iCurPathLen, 1, -1 do
        pQuestDeckItem = pQuestDeckNode[i]
        if pQuestDeckItem ~= nil then
            iIdxDeck = i
            break
        end
    end

    self:_propagate_quest_deck(pQuestDeckItem, iIdxDeck + 1, iCurPathLen)

    return pQuestDeckItem:get()
end

function CGraphDeckArranger:_set_quest_deck(pQuestProp, iCurPathLen, pQuestStage)
    local pQuestDeckNode = self:_fetch_quest_deck_node(pQuestProp)

    local pQuestDeckItem = pQuestDeckNode[iCurPathLen]
    if pQuestDeckItem == nil then
        pQuestDeckItem = CGraphDeckNode:new()
        pQuestDeckNode[iCurPathLen] = pQuestDeckItem
    end

    pQuestDeckItem:append(pQuestStage)
end

function CGraphDeckArranger:_find_quest_deck(pQuestProp, iCurPathLen)
    local pQuestStage = self:_get_quest_deck(pQuestProp, iCurPathLen)
    return pQuestStage
end

function CGraphDeckArranger:get_quest_stage(pQuestProp, iCurPathLen)
    local m_pDeckBuilder = self.pDeckBuilder

    local pQuestStage = self:_find_quest_deck(pQuestProp, iCurPathLen)
    return pQuestStage
end

function CGraphDeckArranger:_add_neighbor_decks(iCurPathLen, rgpNeighborStages)
    local iNextPathLen = iCurPathLen + 1
    for _, pNeighborStage in ipairs(rgpNeighborStages) do
        self:_set_quest_deck(pNeighborStage:get_quest_prop(), iNextPathLen, pNeighborStage)
    end
end

function CGraphDeckArranger:push_node(pQuestProp, iCurPathLen, rgpNeighborProps)
    local m_pDeckBuilder = self.pDeckBuilder

    local pQuestDeckNode = self:_fetch_quest_deck_node(pQuestProp)
    local pQuestDeckItem = pQuestDeckNode[iCurPathLen]
    if pQuestDeckItem ~= nil then
        local pQuestStage = pQuestDeckItem:get()

        local rgpNeighborStages = m_pDeckBuilder:push_node(pQuestStage, pQuestProp, rgpNeighborProps)
        self:_add_neighbor_decks(iCurPathLen, rgpNeighborStages)
    end
end

function CGraphDeckArranger:try_pop_node(pQuestProp, iCurPathLen)
    local m_pDeckBuilder = self.pDeckBuilder

    local pQuestStage = self:_find_quest_deck(pQuestProp, iCurPathLen)
    local bRet = m_pDeckBuilder:try_pop_node(pQuestStage)

    return bRet
end

function CGraphDeckArranger:debug_tree_deck(rgpPath)
    local m_pDeckBuilder = self.pDeckBuilder
    m_pDeckBuilder:debug_tree_deck_builder(rgpPath)
end

function CGraphDeckArranger:_init_stages(rgpPoolStages)
    for _, pQuestStage in ipairs(rgpPoolStages) do
        local pQuestProp = pQuestStage:get_quest_prop()
        self:_set_quest_deck(pQuestProp, 1, pQuestStage)
    end
end

function CGraphDeckArranger:init(rgpPoolProps)
    local m_pDeckBuilder = self.pDeckBuilder

    local rgpPoolStages = m_pDeckBuilder:init(rgpPoolProps)
    self:_init_stages(rgpPoolStages)
end
