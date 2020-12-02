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
    rgpQuestList = SBeltStack:new(),
    tpQuests = {}
})

function CQuestFrontierQuestList:add(pQuestProp)
    local m_rgpQuestList = self.rgpQuestList
    m_rgpQuestList:push(pQuestProp)

    local m_tpQuests = self.tpQuests
    m_tpQuests[pQuestProp] = (m_tpQuests[pQuestProp] or 0) + 1
end

function CQuestFrontierQuestList:contains(pQuestProp)
    local m_rgpQuestList = self.rgpQuestList
    return m_rgpQuestList[pQuestProp] ~= nil
end

function CQuestFrontierQuestList:peek()
    local m_rgpQuestList = self.rgpQuestList
    local pQuestProp = m_rgpQuestList:peek()

    return pQuestProp
end

function CQuestFrontierQuestList:fetch(iQuestCount)
    local m_rgpQuestList = self.rgpQuestList

    local rgpQuestsFetched = m_rgpQuestList:export(iQuestCount)     -- removes all quests already fetched

    for _, pQuestProp in ipairs(rgpQuestsFetched) do
        local m_tpQuests = self.tpQuests
        if m_tpQuests[pQuestProp] > 1 then
            m_tpQuests[pQuestProp] = m_tpQuests[pQuestProp] - 1
        else
            m_tpQuests[pQuestProp] = nil
        end
    end

    return rgpQuestsFetched
end
