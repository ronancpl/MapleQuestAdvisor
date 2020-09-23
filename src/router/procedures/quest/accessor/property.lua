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

function fn_quest_diff_pending_exp(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending(pQuestAcc, pQuestProp, pPlayerState:get_exp())
end

function fn_quest_diff_pending_meso(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending(pQuestAcc, pQuestProp, pPlayerState:get_meso())
end

function fn_quest_diff_pending_fame(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending(pQuestAcc, pQuestProp, pPlayerState:get_fame())
end

function fn_quest_diff_pending_skills(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending_list(pQuestAcc, pQuestProp, pPlayerState:get_skills())
end

function fn_quest_diff_pending_items(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending_list(pQuestAcc, pQuestProp, pPlayerState:get_items())
end

function fn_quest_diff_pending_mobs(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending_list(pQuestAcc, pQuestProp, pPlayerState:get_mobs())
end

function fn_quest_diff_pending_quests(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending_list(pQuestAcc, pQuestProp, pPlayerState:get_quests())
end

function fn_quest_diff_pending_npc(pQuestAcc, pQuestProp, pPlayerState)
    return 0
end

function fn_quest_diff_pending_field(pQuestAcc, pQuestProp, pPlayerState)
    return 0
end

function fn_quest_diff_pending_field_enter(pQuestAcc, pQuestProp, pPlayerState)
    return 0
end

function fn_quest_diff_pending_level_min(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending(pQuestAcc, pQuestProp, pPlayerState:get_level_min())
end

function fn_quest_diff_pending_level_max(pQuestAcc, pQuestProp, pPlayerState)
    return fn_diff_pending(pQuestAcc, pQuestProp, pPlayerState:get_level_max())
end

function fn_quest_diff_pending_jobs(pQuestAcc, pQuestProp, pPlayerState)
    return 0
end

function fn_quest_diff_pending_date(pQuestAcc, pQuestProp, pPlayerState)
    return 0
end

function fn_quest_diff_pending_repeat(pQuestAcc, pQuestProp, pPlayerState)
    return 0
end

function fn_quest_diff_pending_scripts(pQuestAcc, pQuestProp, pPlayerState)
    return 0
end
