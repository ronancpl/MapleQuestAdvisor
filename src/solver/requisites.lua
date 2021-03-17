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
require("solver.procedures.coefficient")
require("solver.procedures.curve")
require("solver.procedures.inventory")

local function evaluate_cost_exp(pReqAcc, pPlayerState, pQuestChkProp, ctPlayersMeta, iPlayerLevel, pQuestRoll)
    local iRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)

    pQuestRoll:set_requisite_exp(iRet)

    return get_fitness_level_coefficient(ctPlayersMeta, iPlayerLevel, iRet) * RQuest.EXP.Curb
end

local function evaluate_cost_meso(pReqAcc, pPlayerState, pQuestChkProp, ctPlayersMeta, iPlayerLevel, pQuestRoll)
    local iRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)

    pQuestRoll:set_requisite_meso(iRet)

    return get_fitness_level_coefficient(ctPlayersMeta, iPlayerLevel, iRet) * RQuest.MESO.Curb
end

local function evaluate_cost_fame(pReqAcc, pPlayerState, pQuestChkProp, pQuestRoll)
    local iRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)

    pQuestRoll:set_requisite_fame(iRet)

    return iRet * RQuest.FAME.Curb
end

local function evaluate_cost_skill(pReqAcc, pPlayerState, pQuestChkProp, pQuestRoll)
    local pRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)

    pQuestRoll:set_requisite_skills(pRet)

    return (next(pRet) ~= nil and 1 or 0) * RQuest.SKILLS.Curb
end

local function evaluate_cost_job(pReqAcc, pPlayerState, pQuestChkProp, pQuestRoll)
    local iRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)

    pQuestRoll:has_requisite_job(iRet > 0)

    return iRet * RQuest.JOBS.Curb
end

local function evaluate_cost_mob(pReqAcc, pPlayerState, pQuestChkProp, pQuestRoll)
    local pRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)

    pQuestRoll:set_requisite_mobs(pRet)

    local iCount = fetch_inventory_count(pRet)

    local rgpTypeFit = {RQuest.MOBS}
    local sFitType = "Curb"

    local iValue = calc_type_fitness(rgpTypeFit, sFitType, 1, iCount)
    return iValue
end

local function evaluate_cost_quest(pReqAcc, pPlayerState, pQuestChkProp, pQuestRoll)
    local pRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)

    pQuestRoll:set_requisite_quests(pRet)

    return (next(pRet) ~= nil and 1 or 0) * RQuest.QUESTS.Curb
end

local function evaluate_cost_inventory(pReqAcc, pPlayerState, pQuestChkProp, pQuestRoll)
    local tiItems = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestChkProp)

    pQuestRoll:set_requisite_items(tiItems)

    tiItems = fetch_effective_unit_count_to_inventory(tiItems, pPlayerState)

    local tiTypeCount = fetch_inventory_split_count(tiItems)

    local rgpTypeFit = {RQuest.ITEMS.EQUIP, RQuest.ITEMS.USE, RQuest.ITEMS.SETUP, RQuest.ITEMS.ETC}
    local sFitType = "Curb"

    local iValue = 0.0
    for iType, iCount in pairs(tiTypeCount) do
        iValue = iValue + calc_type_fitness(rgpTypeFit, sFitType, iType, iCount)
    end

    return iValue
end

function evaluate_quest_requisites(ctAccessors, ctPlayersMeta, pQuestProp, pPlayerState, pQuestRoll)
    local pQuestChkProp = pQuestProp:get_requirement()
    local iPlayerLevel = pPlayerState:get_level()

    local iValue = 0.0
    iValue = iValue + evaluate_cost_exp(ctAccessors:get_accessor_by_type(RQuest.EXP.name), pPlayerState, pQuestChkProp, ctPlayersMeta, iPlayerLevel, pQuestRoll)
    iValue = iValue + evaluate_cost_meso(ctAccessors:get_accessor_by_type(RQuest.MESO.name), pPlayerState, pQuestChkProp, ctPlayersMeta, iPlayerLevel, pQuestRoll)
    iValue = iValue + evaluate_cost_fame(ctAccessors:get_accessor_by_type(RQuest.FAME.name), pPlayerState, pQuestChkProp, pQuestRoll)
    iValue = iValue + evaluate_cost_skill(ctAccessors:get_accessor_by_type(RQuest.SKILLS.name), pPlayerState, pQuestChkProp, pQuestRoll)
    iValue = iValue + evaluate_cost_job(ctAccessors:get_accessor_by_type(RQuest.JOBS.name), pPlayerState, pQuestChkProp, pQuestRoll)
    iValue = iValue + evaluate_cost_mob(ctAccessors:get_accessor_by_type(RQuest.MOBS.name), pPlayerState, pQuestChkProp, pQuestRoll)
    iValue = iValue + evaluate_cost_quest(ctAccessors:get_accessor_by_type(RQuest.QUESTS.name), pPlayerState, pQuestChkProp, pQuestRoll)
    iValue = iValue + evaluate_cost_inventory(ctAccessors:get_accessor_by_type(RQuest.ITEMS.name), pPlayerState, pQuestChkProp, pQuestRoll)

    return iValue
end
