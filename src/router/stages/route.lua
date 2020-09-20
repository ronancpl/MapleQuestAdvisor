--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function make_pool_list(tQuests)
    local rgpQuests = SArray:new()

    for pQuest, _ in pairs(tQuests) do
        rgpQuests:add(pQuest)
    end

    return rgpQuests
end

local function fetch_neighbors(tQuests, pPlayer)

end

local function does_meet_prerequisites(pQuest, pPlayerState)

end

local function update_player_state(pQuest, pPlayerState, bUndo)

end

local function route_internal(tQuests, pPlayer)

end

function route_graph_quests(tQuests, pPlayer)
    local pPlayerState = CPlayer:new(pPlayer)
    local rgFrontierQuests = make_pool_list(tQuests)

    local pQuestPath = SArray:new()

    local pLeadingPath = {}
    local iLeadingReward = 0.0

    while not rgFrontierQuests:is_empty() do
        local pQuest = rgFrontierQuests:remove_last()

    end

    return pBestPath
end
