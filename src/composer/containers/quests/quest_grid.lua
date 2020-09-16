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
    return pQuest:get_starting_level() - iLevel
end

function CQuestGrid:_ignore_quests_from_level(iLevel)
    local m_rgQuests = self.rgQuests

    local i = m_rgQuests:bsearch(fn_compare_quest_level, iLevel, true, true)
    if i > 0 then
        m_rgQuests:remove(i)
    end
end

function CQuestGrid:_search_subquests_in_tab(tQuests, fn_filterQuests, pQuest, fn_quest_tab, pPlayer)
    local pQuestTab = fn_quest_tab(pQuest)

    for iPreQuestId, _ in pairs(pQuestTab:get_requirement():get_quests():get_items()) do
        local pPreQuest = ctQuests:get_quest_by_id(iPreQuestId)
        self:_add_quest_if_eligible(tQuests, fn_filterQuests, pPreQuest, pPlayer)
    end
end

--
function CQuestGrid:_search_subquests(tQuests, fn_filterQuests, pQuest, pPlayer)
    self:_search_subquests_in_tab(tQuests, fn_filterQuests, pQuest, CQuest.get_start, pPlayer)
    self:_search_subquests_in_tab(tQuests, fn_filterQuests, pQuest, CQuest.get_end, pPlayer)
end

function CQuestGrid:_add_quest_if_eligible(tQuests, fn_filterQuests, pQuest, pPlayer)
    if fn_filterQuests(pQuest, pPlayer) then
        tQuests[pQuest] = 1
        self:_search_subquests(tQuests, fn_filterQuests, pQuest, pPlayer)
    end
end

function CQuestGrid:_try_add_quest(tQuests, fn_filterQuests, iIdx, pPlayer)
    local m_rgQuests = self.rgQuests
    local pQuest = m_rgQuests:get(iIdx)

    self:_add_quest_if_eligible(tQuests, fn_filterQuests, pQuest, pPlayer)
end

function CQuestGrid:_fetch_top_quests_internal(fn_filterQuests, pPlayer, nNumQuests, iFromIdx)
    local tQuests = {}

    local m_rgQuests = self.rgQuests

    local nNumAvailable = (m_rgQuests:size() + 1) - iFromIdx
    local nToPick = math.min(nNumAvailable, nNumQuests)

    local nParts = math.ceil(nNumAvailable / RGraph.POOL_QUEST_FETCH_PARTITIONS)

    local nRows = math.ceil(nToPick / nParts)
    local nCols = nParts

    for j = 0, nCols - 1, 1 do
        for i = 0, nRows - 2, 1 do
            local iIdx = (nCols * i) + j + 1
            self:_try_add_quest(tQuests, fn_filterQuests, iIdx, pPlayer)
        end
        local i = nRows - 1

        local iIdx = (nCols * i) + j + 1
        if iIdx <= nToPick then
            self:_try_add_quest(tQuests, fn_filterQuests, iIdx, pPlayer)
        end
    end

    return tQuests
end

function CQuestGrid:_fetch_top_quests_by_continent(pPlayer, nNumQuests, iFromIdx)
    local fn_filterQuests = function (pQuest, pPlayer)
        return get_continent_id(pQuest:get_start():get_requirement():get_field()) == get_continent_id(pPlayer:get_mapid())
    end

    local tQuests = self:_fetch_top_quests_internal(fn_filterQuests, pPlayer, nNumQuests, iFromIdx)
    return tQuests
end

function CQuestGrid:_fetch_top_quests_by_availability(pPlayer, nNumQuests, iFromIdx)
    local fn_filterQuests = function (pQuest, pPlayer) return true end

    local tQuests = self:_fetch_top_quests_internal(fn_filterQuests, pPlayer, nNumQuests, iFromIdx)
    return tQuests
end

function CQuestGrid:fetch_top_quests_by_player(pPlayer, nNumQuests)
    local m_rgQuests = self.rgQuests

    local iLevel = pPlayer:get_level() + RGraph.POOL_AHEAD_QUEST_LEVEL
    local iIdx = m_rgQuests:bsearch(fn_compare_quest_level, iLevel, true, true)

    local pPoolQuests = STable:new()

    local iNumQuestsRegional = math.ceil(RGraph.POOL_QUEST_FETCH_CONTINENT_RATIO * nNumQuests)
    pPoolQuests:insert_table(self:_fetch_top_quests_by_continent(pPlayer, iNumQuestsRegional, iIdx))

    local iNumLeft = iNumQuestsRegional - pPoolQuests:size()
    local iNumQuestsOverall = math.ceil((1.0 - RGraph.POOL_QUEST_FETCH_CONTINENT_RATIO) * nNumQuests)
    pPoolQuests:insert_table(self:_fetch_top_quests_by_availability(pPlayer, iNumQuestsOverall + iNumLeft, iIdx))

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
            if (HAS SUBQUEST STATUS > 0) then
                rgFrontierQuests:add(pPreQuest)
            end
        end
    end
    --]]

    return rgPoolQuests
end
