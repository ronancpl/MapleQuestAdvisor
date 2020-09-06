--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.graph");
require("utils.array");
require("utils.class");

CQuestTable = createClass({
    rgQuests = SArray:new()
})

function CQuestTable:add_quest(pQuest)
    local m_rgQuests = self.rgQuests
    m_rgQuests:add(pQuest)
end

function CQuestTable:remove_quest(iIdx, iNumQuests)
    local m_rgQuests = self.rgQuests
    local rgRemovedQuests = m_rgQuests:remove(iIdx, iIdx + iNumQuests)

    return rgRemovedQuests
end

function CQuestTable:randomize_quest_table()
    local m_rgQuests = self.rgQuests
    m_rgQuests:randomize()
end

function CQuestTable:sort_quest_table()
    local m_rgQuests = self.rgQuests

    m_rgQuests:sort(
        function(a,b)
            return a.get_quest_id() < b.get_quest_id()
        end
    )
end

local fn_compare_quest_level = function(pQuest, iLevel)
    return pQuest:get_quest_id() - iLevel
end

function CQuestTable:_ignore_quests_from_level(iLevel)
    local m_rgQuests = self.rgQuests

    local i = m_rgQuests:bsearch(fn_compare_quest_level, iLevel, true, false)
    if i > 0 then
        m_rgQuests:remove(1, i)
    end
end

function CQuestTable:_fetch_top_quests_by_level(iLevel, nNumQuests)
    local m_rgQuests = self.rgQuests

    local iIdx = m_rgQuests:bsearch(fn_compare_quest_level, iLevel, true, true)
    local rgPoolQuests = m_rgQuests:remove(iIdx, nNumQuests)  -- pick top quests from overall table

    return rgPoolQuests
end

function CQuestTable:ignore_underleveled_quests(iLevel)
    self:_ignore_quests_from_level(iLevel - RGraph.POOL_BEHIND_QUEST_LEVEL)
end

function CQuestTable:fetch_required_quests(iLevel)
    local rgPoolQuests = SArray:new()

    --[[
    local rgFrontierQuests = self:_fetch_top_quests_by_level(iLevel + RGraph.POOL_AHEAD_QUEST_LEVEL, RGraph.POOL_MIN_QUESTS)

    while not rgFrontierQuests:is_empty() do
        local pQuest = rgFrontierQuests:remove_last()
        rgPoolQuests:add(pQuest)

        for _, pPreQuest in ipairs(pQuest:GET_REQUIREMENTS) do
            if (HAS SUBQUEST STATUS > 0) then
                rgFrontierQuests:add(pPreQuest)
            end
        end
    end
    --]]

    return rgPoolQuests
end
