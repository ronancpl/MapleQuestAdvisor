--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function award_player(ctAwarders, fn_award_key, pQuestProp, pPlayerState)
    local pAwd = ctAwarders:get_awarder_by_fn_award(fn_award_key)
    if pAwd ~= nil then
        local fn_get = pAwd:get_fn_quest_property()
        local fn_award = pAwd:get_fn_award_property()

        local rgpGet = fn_get(pQuestProp)
        fn_award(pPlayerState, rgpGet, false)
    end
end

local function undo_award_player(ctAwarders, fn_award_key, pQuestProp, pPlayerState)
    local pAwd = ctAwarders:get_awarder_by_fn_award(fn_award_key)
    if pAwd ~= nil then
        local fn_get = pAwd:get_fn_quest_property()
        local fn_pnot = pAwd:get_fn_quest_rollback()
        local fn_award = pAwd:get_fn_award_property()

        local rgpGet = fn_get(pQuestProp)
        rgpGet = fn_pnot(rgpGet)
        fn_award(pPlayerState, rgpGet, true)
    end
end

local function process_player_state_update(fn_process_award, ctAwarders, pQuestProp, pPlayerState)
    local rgfn_active_act_unit
    local rgfn_active_act_invt
    local pPropAct

    rgfn_active_act_unit, rgfn_active_act_invt, pPropAct = pQuestProp:get_rgfn_active_awards()
    for _, fn_award in ipairs(rgfn_active_act_unit) do
        fn_process_award(ctAwarders, fn_award, pPropAct, pPlayerState)
    end

    for _, fn_award in ipairs(rgfn_active_act_invt) do
        fn_process_award(ctAwarders, fn_award, pPropAct, pPlayerState)
    end
end

function progress_player_state(ctAwarders, pQuestProp, pPlayerState)
    process_player_state_update(award_player, ctAwarders, pQuestProp, pPlayerState)
end

function rollback_player_state(ctAwarders, pQuestProp, pPlayerState)
    process_player_state_update(undo_award_player, ctAwarders, pQuestProp, pPlayerState)
end
