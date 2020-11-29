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

CQuestFrontierQuestList = createClass({
    rgpQuestList = SBeltStack:new()
})

function CQuestFrontierQuestList:add(pQuestProp)
    local m_rgpQuestList = self.rgpQuestList
    m_rgpQuestList:push(pQuestProp)
end

function CQuestFrontierQuestList:peek()
    local m_rgpQuestList = self.rgpQuestList

    local pQuestProp = m_rgpQuestList:peek()
    return pQuestProp
end

function CQuestFrontierQuestList:fetch()
    local m_rgpQuestList = self.rgpQuestList

    local rgpQuestsFetched = m_rgpQuestList:export()     -- removes all quests already fetched

    local pQuestProp = rgpQuestsFetched[#rgpQuestsFetched]
    return pQuestProp
end
