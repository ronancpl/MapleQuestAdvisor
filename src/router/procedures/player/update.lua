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

    local fn_get = pAwd:get_fn_quest_property()
    local fn_award = pAwd:get_fn_award_property()

    local rgpGet = fn_get(pQuestProp)
    fn_award(pPlayerState, rgpGet, false)
end

local function undo_award_player(ctAwarders, fn_award_key, pQuestProp, pPlayerState)
    local pAwd = ctAwarders:get_awarder_by_fn_award(fn_award_key)

    local fn_get = pAwd:get_fn_quest_property()
    local fn_pnot = pAwd:get_fn_quest_rollback()
    local fn_award = pAwd:get_fn_award_property()

    local rgpGet = fn_get(pQuestProp)
    rgpGet = fn_pnot(rgpGet)
    fn_award(pPlayerState, rgpGet, true)
end

function progress_player_state(ctAwarders, pQuestProp, pPlayerState)
    local rgfn_active_awards = pQuestProp:get_rgfn_active_awards()
    for _, fn_award in ipairs(rgfn_active_awards) do
        award_player(ctAwarders, fn_award, pQuestProp, pPlayerState)
    end
end

function rollback_player_state(ctAwarders, pQuestProp, pPlayerState)
    local rgfn_active_awards = pQuestProp:get_rgfn_active_awards()
    for _, fn_award in ipairs(rgfn_active_awards) do
        undo_award_player(ctAwarders, fn_award, pQuestProp, pPlayerState)
    end
end
