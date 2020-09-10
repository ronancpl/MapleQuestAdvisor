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
require("utils.constants");
require("utils.class");

CQuestTable = createClass({
    rgQuests = SArray:new()
})

function CQuestTable:get_quests()
    local m_rgQuests = self.rgQuests
    return m_rgQuests
end

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

    table.sort(m_rgQuests,
        function (a,b)
            return b.get_quest_id() - a.get_quest_id()
        end
    )
end

local fn_compare_quest_level = function(pQuest, iLevel)
    return pQuest:get_quest_id() - iLevel
end

function CQuestTable:_ignore_quests_from_level(iLevel)
    local m_rgQuests = self.rgQuests

    local i = m_rgQuests:bsearch(fn_compare_quest_level, iLevel, true, true)
    if i > 0 then
        m_rgQuests:remove(i)
    end
end

function CQuestTable:_add_quest_if_eligible(tQuests, fn_filterQuests, pPlayer, iIdx)
    local m_rgQuests = self.rgQuests
    local pQuest = m_rgQuests.get(iIdx)

    if fn_filterQuests(pQuest, pPlayer) then
        tQuests[pQuest] = 1
    end
end

function CQuestTable:_fetch_top_quests_internal(fn_filterQuests, pPlayer, nNumQuests, iFromIdx)
    local tQuests = {}

    local m_rgQuests = self.rgQuests

    local nNumAvailable = m_rgQuests:size() - iFromIdx
    local nToPick = math.min(nNumAvailable, nNumQuests)

    local nParts = math.ceil(nNumAvailable / POOL_QUEST_FETCH_PARTITIONS)

    local nRows = math.floor(nToPick / nParts)
    local nCols = nParts

    for j = 0, nCols - 1, 1 do
        for i = 0, nRows - 2, 1 do
            local iIdx = (nCols * i) + j + 1
            self:_add_quest_if_eligible(tQuests, fn_filterQuests, pPlayer, iIdx)
        end

        local iIdx = (nCols * i) + j + 1
        if iIdx <= nToPick then
            self:_add_quest_if_eligible(tQuests, fn_filterQuests, pPlayer, iIdx)
        end
    end

    return tQuests
end

function CQuestTable:_fetch_top_quests_by_continent(pPlayer, nNumQuests, iFromIdx)
    local tQuests = {}

    local fn_filterQuests = function (pQuest, pPlayer)
        return get_continent_id(pQuest:get_start():get_requirement():get_field()) == get_continent_id(pPlayer:get_mapid())
    end

    self:_fetch_top_quests_internal(fn_filterQuests, pPlayer, nNumQuests, iFromIdx)

    return tQuests
end

function CQuestTable:_fetch_top_quests_by_availability(pPlayer, nNumQuests, iFromIdx)
    local tQuests = {}

    local fn_filterQuests = function (pQuest, pPlayer) return true end
    self:_fetch_top_quests_internal(fn_filterQuests, pPlayer, nNumQuests, iFromIdx)

    return tQuests
end

function CQuestTable:_fetch_top_quests_by_player(pPlayer, nNumQuests)
    local m_rgQuests = self.rgQuests

    local iLevel = pPlayer:get_level() + POOL_AHEAD_QUEST_LEVEL
    local iIdx = m_rgQuests:bsearch(fn_compare_quest_level, iLevel, true, true)

    local tPoolQuests = STable:new()

    local iNumQuestsRegional = POOL_QUEST_FETCH_CONTINENT_RATIO * nNumQuests
    tPoolQuests:insert(self:_fetch_top_quests_by_continent(pPlayer, iNumQuestsRegional, iIdx))

    local iNumLeft = iNumQuestsRegional - tPoolQuests:size()
    local iNumQuestsOverall = (1.0 - POOL_QUEST_FETCH_CONTINENT_RATIO) * nNumQuests
    tPoolQuests:insert(self:_fetch_top_quests_by_availability(pPlayer, iNumQuestsOverall + iNumLeft, iIdx))

    return tPoolQuests
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
