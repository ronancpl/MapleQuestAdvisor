--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

function fn_award_player_state_exp(pPlayerState, iGain)
    pPlayerState:add_exp(iGain)
end

function fn_award_player_state_meso(pPlayerState, iGain)
    pPlayerState:add_meso(iGain)
end

function fn_award_player_state_fame(pPlayerState, siGain)
    pPlayerState:add_fame(siGain)
end

function fn_award_player_state_skills(pPlayerState, iGain)
    pPlayerState:get_skills():set_item(iGain, 1)
end

function fn_award_player_state_items(pPlayerState, iId, iGain)
    pPlayerState:get_items():set_item(iId, iGain)
end

function fn_award_player_state_quests(pPlayerState, iId, iStatus)
    pPlayerState:get_items():set_item(iId, iStatus)
end

function fn_award_player_state_jobs(pPlayerState, iGain)
    return pPlayerState:set_job(siJob)
end
