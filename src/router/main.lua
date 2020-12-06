--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("router.procedures.quest.accessors")
require("router.procedures.quest.awarders")
require("router.stages.load")
require("router.stages.map")
require("router.stages.pool")
require("router.stages.route")
require("structs.player")

local function create_player()
    local pPlayer = CPlayer:new({iMapid = 2000000, siLevel = 50, siJob = 122})

    return pPlayer
end

load_resources()

load_regions_overworld(ctFieldsDist, ctFieldsLink)
load_distances_overworld(ctFieldsLandscape, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)

for i = 1, 100, 1 do
    local pGridQuests = load_grid_quests(ctQuests)
    local pPlayer = create_player()

    print("Generation graph #" .. i)
    local tQuests = pool_select_graph_quests(pGridQuests, pPlayer)

    ctAccessors = init_quest_accessors()
    ctAwarders = init_quest_awarders()
    local tRoute = route_graph_quests(tQuests, pPlayer, ctAccessors, ctAwarders, ctPlayersMeta)
end
