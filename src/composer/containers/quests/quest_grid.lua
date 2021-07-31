--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.graph")
require("router.procedures.constant")
require("structs.quest.quest")
require("utils.procedure.unpack")
require("utils.struct.array")
require("utils.struct.class")

CQuestGrid = createClass({
    rgQuests = SArray:new()
})

function CQuestGrid:add_quest(pQuest)
    local m_rgQuests = self.rgQuests
    m_rgQuests:add(pQuest)
end

function CQuestGrid:remove_quest(iIdx, nQuests)
    local m_rgQuests = self.rgQuests
    local rgRemovedQuests = m_rgQuests:remove(iIdx, iIdx + nQuests - 1)

    return rgRemovedQuests
end

function CQuestGrid:randomize_quest_table()
    local m_rgQuests = self.rgQuests
    m_rgQuests:randomize()
end

function CQuestGrid:sort_quest_table()
    local m_rgQuests = self.rgQuests
    local fn_compare_quest_level = function (a,b) return a:get_starting_level() > b:get_starting_level() end
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
    if pQuest ~= nil and fn_filter_quests(pQuest, pPlayer) then
        if tQuests[pQuest] == nil then
            tQuests[pQuest] = 1
            self:_search_prequests(tQuests, fn_filter_quests, pQuest, pPlayer, iExpectedStatus)
        end
    end
end

function CQuestGrid:_try_add_quest(tQuests, fn_filter_quests, iIdx, pPlayer)
    local m_rgQuests = self.rgQuests

    local pQuest = m_rgQuests:get(iIdx)
    self:_add_quest_if_eligible(tQuests, fn_filter_quests, pQuest, pPlayer, 0)
end

function CQuestGrid:_fetch_top_quests_internal(fn_filter_quests, pPlayer, nQuests, iFromIdx, iToIdx)
    local tQuests = {}

    local m_rgQuests = self.rgQuests

    local nAvailable = (m_rgQuests:size() + 1) - iFromIdx
    local nToPick = math.min(nAvailable, nQuests)

    if iToIdx ~= nil then
        nAvailable = math.min(nAvailable, iToIdx - iFromIdx + 1)  -- focus on the relevant portion of the available pool
    end

    local nParts = math.ceil(nAvailable / RGraph.POOL_QUEST_FETCH_PARTITIONS)

    local nRows
    local nCols
    if nToPick >= nParts then
        nRows = math.ceil(nToPick / nParts)
        nCols = nParts
    else
        nRows = 1
        nCols = nToPick
    end

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

function CQuestGrid:_fetch_top_quests_by_continent(pPlayer, nQuests, iFromIdx, iToIdx)
    local fn_filter_quests = function (pQuest, pPlayer)
        local iPlayerMapid = pPlayer:get_mapid()
        local iStartMapid = pQuest:get_start():get_requirement():get_field(iPlayerMapid) or 0

        return get_continent_id(iStartMapid) == get_continent_id(iPlayerMapid)
    end

    local tQuests = self:_fetch_top_quests_internal(fn_filter_quests, pPlayer, nQuests, iFromIdx, iToIdx)
    return tQuests
end

function CQuestGrid:_fetch_top_quests_by_availability(pPlayer, nQuests, iFromIdx, iToIdx)
    local fn_filter_quests = function (pQuest, pPlayer) return true end

    local tQuests = self:_fetch_top_quests_internal(fn_filter_quests, pPlayer, nQuests, iFromIdx, iToIdx)
    return tQuests
end

function CQuestGrid:_fetch_top_quests_searchable_range(pPlayer, nQuests)
    local m_rgQuests = self.rgQuests

    local iLevelAhead = pPlayer:get_level() + RGraph.POOL_AHEAD_QUEST_LEVEL
    local iLevelBehind = pPlayer:get_level() - RGraph.POOL_BEHIND_QUEST_LEVEL

    local iIdx = math.max(m_rgQuests:bsearch(fn_compare_quest_level, iLevelAhead, true, true), 1)
    local iToIdx = m_rgQuests:bsearch(fn_compare_quest_level, iLevelBehind, true, true)

    if iToIdx - iIdx < nQuests then
        iToIdx = math.min(m_rgQuests:size(), iIdx + nQuests)
    end

    return iIdx, iToIdx
end

local function fn_filter_root_quests(pQuest, pPlayer)
    return ctAccessors:is_player_have_prerequisites(true, pPlayer, pQuest:get_start())
end

function CQuestGrid:_count_root_quests(pPlayer, tpPoolQuests)
    local iCount = 0
    for pQuest, _ in pairs(tpPoolQuests:get_entry_set()) do
        if fn_filter_root_quests(pQuest, pPlayer) then
            iCount = iCount + 1
        end
    end

    return iCount
end

function CQuestGrid:_fetch_top_quests_by_pickability(pPlayer, nQuests, iIdx, iToIdx)
    local fn_filter_quests = fn_filter_root_quests

    local iCurIdx = iIdx
    local iCurToIdx = iToIdx

    local tQuests = {}
    while #keys(tQuests) < nQuests and iCurIdx <= iCurToIdx do
        local tCurQuests = self:_fetch_top_quests_internal(fn_filter_quests, pPlayer, nQuests, iCurIdx, iCurToIdx)
        table_merge(tQuests, tCurQuests)

        iCurIdx = iCurIdx + 1
        iCurToIdx = iCurToIdx - 1
    end

    return tQuests
end

function CQuestGrid:fetch_top_quests_by_player(pPlayer, nQuests)
    local tpPoolQuests = STable:new()

    local iIdx
    local iToIdx
    iIdx, iToIdx = self:_fetch_top_quests_searchable_range(pPlayer, nQuests)

    local nQuestsRegional = math.ceil(RGraph.POOL_QUEST_FETCH_CONTINENT_RATIO * nQuests)
    tpPoolQuests:insert_table(self:_fetch_top_quests_by_continent(pPlayer, nQuestsRegional, iIdx, iToIdx))

    local nQuestsRoot = math.ceil(nQuests * RGraph.POOL_QUEST_FETCH_ROOT_RATIO) - self:_count_root_quests(pPlayer, tpPoolQuests)
    tpPoolQuests:insert_table(self:_fetch_top_quests_by_pickability(pPlayer, nQuestsRoot, iIdx, iToIdx))

    local nLeft = nQuestsRegional - tpPoolQuests:size()
    local nQuestsOverall = math.ceil((1.0 - RGraph.POOL_QUEST_FETCH_CONTINENT_RATIO) * nQuests)
    tpPoolQuests:insert_table(self:_fetch_top_quests_by_availability(pPlayer, nQuestsOverall + nLeft, iIdx, iToIdx))

    return tpPoolQuests
end

function CQuestGrid:fetch_quests_by_list(rgiQuests)
    local tpPoolQuests = STable:new()

    for _, iQuestid in ipairs(rgiQuests) do
        local pQuest = ctQuests:get_quest_by_id(iQuestid)
        tpPoolQuests:insert(pQuest, 1)
    end

    return tpPoolQuests
end

function CQuestGrid:ignore_underleveled_quests(iLevel)
    self:_ignore_quests_from_level(iLevel - RGraph.POOL_BEHIND_QUEST_LEVEL)
end

function CQuestGrid:length()
    local m_rgQuests = self.rgQuests
    m_rgQuests:add(pQuest)

    return m_rgQuests:size()
end

function CQuestGrid:list()
    local m_rgQuests = self.rgQuests
    return m_rgQuests:list()
end
