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
    tpQuests = {}
})

function CQuestTable:get_quests()
    local m_tpQuests = self.tpQuests
    return m_tpQuests
end

function CQuestTable:get_quest_by_id(iQuestid)
    local m_tpQuests = self.tpQuests
    return m_tpQuests[iQuestid]
end

function CQuestTable:add_quest(pQuest)
    local m_tpQuests = self.tpQuests
    m_tpQuests[pQuest:get_quest_id()] = pQuest
end

function CQuestTable:remove_quest(iQuestid)
    local m_tpQuests = self.tpQuests
    m_tpQuests[iQuestid] = nil
end

local function is_inoperative_quest(pQuest)
    local pStartReq = pQuest:get_start():get_requirement()
    local pEndReq = pQuest:get_end():get_requirement()

    return pStartReq:get_npc() < 0 or pEndReq:get_npc() < 0 and not pStartReq:has_script()
end

function CQuestTable:dispose_inoperative_quests()
    local m_tpQuests = self.tpQuests

    local pToRemove = {}
    for iQuestid, pQuest in pairs(m_tpQuests) do
        if is_inoperative_quest(pQuest) then
            -- print("[WARNING] Disposed questid " .. iQuestid)
            table.insert(pToRemove, iQuestid)
        end
    end

    for i = #pToRemove, 1, -1 do
        self:remove_quest(pToRemove[i])
    end
end

function CQuestTable:_dispose_missing_subquests_in_tab(pQuest, fn_quest_tab)
    local pPrequests = fn_quest_tab(pQuest):get_requirement():get_quests()
    for _, tPrequests in pairs(pPrequests:get_items()) do
        local tToRemove = {}
        for i = 1, #tPrequests, 1 do
            local iPreQuestId = tPrequests[i]
            local pPreQuest = ctQuests:get_quest_by_id(iPreQuestId)
            if pPreQuest == nil then
                table.insert(tToRemove, iPreQuestId)
            end
        end

        for i = 1, #tToRemove, 1 do
            pPrequests:remove_item(tToRemove[i])
        end
    end
end

function CQuestTable:dispose_missing_subquests()
    local m_tpQuests = self.tpQuests

    for _, pQuest in pairs(m_tpQuests) do
        self:_dispose_missing_subquests_in_tab(pQuest, CQuest.get_start)
        self:_dispose_missing_subquests_in_tab(pQuest, CQuest.get_end)
    end
end

function CQuestTable:_find_subquest_starting_level(pQuest)
    local rgiPreQuestIds = {}
    for iPreQuestId, _ in pairs(pQuest:get_start():get_requirement():get_quests():get_items()) do
        table.insert(rgiPreQuestIds, iPreQuestId)
    end

    local siStartLevel = -1
    for _, iPreQuestId in ipairs(rgiPreQuestIds) do
        local pSubQuest = ctQuests:get_quest_by_id(iPreQuestId)
        local siSubStartLevel = self:_apply_quest_starting_level(pSubQuest)

        if siSubStartLevel > siStartLevel then
            siStartLevel = siSubStartLevel
        end
    end

    return siStartLevel
end

function CQuestTable:_apply_quest_starting_level(pQuest)
    local siStartLevel = pQuest:get_start():get_requirement():get_level_min()
    if (siStartLevel < 0) then
        siStartLevel = self:_find_subquest_starting_level(pQuest)
    end

    pQuest:set_starting_level(siStartLevel)
    return siStartLevel
end

function CQuestTable:apply_starting_level()
    local m_tpQuests = self.tpQuests

    for _, pQuest in pairs(m_tpQuests) do
        self:_apply_quest_starting_level(pQuest)
    end
end
