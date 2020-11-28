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
    rgpQuestList = SBeltQueue:new()
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

    local pQuestProp = table.remove(rgpQuestsFetched)
    for _, pQuestPropToRetry in ipairs(rgpQuestsFetched) do
        m_rgpQuestList:push(pQuestPropToRetry)
    end

    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp, nil)
    self:_fetch_from_nodes(pQuestProp, rgpAccs)

    return pQuestProp
end
