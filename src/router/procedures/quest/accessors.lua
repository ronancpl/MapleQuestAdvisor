--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.quest.accessor.accessor")
require("structs.quest.attributes.property")
require("structs.quest.attributes.requirement")
require("utils.class")

CQuestAccessors = createClass({
    tfn_strong_reqs = {},
    tfn_strong_ivt_reqs = {},
    tfn_weak_reqs = {},
    tfn_weak_ivt_reqs = {},
})

local function fn_invt_pending(pRet)
    return #pRet > 0
end

local function fn_unit_pending(pRet)
    return pRet > 0
end

function CQuestAccessors:_is_player_have_prerequisites(fn_pending, tfn_reqs, pPlayerState, pQuestReqs)
    for _, pReqAcc in ipairs(tfn_reqs) do
        local fn_req = pReqAcc:get_fn_pending()

        local pRet = fn_req(pReqAcc, pReqs, pPlayerState)
        if fn_pending(pRet) then
            return false
        end
    end

    return true
end

function CQuestAccessors:is_player_have_prerequisites(bStrong, pPlayerState, pQuestProp)
    local pQuestReqs = pQuestProp:get_requirement()

    return self._is_player_have_prerequisites(fn_unit_pending, bStrong and self.tfn_strong_reqs or self.tfn_weak_reqs, pPlayerState, pQuestReqs)
                and self._is_player_have_prerequisites(fn_invt_pending, bStrong and self.tfn_strong_ivt_reqs or self.tfn_weak_ivt_reqs, pPlayerState, pQuestReqs)
end

function init_quest_accessors()
    local ctAccessors = CQuestAccessors:new()

    local tfn_strong_reqs = ctAccessors.tfn_strong_reqs
    table.insert(tfn_strong_reqs, CQuestAccessor:new({sName = "_QUEST_GET_FAME", fn_get_property = CQuestProperty.get_fame, fn_diff_pending = fn_quest_diff_pending_fame}))
    table.insert(tfn_strong_reqs, CQuestAccessor:new({sName = "_QUEST_GET_DATE", fn_get_property = CQuestRequirement.has_date_access, fn_diff_pending = fn_quest_diff_pending_date}))
    table.insert(tfn_strong_reqs, CQuestAccessor:new({sName = "_QUEST_GET_LVMIN", fn_get_property = CQuestRequirement.get_level_min, fn_diff_pending = fn_quest_diff_pending_level_min}))
    table.insert(tfn_strong_reqs, CQuestAccessor:new({sName = "_QUEST_GET_LVMAX", fn_get_property = CQuestRequirement.get_level_max, fn_diff_pending = fn_quest_diff_pending_level_max}))

    tfn_strong_reqs = ctAccessors.tfn_strong_ivt_reqs
    table.insert(tfn_strong_reqs, CQuestAccessor:new({sName = "_QUEST_GET_QUESTS", fn_get_property = CQuestProperty.get_quests, fn_diff_pending = fn_quest_diff_pending_quests}))
    table.insert(tfn_strong_reqs, CQuestAccessor:new({sName = "_QUEST_GET_SKILLS", fn_get_property = CQuestProperty.get_skills, fn_diff_pending = fn_quest_diff_pending_skills}))
    table.insert(tfn_strong_reqs, CQuestAccessor:new({sName = "_QUEST_GET_JOBS", fn_get_property = CQuestRequirement.has_job_access, fn_diff_pending = fn_quest_diff_pending_jobs}))

    local tfn_weak_reqs = ctAccessors.tfn_weak_reqs
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_EXP", fn_get_property = CQuestProperty.get_exp, fn_diff_pending = fn_quest_diff_pending_exp}))
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_MESO", fn_get_property = CQuestProperty.get_meso, fn_diff_pending = fn_quest_diff_pending_meso}))
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_NPC", fn_get_property = CQuestRequirement.get_npc, fn_diff_pending = fn_quest_diff_pending_npc}))
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_FIELD", fn_get_property = CQuestRequirement.get_field, fn_diff_pending = fn_quest_diff_pending_field}))
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_FIELD_ENTER", fn_get_property = CQuestRequirement.get_field_enter, fn_diff_pending = fn_quest_diff_pending_field_enter}))
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_REPEAT", fn_get_property = CQuestRequirement.is_repeatable, fn_diff_pending = fn_quest_diff_pending_repeat}))
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_SCRIPT", fn_get_property = CQuestRequirement.has_script, fn_diff_pending = fn_quest_diff_pending_script}))

    tfn_weak_reqs = ctAccessors.tfn_weak_ivt_reqs
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_ITEMS", fn_get_property = CQuestProperty.get_items, fn_diff_pending = fn_quest_diff_pending_items}))
    table.insert(tfn_weak_reqs, CQuestAccessor:new({sName = "_QUEST_GET_MOBS", fn_get_property = CQuestProperty.get_mobs, fn_diff_pending = fn_quest_diff_pending_mobs}))

    return ctAccessors
end
