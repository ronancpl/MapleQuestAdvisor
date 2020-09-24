--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.quest.accessor.property")
require("structs.quest.attributes.requirement")
require("utils.class")

CQuestAccessor = createClass({
    sName = "_NIL",
    fn_get_property,
    fn_diff_pending
})

function CQuestAccessor:new(sName, fn_get_property, fn_diff_pending)
    self.sName = sName
    self.fn_get_property = fn_get_property
    self.fn_diff_pending = fn_diff_pending

    return self
end

function CQuestAccessor:get_fn_pending()
    return self.fn_diff_pending
end

function init_quest_accessors()
    local tfn_strong_reqs = {}
    table.insert(tfn_strong_reqs, CQuestAccessor:new("_QUEST_GET_FAME", CQuestProperty.get_fame, fn_quest_diff_pending_fame))
    table.insert(tfn_strong_reqs, CQuestAccessor:new("_QUEST_GET_QUESTS", CQuestProperty.get_quests, fn_quest_diff_pending_quests))
    table.insert(tfn_strong_reqs, CQuestAccessor:new("_QUEST_GET_SKILLS", CQuestProperty.get_skills, fn_quest_diff_pending_skills))
    table.insert(tfn_strong_reqs, CQuestAccessor:new("_QUEST_GET_JOBS", CQuestRequirement.has_job_access, fn_quest_diff_pending_jobs))
    table.insert(tfn_strong_reqs, CQuestAccessor:new("_QUEST_GET_DATE", CQuestRequirement.has_date_access, fn_quest_diff_pending_date))
    table.insert(tfn_strong_reqs, CQuestAccessor:new("_QUEST_GET_LVMIN", CQuestRequirement.get_level_min, fn_quest_diff_pending_level_min))
    table.insert(tfn_strong_reqs, CQuestAccessor:new("_QUEST_GET_LVMAX", CQuestRequirement.get_level_max, fn_quest_diff_pending_level_max))

    local tfn_weak_reqs = {}
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_EXP", CQuestProperty.get_exp, fn_quest_diff_pending_exp))
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_MESO", CQuestProperty.get_meso, fn_quest_diff_pending_meso))
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_ITEMS", CQuestProperty.get_items, fn_quest_diff_pending_items))
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_MOBS", CQuestProperty.get_mobs, fn_quest_diff_pending_mobs))
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_NPC", CQuestRequirement.get_npc, fn_quest_diff_pending_npc))
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_FIELD", CQuestRequirement.get_field, fn_quest_diff_pending_field))
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_FIELD_ENTER", CQuestRequirement.get_field_enter, fn_quest_diff_pending_field_enter))
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_REPEAT", CQuestRequirement.is_repeatable, fn_quest_diff_pending_repeat))
    table.insert(tfn_weak_reqs, CQuestAccessor:new("_QUEST_GET_SCRIPT", CQuestRequirement.has_script, fn_quest_diff_pending_script))

    return tfn_weak_reqs, tfn_strong_reqs
end
