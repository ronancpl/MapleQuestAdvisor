--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local bit = require("bit")
require("router.procedures.inventory.handle")

function fn_award_player_state_exp(pPlayerState, iGain)
    pPlayerState:add_exp(iGain)
end

function fn_award_player_state_meso(pPlayerState, iGain)
    pPlayerState:add_meso(iGain)
end

function fn_award_player_state_fame(pPlayerState, siGain)
    pPlayerState:add_fame(siGain)
end

function fn_award_player_state_skills(pPlayerState, rgpGet)
    local pSkills = pPlayerState:get_skills()

    for iId, iGain in pairs(rgpGet:get_items()) do
        pSkills:set_item(iId, iGain)
    end
end

function fn_award_player_state_items(pPlayerState, rgpGet)
    local pItems = pPlayerState:get_items()

    for iId, iGain in pairs(rgpGet:get_items()) do
        pItems:add_item(pItems, iId, iGain)
    end
end

local function update_quest_status(pQuests, iId, iGain)
    local iStatus = pQuests:get_item(iId)
    return bit.bor(iStatus, iGain)
end

local function update_undo_quest_status(pQuests, iId, iGain)
    local iStatus = pQuests:get_item(iId)
    return bit.band(iStatus, bit.bxor(iStatus, iGain))
end

function fn_award_player_state_quests(pPlayerState, rgpGet, bUndo)
    local pQuests = pPlayerState:get_quests()

    local fn_next_status = bUndo and update_undo_quest_status or update_quest_status
    for iId, iGain in pairs(rgpGet:get_items()) do
        local btStatus = fn_next_status(pQuests, iId, iGain)
        pQuests:set_item(iId, btStatus)
    end
end

function fn_award_player_state_jobs(pPlayerState, rgpGet)
    for iId, _ in pairs(rgpGet:get_items()) do
        pPlayerState:set_job(iId)
    end
end
