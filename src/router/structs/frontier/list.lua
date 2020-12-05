--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.constant")
require("utils.struct.belt")
require("utils.struct.class")
require("utils.struct.stack")

CQuestFrontierQuestList = createClass({
    pQuestStack = SBeltStack:new(),
    pExploredQuests = SStack:new(),
    tpQuests = {}
})

function CQuestFrontierQuestList:add(pQuestProp)
    local m_pQuestStack = self.pQuestStack
    m_pQuestStack:push(pQuestProp)

    local m_tpQuests = self.tpQuests
    m_tpQuests[pQuestProp] = (m_tpQuests[pQuestProp] or 0) + 1
end

function CQuestFrontierQuestList:contains(pQuestProp)
    local m_tpQuests = self.tpQuests
    return m_tpQuests[pQuestProp] ~= nil
end

function CQuestFrontierQuestList:peek()
    local m_pQuestStack = self.pQuestStack
    local pQuestProp = m_pQuestStack:peek()

    return pQuestProp
end

function CQuestFrontierQuestList:fetch(pQuestTree, iQuestCount)
    local m_pQuestStack = self.pQuestStack
    local m_pExploredQuests = self.pExploredQuests

    local rgpQuestsExplored = m_pQuestStack:export(U_INT_MAX)       -- removes all quests already explored on belt
    m_pExploredQuests:push_all(rgpQuestsExplored)

    local rgpQuestsFetched = m_pExploredQuests:export(iQuestCount)    -- returns backtracked quests from the present tree frame

    local iUndertowCount = 0
    for _, pQuestProp in ipairs(rgpQuestsFetched) do
        local iResolvedCount = pQuestTree:get_from_count(pQuestProp)
        iUndertowCount = iUndertowCount + (iResolvedCount - 1)

        local m_tpQuests = self.tpQuests
        local iRemainingCount = m_tpQuests[pQuestProp]
        if iRemainingCount ~= nil then
            if iRemainingCount > iResolvedCount then
                m_tpQuests[pQuestProp] = iRemainingCount - iResolvedCount
            else
                m_tpQuests[pQuestProp] = nil
            end
        end
    end

    if iUndertowCount > 0 then
        for i = 1, iUndertowCount, 1 do     -- to seek further the frontier (readded neighbors in routing)
            local pQuestProp = self:peek()
            table.insert(rgpQuestsFetched, pQuestProp)
        end
        m_pExploredQuests:export(iUndertowCount)
    end

    return rgpQuestsFetched
end
