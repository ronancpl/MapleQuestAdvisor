--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.quest.quest")
require("router.stages.pool")
require("router.stages.route")
require("solver.graph.lane")

function generate_quest_route(pPlayer, pUiWmap)
    local pGridQuests = load_grid_quests(ctQuests)
    --pGridQuests:ignore_underleveled_quests(pPlayer:get_level())

    local tQuests = pool_select_graph_quests(pGridQuests, pPlayer)

    local tRoute = route_graph_quests(tQuests, pPlayer, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    local pRouteLane = generate_subpath_lane(tRoute)

    return pRouteLane, tQuests, tRoute
end
