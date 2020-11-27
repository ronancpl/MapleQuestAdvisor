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

function CQuestFrontierQuestList:add(pItem)
    local m_rgpQuestList = self.rgpQuestList
    m_rgpQuestList:push(pItem)
end

function CQuestFrontierQuestList:peek()
    local m_rgpQuestList = self.rgpQuestList
    local pCurQuestProp = m_rgpQuestList:peek()

    while true do
        if pCurQuestProp == nil then
            break
        end

        local st = ""
        for k, v in pairs(m_rgpQuestList) do
            st = st .. v:get_quest_id() .. ", "
        end

        local pQuestProp = nil
        local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pCurQuestProp, nil)
        if self:_should_fetch_quest(pCurQuestProp, rgpAccs) then
            pQuestProp = pCurQuestProp
            break
        end
    end

    return pQuestProp
end

function CQuestFrontierQuestList:fetch()
    local m_rgpQuestList = self.rgpQuestList

    local rgpQuestsFetched = m_rgpQuestList:export()     -- removes all quests already fetched
    local pQuestProp = rgpQuestsFetched[#rgpQuestsFetched]

    local rgpAccs = ctAccessors:get_accessors_by_active_requirements(pQuestProp, nil)
    self:_fetch_from_nodes(pQuestProp, rgpAccs)

    return pQuestProp
end
