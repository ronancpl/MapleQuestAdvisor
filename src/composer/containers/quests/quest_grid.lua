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
require("structs.quest.quest")
require("utils.array");
require("utils.constants");
require("utils.class");
require("utils.print");

CQuestGrid = createClass({
    rgQuests = SArray:new()
})

function CQuestGrid:add_quest(pQuest)
    local m_rgQuests = self.rgQuests
    m_rgQuests:add(pQuest)
end

function CQuestGrid:remove_quest(iIdx, nNumQuests)
    local m_rgQuests = self.rgQuests
    local rgRemovedQuests = m_rgQuests:remove(iIdx, iIdx + nNumQuests - 1)

    return rgRemovedQuests
end

function CQuestGrid:randomize_quest_table()
    local m_rgQuests = self.rgQuests
    m_rgQuests:randomize()
end

function CQuestGrid:sort_quest_table()
    local m_rgQuests = self.rgQuests
    local fn_compare_quest_level = function (a,b) return m_rgQuests:get(a):get_starting_level() > m_rgQuests:get(b):get_starting_level() end
    m_rgQuests:sort(fn_compare_quest_level)
end

function CQuestGrid:new(ctQuests)
    for _, pQuest in pairs(ctQuests:get_quests()) do
        self:add_quest(pQuest)
    end

    self:sort_quest_table()
    return self
end

local fn_compare_quest_level = function(pQuest, iLevel)
    return iLevel - pQuest:get_starting_level()
end

function CQuestGrid:_ignore_quests_from_level(iLevel)
    local m_rgQuests = self.rgQuests

    local i = m_rgQuests:bsearch(fn_compare_quest_level, iLevel, true, true)
    if i > 0 then
        m_rgQuests:remove(i)
    end
end

function CQuestGrid:_search_prequests_in_tab(tQuests, fn_filter_quests, pQuest, fn_quest_tab, pPlayer, iExpectedStatus)
    local pQuestTab = fn_quest_tab(pQuest)

    for iPreQuestId, iStatus in pairs(pQuestTab:get_requirement():get_quests():get_items()) do
        if iStatus >= iExpectedStatus then
            local pPreQuest = ctQuests:get_quest_by_id(iPreQuestId)
            self:_add_quest_if_eligible(tQuests, fn_filter_quests, pPreQuest, pPlayer, iStatus)
        end
    end
end

--
function CQuestGrid:_search_prequests(tQuests, fn_filter_quests, pQuest, pPlayer, iExpectedStatus)
    self:_search_prequests_in_tab(tQuests, fn_filter_quests, pQuest, CQuest.get_start, pPlayer, iExpectedStatus)
    self:_search_prequests_in_tab(tQuests, fn_filter_quests, pQuest, CQuest.get_end, pPlayer, iExpectedStatus)
end

function CQuestGrid:_add_quest_if_eligible(tQuests, fn_filter_quests, pQuest, pPlayer, iExpectedStatus)
    if fn_filter_quests(pQuest, pPlayer) then
        tQuests[pQuest] = 1
        self:_search_prequests(tQuests, fn_filter_quests, pQuest, pPlayer, iExpectedStatus)
    end
end

function CQuestGrid:_try_add_quest(tQuests, fn_filter_quests, iIdx, pPlayer)
    local m_rgQuests = self.rgQuests

    local pQuest = m_rgQuests:get(iIdx)
    self:_add_quest_if_eligible(tQuests, fn_filter_quests, pQuest, pPlayer, 0)
end

function CQuestGrid:_fetch_top_quests_internal(fn_filter_quests, pPlayer, nNumQuests, iFromIdx, iToIdx)
    local tQuests = {}

    local m_rgQuests = self.rgQuests

    local nNumAvailable = (m_rgQuests:size() + 1) - iFromIdx
    local nToPick = math.min(nNumAvailable, nNumQuests)

    if iToIdx ~= nil then
        nNumAvailable = math.min(nNumAvailable, iToIdx - iFromIdx + 1)  -- focus on the relevant portion of the available pool
    end

    local nParts = math.ceil(nNumAvailable / RGraph.POOL_QUEST_FETCH_PARTITIONS)

    local nRows = math.ceil(nToPick / nParts)
    local nCols = nParts

    local iIdxLastRowEnds = ((nToPick - 1) % nParts) + 1

    for i = 0, nRows - 1, 1 do
        for j = 0, nCols - 2, 1 do
            local iIdx = (nCols * j) + i

            self:_try_add_quest(tQuests, fn_filter_quests, iFromIdx + iIdx, pPlayer)
        end
        if i < iIdxLastRowEnds then
            for j = nCols - 1, nCols - 1, 1 do
                local iIdx = (nCols * j) + i

                self:_try_add_quest(tQuests, fn_filter_quests, iFromIdx + iIdx, pPlayer)
            end
        end
    end

    return tQuests
end

function CQuestGrid:_fetch_top_quests_by_continent(pPlayer, nNumQuests, iFromIdx, iToIdx)
    local fn_filter_quests = function (pQuest, pPlayer)
        local iPlayerMapid = pPlayer:get_mapid()
        return get_continent_id(pQuest:get_start():get_requirement():get_field(iPlayerMapid)) == get_continent_id(iPlayerMapid)
    end

    local tQuests = self:_fetch_top_quests_internal(fn_filter_quests, pPlayer, nNumQuests, iFromIdx, iToIdx)
    return tQuests
end

function CQuestGrid:_fetch_top_quests_by_availability(pPlayer, nNumQuests, iFromIdx, iToIdx)
    local fn_filter_quests = function (pQuest, pPlayer) return true end

    local tQuests = self:_fetch_top_quests_internal(fn_filter_quests, pPlayer, nNumQuests, iFromIdx, iToIdx)
    return tQuests
end

function CQuestGrid:_fetch_top_quests_searchable_range(pPlayer, nNumQuests)
    local m_rgQuests = self.rgQuests

    local nLevel = pPlayer:get_level() + RGraph.POOL_AHEAD_QUEST_LEVEL
    local iIdx = m_rgQuests:bsearch(fn_compare_quest_level, nLevel, true, true)
    local iToIdx = m_rgQuests:bsearch(fn_compare_quest_level, pPlayer:get_level(), true, true)

    if iToIdx - iIdx < nNumQuests then
        iToIdx = math.min(m_rgQuests:size(), iIdx + nNumQuests)
    end

    return iIdx, iToIdx
end

function CQuestGrid:fetch_top_quests_by_player(pPlayer, nNumQuests)
    local pPoolQuests = STable:new()

    local iIdx
    local iToIdx
    iIdx, iToIdx = self:_fetch_top_quests_searchable_range(pPlayer, nNumQuests)

    local iNumQuestsRegional = math.ceil(RGraph.POOL_QUEST_FETCH_CONTINENT_RATIO * nNumQuests)
    pPoolQuests:insert_table(self:_fetch_top_quests_by_continent(pPlayer, iNumQuestsRegional, iIdx, iToIdx))

    local iNumLeft = iNumQuestsRegional - pPoolQuests:size()
    local iNumQuestsOverall = math.ceil((1.0 - RGraph.POOL_QUEST_FETCH_CONTINENT_RATIO) * nNumQuests)
    pPoolQuests:insert_table(self:_fetch_top_quests_by_availability(pPlayer, iNumQuestsOverall + iNumLeft, iIdx, iToIdx))

    return pPoolQuests
end

function CQuestGrid:ignore_underleveled_quests(iLevel)
    self:_ignore_quests_from_level(iLevel - RGraph.POOL_BEHIND_QUEST_LEVEL)
end

function CQuestGrid:fetch_required_quests(iLevel)
    local rgPoolQuests = SArray:new()

    --[[
    local rgFrontierQuests = self:_fetch_top_quests_by_level(iLevel + RGraph.POOL_AHEAD_QUEST_LEVEL, RGraph.POOL_MIN_QUESTS)

    while not rgFrontierQuests:is_empty() do
        local pQuest = rgFrontierQuests:remove_last()
        rgPoolQuests:add(pQuest)

        for _, pPreQuest in ipairs(pQuest:GET_REQUIREMENTS) do
            if (HAS prequest STATUS > 0) then
                rgFrontierQuests:add(pPreQuest)
            end
        end
    end
    --]]

    return rgPoolQuests
end
