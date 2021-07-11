--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("composer.quest.quest")
require("router.procedures.quest.accessors")
require("router.procedures.quest.awarders")
require("router.stages.load")
require("router.stages.map")
require("router.stages.pool")
require("router.stages.route")
require("solver.procedures.lookup")
require("structs.player")

local function create_player()
    local pPlayer = CPlayer:new({iId = 1, iMapid = 2000000, siLevel = 50, siJob = 122})

    return pPlayer
end

load_resources()

load_regions_overworld(ctFieldsDist, ctFieldsLink)
load_distances_overworld(ctFieldsLandscape, ctFieldsDist, ctFieldsMeta, ctFieldsWmap, ctFieldsLink)

load_script_resources()
load_loot_retrieval_resources()

for i = 1, 100, 1 do
    local pGridQuests = load_grid_quests(ctQuests)
    local pPlayer = create_player()
    pGridQuests:ignore_underleveled_quests(pPlayer:get_level())

    ctAccessors = init_quest_accessors()
    ctAwarders = init_quest_awarders()

    print("Generation graph #" .. i)
    local tQuests = pool_select_graph_quests(pGridQuests, pPlayer)

    local tRoute = route_graph_quests(tQuests, pPlayer, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
end
