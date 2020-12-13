--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.quest")
require("solver.procedures.coefficient")
require("solver.procedures.inventory")

local function evaluate_cost_exp(pReqAcc, pPlayerState, pQuestActProp, ctPlayersMeta, iPlayerLevel)
    local iRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestActProp)
    return get_fitness_level_coefficient(ctPlayersMeta, iPlayerLevel, iRet) * RQuest.EXP.Curb
end

local function evaluate_cost_meso(pReqAcc, pPlayerState, pQuestActProp, ctPlayersMeta, iPlayerLevel)
    local iRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestActProp)
    return get_fitness_level_coefficient(ctPlayersMeta, iPlayerLevel, iRet) * RQuest.MESO.Curb
end

local function evaluate_cost_fame(pReqAcc, pPlayerState, pQuestActProp)
    local iRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestActProp)
    return iRet * RQuest.FAME.Curb
end

local function evaluate_cost_skill(pReqAcc, pPlayerState, pQuestActProp)
    local pRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestActProp)
    return (next(pRet) ~= nil and 1 or 0) * RQuest.Curb.SKILL
end

local function evaluate_cost_job(pReqAcc, pPlayerState, pQuestActProp)
    local iRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestActProp)
    return iRet * RQuest.Curb.JOB
end

local function evaluate_cost_mob(pReqAcc, pPlayerState, pQuestActProp)
    local pRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestActProp)
    return fetch_inventory_count(pRet) * RQuest.MOBS.Curb
end

local function evaluate_cost_quest(pReqAcc, pPlayerState, pQuestActProp)
    local pRet = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestActProp)
    return (next(pRet) ~= nil and 1 or 0) * RQuest.QUESTS.Curb
end

local function evaluate_cost_inventory(pReqAcc, pPlayerState, pQuestActProp)
    local ivtItems = fetch_accessor_remaining_requirement(pReqAcc, pPlayerState, pQuestActProp)

    local tiTypeCount = fetch_inventory_split_count(ivtItems)
    local rgpCurbMod = {RQuest.ITEMS.EQUIP.Curb, RQuest.ITEMS.USE.Curb, RQuest.ITEMS.SETUP.Curb, RQuest.ITEMS.ETC.Curb}

    local iValue = 0.0
    for iType, iCount in pairs(tiTypeCount) do
        iValue = iValue + (iCount * rgpCurbMod[iType])
    end

    return iValue
end

function evaluate_quest_requisites(ctAccessors, ctPlayersMeta, pQuestProp, pPlayerState)
    local pQuestActProp = pQuestProp:get_action()
    local iPlayerLevel = pPlayerState:get_level()

    local iValue = 0.0
    iValue = iValue + evaluate_cost_exp(ctAccessors:get_accessor_by_type(RQuest.EXP.name), pPlayerState, pQuestActProp, ctPlayersMeta, iPlayerLevel)
    iValue = iValue + evaluate_cost_meso(ctAccessors:get_accessor_by_type(RQuest.MESO.name), pPlayerState, pQuestActProp, ctPlayersMeta, iPlayerLevel)
    iValue = iValue + evaluate_cost_fame(ctAccessors:get_accessor_by_type(RQuest.FAME.name), pPlayerState, pQuestActProp)
    iValue = iValue + evaluate_cost_skill(ctAccessors:get_accessor_by_type(RQuest.SKILLS.name), pPlayerState, pQuestActProp)
    iValue = iValue + evaluate_cost_job(ctAccessors:get_accessor_by_type(RQuest.JOBS.name), pPlayerState, pQuestActProp)
    iValue = iValue + evaluate_cost_mob(ctAccessors:get_accessor_by_type(RQuest.MOBS.name), pPlayerState, pQuestActProp)
    iValue = iValue + evaluate_cost_quest(ctAccessors:get_accessor_by_type(RQuest.QUESTS.name), pPlayerState, pQuestActProp)
    iValue = iValue + evaluate_cost_inventory(ctAccessors:get_accessor_by_type(RQuest.ITEMS.name), pPlayerState, pQuestActProp)

    return iValue
end
