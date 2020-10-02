--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.quest.accessor.diff")

function fn_get_player_state_exp(pPlayerState)
    return pPlayerState:get_exp()
end

function fn_get_player_state_meso(pPlayerState)
    return pPlayerState:get_meso()
end

function fn_get_player_state_fame(pPlayerState)
    return pPlayerState:get_fame()
end

function fn_get_player_state_skills(pPlayerState)
    return pPlayerState:get_skills()
end

function fn_get_player_state_items(pPlayerState)
    return pPlayerState:get_items()
end

function fn_get_player_state_mobs(pPlayerState)
    return pPlayerState:get_mobs()
end

function fn_get_player_state_quests(pPlayerState)
    return pPlayerState:get_quests()
end

function fn_get_player_state_npc(pPlayerState)
    return 0
end

function fn_get_player_state_field(pPlayerState)
    return 0
end

function fn_get_player_state_field_enter(pPlayerState)
    return 0
end

function fn_get_player_state_level_min(pPlayerState)
    return pPlayerState:get_level_min()
end

function fn_get_player_state_level_max(pPlayerState)
    return pPlayerState:get_level_max()
end

function fn_get_player_state_jobs(pPlayerState)
    return 0
end

function fn_get_player_state_date(pPlayerState)
    return 0
end

function fn_get_player_state_repeat(pPlayerState)
    return 0
end

function fn_get_player_state_scripts(pPlayerState)
    return 0
end
