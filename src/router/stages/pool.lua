--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.filters.graph")
require("utils.table")

local function randomize_quest_table_by_level()
    -- same level quests appears in arbitrary order

    ctQuests:randomize_quest_table()
    ctQuests:sort_quest_table()
end

function pool_init()
    randomize_quest_table_by_level()
end

function pool_select_graph_quests(pPlayer)
    local tQuests = ctQuests:fetch_top_quests_by_player(pPlayer, RGraph.POOL_MIN_QUESTS)
    return tQuests
end
