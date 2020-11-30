--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.belt")
require("utils.struct.class")
local SSet = require("pl.class").Set

CQuestFrontierQuestList = createClass({
    rgpQuestList = SBeltStack:new(),
    pQuestsSet = SSet{}
})

function CQuestFrontierQuestList:add(pQuestProp)
    local m_rgpQuestList = self.rgpQuestList
    m_rgpQuestList:push(pQuestProp)

    self.pQuestsSet = self.pQuestsSet + SSet{pQuestProp}
end

function CQuestFrontierQuestList:contains(pQuestProp)
    return SSet{pQuestProp}:issubset(self.pQuestsSet)
end

function CQuestFrontierQuestList:peek()
    local m_rgpQuestList = self.rgpQuestList

    local pQuestProp = m_rgpQuestList:peek()
    self.pQuestsSet = self.pQuestsSet - SSet{pQuestProp}
    return pQuestProp
end

function CQuestFrontierQuestList:fetch(iQuestCount)
    local m_rgpQuestList = self.rgpQuestList

    local rgpQuestsFetched = m_rgpQuestList:export(iQuestCount)     -- removes all quests already fetched
    return rgpQuestsFetched
end
