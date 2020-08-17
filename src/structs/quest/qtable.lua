--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils/array");
require("utils/class");
require("router/filters/graph");

CQuestTable = createClass({
    rgQuestsData
})

function CQuestTable:init_quest_table()
    self.rgQuestsData = SArray:new()
end

function CQuestTable:add_quest_data(pQuest)
    local m_rgQuestsData = self.rgQuestsData
    m_rgQuestsData:add(pQuest)
end

function CQuestTable:remove_quest_data(iIdx, iNumQuests)
    local m_rgQuestsData = self.rgQuestsData
    rgRemovedQuestsData = m_rgQuestsData:remove(iIdx, iIdx + iNumQuests)

    return rgRemovedQuestsData
end

function CQuestTable:randomize_quest_table()
    local m_rgQuestsData = self.rgQuestsData
    m_rgQuestsData:randomize()
end

function CQuestTable:sort_quest_table()
    local m_rgQuestsData = self.rgQuestsData

    m_rgQuestsData:sort(
        function(a,b)
            a.get_quest_id() < b.get_quest_id()
        end
    )
end

local fn_compare_quest_level = function(pQuest, iLevel)
    return pQuest:get_quest_id() - iLevel
end

local function CQuestTable:ignore_quests_from_level(iLevel)
    local m_rgQuestsData = self.rgQuestsData

    local i = CQuest:bsearch(fn_compare_quest_level, iLevel, true, false)
    if i > 0 then
        m_rgQuestsData:remove(1, i)
    end
end

local function CQuestTable:fetch_top_quests_by_level(iLevel, nNumQuests)
    local iIdx = SArray:bsearch(fn_compare_quest_level, iLevel, true, true)
    local rgPoolQuests = qtQuests:remove(iIdx, nNumQuests)  -- pick top quests from overall table

    return rgPoolQuests
end

function CQuestTable:ignore_underleveled_quests(iLevel)
    ignore_quests_from_level(iLevel - RGraph.POOL_BEHIND_QUEST_LEVEL)
end

function CQuestTable:fetch_required_quests(iLevel)
    rgPoolQuests = SArray:new()
    local rgFrontierQuests = fetch_top_quests_by_level(iLevel + RGraph.POOL_AHEAD_QUEST_LEVEL, RGraph.POOL_MIN_QUESTS)

    while ~rgFrontierQuests:is_empty() do
        pQuest = rgFrontierQuests:remove_last()
        rgPoolQuests:add(pQuest)

        for _, pPreQuest in ipairs(pQuest:GET_REQUIREMENTS) do
            if (HAS SUBQUEST STATUS > 0) then
                rgFrontierQuests:add(pPreQuest)
            end
        end
    end

    return rgPoolQuests
end
