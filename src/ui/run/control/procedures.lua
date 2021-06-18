--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.path")
require("router.stages.pool")
require("router.stages.route")
require("solver.graph.lane")
require("ui.struct.path.pathing")

local function load_route_save(pGridQuests, pPlayer)
    local tQuests = pool_read_graph_quests(pGridQuests, RPath.SAV_ROUTE)
    local tRoute = route_graph_quests(tQuests, pPlayer, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)

    local pRouteLane = generate_subpath_lane(tRoute)

    local pTrack = CTracePath:new()
    pTrack:load(pRouteLane)

    return pTrack
end

function run_bt_load(pGridQuests, pPlayer)  -- loads last quest laning action
    load_route_save(pGridQuests, pPlayer)
end

local function write_route_save(tQuests)
    pool_write_graph_quests(tQuests, RPath.SAV_ROUTE)
end

function run_bt_save(pTrack)  -- saves last quest laning action
    write_route_save(tQuests)
end
