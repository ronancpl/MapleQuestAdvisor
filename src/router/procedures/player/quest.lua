--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function is_quest_deployed(pPlayerState, pQuestProp, siExpectedState)
    local m_ivtQuests = pPlayerState:get_quests()
    local iQuestid = pQuestProp:get_quest_id()

    return m_ivtQuests:get_item(iQuestid) == siExpectedState
end

function is_quest_not_started(pPlayerState, pQuestProp)
    return is_quest_deployed(pPlayerState, pQuestProp, 0)
end

function is_quest_started(pPlayerState, pQuestProp)
    return is_quest_deployed(pPlayerState, pQuestProp, 1)
end

function is_quest_completed(pPlayerState, pQuestProp)
    return is_quest_deployed(pPlayerState, pQuestProp, 2)
end

function is_quest_state_achieved(pPlayerState, pQuestProp)
    local m_ivtQuests = pPlayerState:get_quests()
    local iQuestid = pQuestProp:get_quest_id()
    local siExpectedState = pQuestProp:is_start() and 1 or 2

    return m_ivtQuests:get_item(iQuestid) >= siExpectedState
end
