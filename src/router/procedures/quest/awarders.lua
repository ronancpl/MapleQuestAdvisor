--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.quest")
require("router.procedures.quest.awarder.awarder")
require("router.procedures.quest.awarder.property")
require("router.procedures.quest.awarder.update")
require("router.procedures.quest.awarder.item.property")
require("router.procedures.quest.awarder.item.update")
require("structs.quest.attributes.property")
require("structs.quest.attributes.requirement")
require("utils.struct.class")

CQuestAwarders = createClass({
    tfn_acts = {},
    tfn_ivt_acts = {},
    tsAllActs = {}
})

function CQuestAwarders:get_awarder_by_fn_award(fn_award_player_state_property)
    return self.tsAllActs[fn_award_player_state_property]
end

function CQuestAwarders:get_awarders_by_active_awards(pQuestProp, bInvt)
    local rgfn_active_act_unit
    local rgfn_active_act_invt
    rgfn_active_act_unit, rgfn_active_act_invt, _ = pQuestProp:get_rgfn_active_awards()

    local rgpAwds = {}

    if bInvt ~= false then
        for _, fn_get in ipairs(rgfn_active_act_invt) do
            local pAwd = self:get_awarder_by_fn_award(fn_get)
            if pAwd ~= nil then
                table.insert(rgpAwds, pAwd)
            end
        end
    end

    if bInvt ~= true then
        for _, fn_get in ipairs(rgfn_active_act_unit) do
            local pAwd = self:get_awarder_by_fn_award(fn_get)
            if pAwd ~= nil then
                table.insert(rgpAwds, pAwd)
            end
        end
    end

    return rgpAwds
end

local function fn_get_awd_property(fn_quest_reward)
    return function(pQuestProps)
        return fn_quest_reward(pQuestProps)
    end
end

function CQuestAwarders:_add_award_accessor(tfn_acts, sAccName, fn_quest_reward, fn_player_quest_rollback, fn_award_player_state_property)
    local pAwd = CQuestAwarder:new({sName = "_QUEST_AWARD_" .. sAccName, fn_quest_property = fn_get_awd_property(fn_quest_reward), fn_quest_rollback = fn_player_quest_rollback, fn_award_property = fn_award_player_state_property})

    table.insert(tfn_acts, pAwd)
    self.tsAllActs[fn_quest_reward] = pAwd
end

function init_quest_awarders()
    local ctAwarders = CQuestAwarders:new()

    local tfn_acts = ctAwarders.tfn_acts
    ctAwarders:_add_award_accessor(tfn_acts, RQuest.EXP.name, CQuestProperty.get_exp, fn_undo_unit, fn_award_player_state_exp)
    ctAwarders:_add_award_accessor(tfn_acts, RQuest.MESO.name, CQuestProperty.get_meso, fn_undo_unit, fn_award_player_state_meso)
    ctAwarders:_add_award_accessor(tfn_acts, RQuest.FAME.name, CQuestProperty.get_fame, fn_undo_unit, fn_award_player_state_fame)

    local tfn_ivt_acts = ctAwarders.tfn_ivt_acts
    ctAwarders:_add_award_accessor(tfn_ivt_acts, RQuest.SKILLS.name, CQuestProperty.get_skills, fn_undo_invt_insert, fn_award_player_state_skills)
    ctAwarders:_add_award_accessor(tfn_ivt_acts, RQuest.ITEMS.name, CQuestProperty.get_items, fn_undo_invt_item_add, fn_award_player_state_items)
    ctAwarders:_add_award_accessor(tfn_ivt_acts, RQuest.QUESTS.name, CQuestProperty.get_quests, fn_undo_no_change, fn_award_player_state_quests)
    --ctAwarders:_add_award_accessor(tfn_ivt_acts, RQuest.JOBS.name, CQuestRequirement.has_job_access, fn_undo_invt_insert, fn_award_player_state_jobs)

    return ctAwarders
end
