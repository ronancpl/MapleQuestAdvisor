--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.quest.awarder.property")
require("structs.storage.inventory")

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

local function process_player_job_update(pPlayerState, rgpPoolProps)
    local siJobid = pPlayerState:get_job()

    for _, pQuestProp in ipairs(rgpPoolProps) do
        local pQuestChkProp = pQuestProp:get_requirement()
        pQuestChkProp:set_job_access(siJobid)
    end
end

local function process_player_quest_update(pQuestProp, pPlayerState, bUndo)
    local rgpGet = CInventory:new()
    rgpGet:add_item(pQuestProp:get_quest_id(), pQuestProp:is_start() and 1 or 2)    -- updates this quest progress to the player

    fn_award_player_state_quests(pPlayerState, rgpGet, bUndo)
end

local function process_player_state_update(fn_process_award, ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
    local rgfn_active_act_unit
    local rgfn_active_act_invt
    local pPropAct

    local siPlayerJob = pPlayerState:get_job()
    rgfn_active_act_unit, rgfn_active_act_invt, pPropAct = pQuestProp:get_rgfn_active_awards()
    for _, fn_award in ipairs(rgfn_active_act_unit) do
        fn_process_award(ctAwarders, fn_award, pPropAct, pPlayerState)
    end

    for _, fn_award in ipairs(rgfn_active_act_invt) do
        fn_process_award(ctAwarders, fn_award, pPropAct, pPlayerState)
    end

    local iCurJob = pPlayerState:get_job()
    if siPlayerJob ~= iCurJob then
        process_player_job_update(pPlayerState, rgpPoolProps)
    end
end

function progress_player_state(ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
    process_player_quest_update(pQuestProp, pPlayerState, false)
    process_player_state_update(award_player, ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
end

function rollback_player_state(ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
    process_player_quest_update(pQuestProp, pPlayerState, true)
    process_player_state_update(undo_award_player, ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
end

function apply_initial_player_state(pPlayerState, rgpPoolProps)
    process_player_job_update(pPlayerState, rgpPoolProps)
end
