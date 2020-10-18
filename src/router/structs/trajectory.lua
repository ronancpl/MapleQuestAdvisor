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
require("router.structs.stack.deck")
require("utils.struct.table")

CGraphTree = createClass({CQuestPath, {
    pDeck = CGraphDeckQuest:new()
}})

function CGraphTree:install_entries(rgpQuestProps)
    local m_pDeck = self.pDeck
    m_pDeck:init(rgpQuestProps)
end

function CGraphTree:push_node(pQuestProp, rgpNeighbors)
    self:add(pQuestProp)

    local m_pDeck = self.pDeck
    m_pDeck:push_node(pQuestProp, rgpNeighbors)
end

function CGraphTree:try_pop_node()
    local m_rgpPath = self.rgpPath
    local pQuestProp = m_rgpPath:get_last()

    local m_pDeck = self.pDeck
    if m_pDeck:try_pop_node(pQuestProp) then
        m_rgpPath:remove_last()
        return pQuestProp
    else
        return nil
    end
end
