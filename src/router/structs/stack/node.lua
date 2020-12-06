--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana
    GNU General Public License v3.0
    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.stack.deck")
require("utils.struct.class")

CGraphDeckNode = createClass({
    tDecks = {},
    iCur = 1
})

function CGraphDeckNode:append(pQuestStage)
    table.insert(self.tDecks, pQuestStage)
end

function CGraphDeckNode:get()
    local m_tDecks = self.tDecks
    local iCur = self.iCur

    local pQuestStage = m_tDecks[iCur]
    self.iCur = ((iCur) % #m_tDecks) + 1

    return pQuestStage
end
