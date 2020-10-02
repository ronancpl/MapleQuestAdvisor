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
require("router.procedures.quest.requirement.access")
require("structs.quest.attributes.property")
require("structs.quest.attributes.requirement")
require("utils.class")
require("utils.quest")

CQuestAccessors = createClass({
    tfn_strong_reqs = {},
    tfn_strong_ivt_reqs = {},
    tfn_weak_reqs = {},
    tfn_weak_ivt_reqs = {},
    tsAllReqs = {}
})

local function fn_invt_pending(pRet)
    return #pRet > 0
end

local function fn_unit_pending(pRet)
    return pRet > 0
end

function CQuestAccessors:is_player_have_prerequisite(pReqAcc, fn_pending, pPlayerState)
    local fn_req = pReqAcc:get_fn_pending()

    local pRet = fn_req(pReqAcc, pReqs, pPlayerState)
    if fn_pending(pRet) then
        return false
    end

    return true
end

function CQuestAccessors:_is_player_have_prerequisites(fn_pending, tfn_reqs, pPlayerState, pQuestReqs)
    for _, pReqAcc in ipairs(tfn_reqs) do
        if not self:is_player_have_prerequisite(pReqAcc, fn_pending, pPlayerState) then
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

function CQuestAccessors:_get_prerequisite_range_keys(bStrong, bInventory)
    local tsKeys = {}
    for _, v in ipairs(fetch_accessors(self, bStrong, bInventory)) do
        tsKeys[v:get_name()] = v:get_fn_player_property()
    end

    return tsKeys
end

function CQuestAccessors:get_accessor_range_keys()
    local tsInvtKeys = self:_get_prerequisite_range_keys(nil, true)
    local tsUnitKeys = self:_get_prerequisite_range_keys(nil, false)

    return tsInvtKeys, tsUnitKeys
end

function CQuestAccessors:get_accessor_by_name(sAccName)
    return self.tsAllReqs[sAccName]
end

function CQuestAccessors:_add_prerequisite_accessor(tfn_reqs, sAccName, fn_get_acc_property, fn_get_player_state_property, fn_diff_pending_type)
    local fn_diff_acc_pending = function(pQuestAcc, pQuestProp, pPlayerState)
        return fn_diff_pending_type(pQuestAcc, pQuestProp, fn_get_player_state_property(pPlayerState))
    end

    local pAcc = CQuestAccessor:new({sName = sAccName, fn_get_property = fn_get_acc_property, fn_get_player_property = fn_get_player_state_property, fn_diff_pending = fn_diff_acc_pending, fn_diff_pending_type = fn_diff_pending_type})

    table.insert(tfn_reqs, pAcc)
    self.tsAllReqs[sAccName] = pAcc
end

function init_quest_accessors()
    local ctAccessors = CQuestAccessors:new()

    local tfn_strong_reqs = ctAccessors.tfn_strong_reqs
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_FAME", CQuestProperty.get_fame, fn_get_player_state_fame, fn_diff_pending})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_DATE", CQuestRequirement.has_date_access, fn_get_player_state_date, fn_diff_zero})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_LVMIN", CQuestRequirement.get_level_min, fn_get_player_state_level_min, fn_diff_pending})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_LVMAX", CQuestRequirement.get_level_max, fn_get_player_state_level_max, fn_diff_pending})

    tfn_strong_reqs = ctAccessors.tfn_strong_ivt_reqs
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_QUESTS", CQuestProperty.get_quests, fn_get_player_state_quests, fn_diff_pending_list})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_SKILLS", CQuestProperty.get_skills, fn_get_player_state_skills, fn_diff_pending_list})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_JOBS", CQuestRequirement.has_job_access, fn_get_player_state_jobs, fn_diff_pending_list})

    local tfn_weak_reqs = ctAccessors.tfn_weak_reqs
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_EXP", CQuestProperty.get_exp, fn_get_player_state_exp, fn_diff_pending})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_MESO", CQuestProperty.get_meso, fn_get_player_state_meso, fn_diff_pending})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_NPC", CQuestRequirement.get_npc, fn_get_player_state_npc, fn_diff_zero})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_FIELD", CQuestRequirement.get_field, fn_get_player_state_field, fn_diff_zero})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_FIELD_ENTER", CQuestRequirement.get_field_enter, fn_get_player_state_field_enter, fn_diff_zero})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_REPEAT", CQuestRequirement.is_repeatable, fn_get_player_state_repeat, fn_diff_zero})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_SCRIPT", CQuestRequirement.has_script, fn_get_player_state_scripts, fn_diff_zero})

    tfn_weak_reqs = ctAccessors.tfn_weak_ivt_reqs
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_ITEMS", CQuestProperty.get_items, fn_get_player_state_items, fn_diff_pending_list})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_MOBS", CQuestProperty.get_mobs, fn_get_player_state_mobs, fn_diff_pending_list})

    return ctAccessors
end
