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
require("solver.graph.build")

local function generate_quest_resource_graph(ivtItems, ivtMobs, iPlayerMapid, iQuestNpcMapid)
    local pQuestResource = build_quest_resource_bean(ivtItems, ivtMobs)

    local pRscTree = build_quest_resource_graph(pQuestResource, ctFieldsLandscape, ctFieldsDist, ctFieldsLink, ctLoots, ctMobs, ctReactors, iPlayerMapid, iQuestNpcMapid)
    return pRscTree
end

function evaluate_quest_distance(pQuestProp, pPlayerState)
    PLAYER_MAP -> START_MAP -> START_REQS -> START_FIELD_ENTER -> END_MAP -> END_REQS -> END_FIELD_ENTER
end
