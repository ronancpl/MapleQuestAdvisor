--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.quest.awarder.property")
require("router.procedures.quest.awarder.update")
require("structs.quest.attributes.property")
require("structs.quest.attributes.requirement")
require("utils.class")

CQuestAwarders = createClass({
    tfn_acts,
    tfn_ivt_acts,
    tsAllActs = {}
})

function CQuestAwarders:get_awarder_by_fn_award(fn_award_player_state_property)
    return self.tsAllActs[fn_award_player_state_property]
end

function CQuestAwarders:_add_award_accessor(tfn_acts, sAccName, fn_get_quest_property, fn_player_quest_rollback, fn_award_player_state_property)
    local pAwd = CQuestAwarder:new({sName = sAccName, fn_quest_property = fn_get_quest_property, fn_quest_rollback = fn_player_quest_rollback, fn_award_property = fn_award_player_state_property})

    table.insert(tfn_acts, pAwd)
    self.tsAllReqs[fn_award_player_state_property] = pAwd
end

function init_quest_awarders()
    local ctAwarders = CQuestAwarders:new()

    local tfn_acts = ctAccessors.tfn_acts
    ctAwarders:_add_award_accessor(tfn_acts, "_QUEST_AWARD_EXP", CQuestProperty.get_exp, fn_undo_unit, fn_award_player_state_exp)
    ctAwarders:_add_award_accessor(tfn_acts, "_QUEST_AWARD_MESO", CQuestProperty.get_meso, fn_undo_unit, fn_award_player_state_meso)
    ctAwarders:_add_award_accessor(tfn_acts, "_QUEST_AWARD_FAME", CQuestProperty.get_fame, fn_undo_unit, fn_award_player_state_fame)

    local tfn_ivt_acts = ctAccessors.tfn_ivt_acts
    ctAwarders:_add_award_accessor(tfn_ivt_acts, "_QUEST_AWARD_SKILLS", CQuestProperty.get_skills, fn_undo_invt_insert, fn_award_player_state_skills)
    ctAwarders:_add_award_accessor(tfn_ivt_acts, "_QUEST_AWARD_ITEMS", CQuestProperty.get_items, fn_undo_invt_add, fn_award_player_state_items)
    ctAwarders:_add_award_accessor(tfn_ivt_acts, "_QUEST_AWARD_QUESTS", CQuestProperty.get_quests, fn_undo_no_change, fn_award_player_state_quests)
    ctAwarders:_add_award_accessor(tfn_ivt_acts, "_QUEST_AWARD_JOBS", CQuestRequirement.has_job_access, fn_undo_invt_insert, fn_award_player_state_jobs)

    return ctAwarders
end
