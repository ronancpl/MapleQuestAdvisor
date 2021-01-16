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
require("solver.procedures.curve")
require("solver.procedures.inventory")

local function evaluate_fitness_exp(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    return get_fitness_level_coefficient(ctPlayersMeta, iPlayerLevel, pQuestActProp:get_exp()) * RQuest.EXP.Boost
end

local function evaluate_fitness_meso(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    return get_fitness_level_coefficient(ctPlayersMeta, iPlayerLevel, pQuestActProp:get_meso()) * RQuest.MESO.Boost
end

local function evaluate_fitness_fame(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    return pQuestActProp:get_fame() * RQuest.FAME.Boost
end

local function evaluate_fitness_skill(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    local ivtSkills = pQuestActProp:get_skills()
    return ivtSkills:size() * RQuest.SKILLS.Boost
end

--[[
local function evaluate_fitness_job_adv(ctPlayersMeta, pQuestActProp, iPlayerLevel)

end
]]--

local function evaluate_fitness_inventory(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    local ivtItems = pQuestActProp:get_items()
    local tiTypeCount = fetch_inventory_split_count(ivtItems:get_items())

    local rgpTypeFit = {RQuest.ITEMS.EQUIP, RQuest.ITEMS.USE, RQuest.ITEMS.SETUP, RQuest.ITEMS.ETC}
    local sFitType = "Boost"

    local iValue = 0.0
    for iType, iCount in pairs(tiTypeCount) do
        iValue = iValue + calc_type_fitness(rgpTypeFit, sFitType, iType, iCount)
    end

    return iValue
end

function evaluate_quest_fitness(ctPlayersMeta, pQuestProp, pPlayerState)
    local pQuestActProp = pQuestProp:get_action()
    local iPlayerLevel = pPlayerState:get_level()

    local iValue = 0.0
    iValue = iValue + evaluate_fitness_exp(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    iValue = iValue + evaluate_fitness_meso(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    iValue = iValue + evaluate_fitness_fame(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    iValue = iValue + evaluate_fitness_skill(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    --iValue = iValue + evaluate_fitness_job_adv(ctPlayersMeta, pQuestActProp, iPlayerLevel)
    iValue = iValue + evaluate_fitness_inventory(ctPlayersMeta, pQuestActProp, iPlayerLevel)

    return iValue
end
