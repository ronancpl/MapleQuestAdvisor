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
require("utils.logger.file")
require("utils.procedure.unpack")
require("utils.struct.array")
require("utils.struct.class")

CQuestTable = createClass({
    tpQuests = {},
    tpTitleQuests = {},
    tpQuestlines = {},
    tpNextQuestProps = {}
})

function CQuestTable:get_quests()
    local m_tpQuests = self.tpQuests
    return m_tpQuests
end

function CQuestTable:get_quest_by_id(iQuestid)
    local m_tpQuests = self.tpQuests
    return m_tpQuests[iQuestid]
end

function CQuestTable:get_quest_by_title(sQuestTitle)
    local m_tpTitleQuests = self.tpTitleQuests
    return m_tpTitleQuests[sQuestTitle]
end

function CQuestTable:add_quest(pQuest)
    local m_tpQuests = self.tpQuests
    m_tpQuests[pQuest:get_quest_id()] = pQuest

    local m_tpTitleQuests = self.tpTitleQuests
    m_tpTitleQuests[pQuest:get_title()] = pQuest
end

function CQuestTable:remove_quest(iQuestid)
    local m_tpQuests = self.tpQuests

    local pQuest = m_tpQuests[iQuestid]
    m_tpQuests[iQuestid] = nil

    if pQuest ~= nil then
        local m_tpTitleQuests = self.tpTitleQuests
        m_tpTitleQuests[pQuest:get_title()] = nil
    end
end

local function is_inoperative_quest(pQuest)
    local pStartReq = pQuest:get_start():get_requirement()
    local pEndReq = pQuest:get_end():get_requirement()

    if pStartReq:get_npc() < 0 or pEndReq:get_npc() < 0 and not pStartReq:has_script() then
        return true
    end

    if not pStartReq:has_date_access() or not pEndReq:has_date_access() then
        return true
    end

    return false
end

function CQuestTable:dispose_inoperative_quests()
    local m_tpQuests = self.tpQuests

    local tiToRemove = {}
    for iQuestid, pQuest in pairs(m_tpQuests) do
        if is_inoperative_quest(pQuest) then
            log(LPath.FALLBACK, "quest.txt", "[WARNING] Disposed questid " .. iQuestid)
            table.insert(tiToRemove, iQuestid)
        end
    end

    for i = #tiToRemove, 1, -1 do
        self:remove_quest(tiToRemove[i])
    end
end

function CQuestTable:_dispose_missing_prequests_in_tab(pQuest, fn_quest_tab)
    local pPrequests = fn_quest_tab(pQuest):get_requirement():get_quests()
    local tPrequests = pPrequests:get_items()

    local tiToRemove = {}
    for iPreQuestId, _ in pairs(tPrequests) do
        local pPreQuest = ctQuests:get_quest_by_id(iPreQuestId)
        if pPreQuest == nil then
            table.insert(tiToRemove, iPreQuestId)
        end

        for i = 1, #tiToRemove, 1 do
            pPrequests:remove_item(tiToRemove[i])
        end
    end
end

function CQuestTable:dispose_missing_prequests()
    local m_tpQuests = self.tpQuests

    for _, pQuest in pairs(m_tpQuests) do
        self:_dispose_missing_prequests_in_tab(pQuest, CQuest.get_start)
        self:_dispose_missing_prequests_in_tab(pQuest, CQuest.get_end)
    end
end

function CQuestTable:_find_prequest_starting_level(pQuest, tiQuestSearchers)
    local rgiPreQuestIds = {}
    for iPreQuestId, _ in pairs(pQuest:get_start():get_requirement():get_quests():get_items()) do
        if tiQuestSearchers[iPreQuestId] == nil then
            tiQuestSearchers[iPreQuestId] = 1
            table.insert(rgiPreQuestIds, iPreQuestId)
        end
    end

    local pStartingQuest = pQuest
    local siStartLevel = U_INT_MAX
    for _, iPreQuestId in ipairs(rgiPreQuestIds) do
        local siPreStartLevel = U_INT_MAX
        local pPreQuest = ctQuests:get_quest_by_id(iPreQuestId)
        if pPreQuest ~= nil then
            if tiQuestSearchers[iPreQuestId] ~= 2 then
                pPreQuest, siPreStartLevel = self:_apply_quest_starting_level(pPreQuest, tiQuestSearchers)
            else
                siPreStartLevel = pPreQuest:get_starting_level()
            end
        end

        if siPreStartLevel > siStartLevel then
            siStartLevel = siPreStartLevel
            pStartingQuest = pPreQuest
        end

        tiQuestSearchers[iPreQuestId] = 2
    end

    return pStartingQuest, siStartLevel
end

function CQuestTable:_apply_quest_starting_level(pQuest, tiQuestSearchers)
    local pStartingQuest = pQuest
    local siStartLevel = pQuest:get_start():get_requirement():get_level_min()
    if siStartLevel < 0 then
        pStartingQuest, siStartLevel = self:_find_prequest_starting_level(pQuest, tiQuestSearchers)
    end

    pQuest:set_starting_level(siStartLevel)
    self:add_questline(pQuest, pStartingQuest)

    return pStartingQuest, siStartLevel
end

function CQuestTable:apply_starting_level()
    local m_tpQuests = self.tpQuests

    for _, pQuest in pairs(m_tpQuests) do
        self:_apply_quest_starting_level(pQuest, {})
    end
end

function CQuestTable:fetch_prerequisited_quests(pFromQuestProp)
    local rgpQuestProps = {}
    table.insert(rgpQuestProps, pFromQuestProp)

    local tiQuestSearchers = {}
    while true do
        local pQuestProp = table.remove(rgpQuestProps)
        if pQuestProp == nil then
            break
        end

        for iPreQuestId, iPreQuestStatus in pairs(pQuestProp:get_requirement():get_quests():get_items()) do
            if tiQuestSearchers[iPreQuestId] == nil or tiQuestSearchers[iPreQuestId] < iPreQuestStatus then
                tiQuestSearchers[iPreQuestId] = iPreQuestStatus
                table.insert(rgpQuestProps, ctQuests:get_quest_by_id(iPreQuestId):get_start())
            end
        end
    end

    return keys(tiQuestSearchers)
end

function CQuestTable:get_questline(pQuest)
    return self.tpQuestlines[pQuest]
end

function CQuestTable:is_in_same_questline(pQuest1, pQuest2)
    return self.tpQuestlines[pQuest1] == self.tpQuestlines[pQuest2]
end

function CQuestTable:add_questline(pQuest, pFirstQuest)
    self.tpQuestlines[pQuest] = pFirstQuest
end

function CQuestTable:get_next_quest_prop(pQuestProp)
    return self.tpNextQuestProps[pQuestProp] or {}
end

function CQuestTable:add_next_quest_prop(pQuestProp, pNextQuestProp)
    local m_tpNextQuestProps = self.tpNextQuestProps
    local rgpNextProps = m_tpNextQuestProps[pQuestProp]
    if rgpNextProps == nil then
        rgpNextProps = {}
        m_tpNextQuestProps[pQuestProp] = rgpNextProps
    end

    table.insert(rgpNextProps, pNextQuestProp)
end

function CQuestTable:_build_quest_path(pQuestProp)
    for iPreQuestId, iStatus in pairs(pQuestProp:get_requirement():get_quests():get_items()) do
        local pPreQuest = ctQuests:get_quest_by_id(iPreQuestId)
        if pPreQuest ~= nil and iStatus > 0 then
            self:add_next_quest_prop(iStatus > 1 and pPreQuest:get_end() or pPreQuest:get_start(), pQuestProp)
        end
    end
end

function CQuestTable:build_questline_path()
    local m_tpQuests = self.tpQuests

    for _, pQuest in pairs(m_tpQuests) do
        self:_build_quest_path(pQuest:get_start())
        self:_build_quest_path(pQuest:get_end())
    end
end
