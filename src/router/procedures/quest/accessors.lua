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
    local rgsKeys = {}
    for _, v in ipairs(fetch_accessors(self, bStrong, bInventory)) do
        table.insert(rgsKeys, v:get_name())
    end

    return rgsKeys
end

function CQuestAccessors:get_accessor_range_keys()
    local rgsInvtKeys = self:_get_prerequisite_range_keys(nil, true)
    local rgsUnitKeys = self:_get_prerequisite_range_keys(nil, false)

    return rgsInvtKeys, rgsUnitKeys
end

function CQuestAccessors:get_accessor_by_name(sAccName)
    return self.tsAllReqs[sAccName]
end

function CQuestAccessors:_add_prerequisite_accessor(tfn_reqs, sAccName, fn_get_acc_property, fn_diff_acc_pending)
    local pAcc = CQuestAccessor:new({sName = sAccName, fn_get_property = fn_get_acc_property, fn_diff_pending = fn_diff_acc_pending})

    table.insert(tfn_reqs, pAcc)
    self.tsAllReqs[sAccName] = pAcc
end

function init_quest_accessors()
    local ctAccessors = CQuestAccessors:new()

    local tfn_strong_reqs = ctAccessors.tfn_strong_reqs
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_FAME", CQuestProperty.get_fame, fn_quest_diff_pending_fame})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_DATE", CQuestRequirement.has_date_access, fn_quest_diff_pending_date})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_LVMIN", CQuestRequirement.get_level_min, fn_quest_diff_pending_level_min})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_LVMAX", CQuestRequirement.get_level_max, fn_quest_diff_pending_level_max})

    tfn_strong_reqs = ctAccessors.tfn_strong_ivt_reqs
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_QUESTS", CQuestProperty.get_quests, fn_quest_diff_pending_quests})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_SKILLS", CQuestProperty.get_skills, fn_quest_diff_pending_skills})
    ctAccessors:_add_prerequisite_accessor(tfn_strong_reqs, "_QUEST_GET_JOBS", CQuestRequirement.has_job_access, fn_quest_diff_pending_jobs})

    local tfn_weak_reqs = ctAccessors.tfn_weak_reqs
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_EXP", CQuestProperty.get_exp, fn_quest_diff_pending_exp})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_MESO", CQuestProperty.get_meso, fn_quest_diff_pending_meso})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_NPC", CQuestRequirement.get_npc, fn_quest_diff_pending_npc})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_FIELD", CQuestRequirement.get_field, fn_quest_diff_pending_field})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_FIELD_ENTER", CQuestRequirement.get_field_enter, fn_quest_diff_pending_field_enter})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_REPEAT", CQuestRequirement.is_repeatable, fn_quest_diff_pending_repeat})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_SCRIPT", CQuestRequirement.has_script, fn_quest_diff_pending_script})

    tfn_weak_reqs = ctAccessors.tfn_weak_ivt_reqs
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_ITEMS", CQuestProperty.get_items, fn_quest_diff_pending_items})
    ctAccessors:_add_prerequisite_accessor(tfn_weak_reqs, "_QUEST_GET_MOBS", CQuestProperty.get_mobs, fn_quest_diff_pending_mobs})

    return ctAccessors
end
