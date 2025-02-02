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
require("utils.struct.stack")
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
        m_rgQuests:remove(math.max(i, RGraph.POOL_MIN_QUESTS))
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
        if tQuests[pQuest] == nil then
            tQuests[pQuest] = 1
            self:_search_prequests(tQuests, fn_filter_quests, pQuest, pPlayer, iExpectedStatus)
        end

        return true
    end

    return false
end

function CQuestGrid:_try_add_quest(tQuests, fn_filter_quests, iIdx, pPlayer)
    local m_rgQuests = self.rgQuests

    local pQuest = m_rgQuests:get(iIdx)
    return self:_add_quest_if_eligible(tQuests, fn_filter_quests, pQuest, pPlayer, 0)
end

function CQuestGrid:_fetch_top_quests_index(tQuests, fn_filter_quests, iFromIdx, pPlayer, nQuests, nAvailable)
    local iCount = #keys(tQuests)

    local nParts = RGraph.POOL_QUEST_FETCH_PARTITIONS

    local nRows
    local nCols
    if nAvailable >= nParts then
        nRows = math.ceil(nAvailable / nParts)
        nCols = nParts
    else
        nRows = nAvailable
        nCols = 1
    end

    local iIdxLastRowEnds = math.floor(nAvailable / nCols) - 1

    for i = 0, nRows - 2, 1 do
        for j = 0, nCols - 2, 1 do
            local iIdx = ((nRows - 1) * j) + i

            if self:_try_add_quest(tQuests, fn_filter_quests, iFromIdx + iIdx, pPlayer) then
                iCount = iCount + 1
                if iCount >= nQuests then return end
            end
        end
        if i < iIdxLastRowEnds then
            for j = nCols - 1, nCols - 1, 1 do
                local iIdx = ((nRows - 1) * j) + i

                if self:_try_add_quest(tQuests, fn_filter_quests, iFromIdx + iIdx, pPlayer) then
                    iCount = iCount + 1
                    if iCount >= nQuests then return end
                end
            end
        end
    end
end

function CQuestGrid:_fetch_top_quests_internal(fn_filter_quests, pPlayer, nQuests, iFromIdx, iToIdx)
    local tQuests = {}

    local m_rgQuests = self.rgQuests

    local nAvailable = (m_rgQuests:size() + 1) - iFromIdx
    if iToIdx ~= nil then
        nAvailable = math.min(nAvailable, iToIdx - iFromIdx + 1)  -- focus on the relevant portion of the available pool
    end

    self:_fetch_top_quests_index(tQuests, fn_filter_quests, iFromIdx, pPlayer, nQuests, nAvailable)

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

function CQuestGrid:_fetch_searchable_range_min(iIdx, nRange)
    if nRange > 0 then
        local m_rgQuests = self.rgQuests
        local nQuests = self:length()

        local iLevel = m_rgQuests:get(iIdx):get_starting_level()
        local iLevelRange = 0

        iIdx = iIdx - 1
        while iIdx > 0 do
            local iQuestLevel = m_rgQuests:get(iIdx):get_starting_level()
            iIdx = iIdx - 1

            if iLevel ~= iQuestLevel then
                iLevel = iQuestLevel

                iLevelRange = iLevelRange + 1
                if iLevelRange >= nRange then
                    break
                end
            end
        end
    end

    return iIdx + 1
end

function CQuestGrid:_fetch_searchable_range_max(iIdx, nRange)
    if nRange > 0 then
        local m_rgQuests = self.rgQuests
        local nQuests = self:length()

        local iLevel = m_rgQuests:get(iIdx):get_starting_level()
        local iLevelRange = 0

        iIdx = iIdx + 1
        while iIdx <= nQuests do
            local iQuestLevel = m_rgQuests:get(iIdx):get_starting_level()
            iIdx = iIdx + 1

            if iLevel ~= iQuestLevel then
                iLevel = iQuestLevel

                iLevelRange = iLevelRange + 1
                if iLevelRange >= nRange then
                    break
                end
            end
        end
    end

    return iIdx - 1
end

function CQuestGrid:_fetch_top_quests_searchable_range(pPlayer, nQuests)
    local m_rgQuests = self.rgQuests

    local iPlayerIdx = m_rgQuests:bsearch(fn_compare_quest_level, pPlayer:get_level(), true, true)

    local iIdx = self:_fetch_searchable_range_min(iPlayerIdx, RGraph.POOL_AHEAD_LEVEL_RANGE)
    local iToIdx = self:_fetch_searchable_range_max(iPlayerIdx, RGraph.POOL_BEHIND_LEVEL_RANGE)

    if iToIdx - iIdx < nQuests then
        iToIdx = math.min(m_rgQuests:size(), iIdx + nQuests)
    end

    return iIdx, iToIdx
end

function CQuestGrid:_fetch_quests_by_questline(tQuests)
    local rgpQuests = {}
    for pQuest, _ in pairs(tQuests:get_entry_set()) do
        table.insert(rgpQuests, pQuest)
    end

    local tpQuestsSearched = {}
    for _, pQuest in ipairs(rgpQuests) do
        local pExploredQuestProps = SStack:new()
        pExploredQuestProps:push(ctQuests:get_questline(pQuest):get_start())

        while pExploredQuestProps:size() > 0 do
            local pCurQuestProp = pExploredQuestProps:pop()
            if tpQuestsSearched[pCurQuestProp] == nil then
                tQuests:insert(ctQuests:get_quest_by_id(pCurQuestProp:get_quest_id()), 1)
                tpQuestsSearched[pCurQuestProp] = 1

                pExploredQuestProps:push_all(ctQuests:get_next_quest_prop(pCurQuestProp))
            end
        end
    end
end

function CQuestGrid:fetch_top_quests_by_player(pPlayer, nQuests)
    local tpPoolQuests = STable:new()

    if pUiWmap ~= nil then
        local pTrack = pUiWmap:get_properties():get_track()
        if pTrack ~= nil then
            local pCurQuestProp = pTrack:get_top_quest()
            if pCurQuestProp ~= nil then
                for _, pQuestProp in ipairs(ctQuests:get_next_quest_prop(pCurQuestProp)) do
                    tpPoolQuests:insert(ctQuests:get_quest_by_id(pQuestProp:get_quest_id()), 1)   -- adds next quest from current track
                end
            end
        end
    end

    local iIdx
    local iToIdx
    iIdx, iToIdx = self:_fetch_top_quests_searchable_range(pPlayer, nQuests)

    local nQuestsRegional = math.ceil(RGraph.POOL_QUEST_FETCH_CONTINENT_RATIO * nQuests)
    tpPoolQuests:insert_table(self:_fetch_top_quests_by_continent(pPlayer, nQuestsRegional, iIdx, iToIdx))

    local nLeft = nQuestsRegional - tpPoolQuests:size()
    local nQuestsOverall = math.ceil((1.0 - RGraph.POOL_QUEST_FETCH_CONTINENT_RATIO) * nQuests)
    tpPoolQuests:insert_table(self:_fetch_top_quests_by_availability(pPlayer, nQuestsOverall + nLeft, iIdx, iToIdx))

    self:_fetch_quests_by_questline(tpPoolQuests)

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
    self:_ignore_quests_from_level(iLevel - RGraph.POOL_BEHIND_LEVEL_RANGE)
end

function CQuestGrid:length()
    local m_rgQuests = self.rgQuests
    return m_rgQuests:size()
end

function CQuestGrid:list()
    local m_rgQuests = self.rgQuests
    return m_rgQuests:list()
end
