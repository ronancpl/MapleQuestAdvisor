--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("solver.allot")
require("solver.distances")
require("solver.rewards")
require("solver.requisites")

function evaluate_quest_utility(ctFieldsDist, ctAccessors, ctPlayersMeta, pQuestProp, pPlayerState)
    local pQuestRoll = CQuestResult:new()

    local iDistReqs = evaluate_quest_distance(ctFieldsDist, ctAccessors, pQuestProp, pPlayerState, pQuestRoll)
    local iWeightReqs = evaluate_quest_requisites(ctAccessors, ctPlayersMeta, pQuestProp, pPlayerState, pQuestRoll)
    local iUtilGains = evaluate_quest_fitness(ctPlayersMeta, pQuestProp, pPlayerState, pQuestRoll)

    local iUtilQuest = iUtilGains - iWeightReqs - iDistReqs
    return iUtilQuest, pQuestRoll
end
