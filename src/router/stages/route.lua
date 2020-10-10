--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.graph.outer")
require("router.procedures.player.update")
require("router.structs.path")
require("router.structs.trajectory")
require("router.structs.frontier.frontier")
require("structs.player")
require("utils.array")

local function make_pool_list(tQuests)
    local rgpQuests = SArray:new()

    for pQuest, _ in pairs(tQuests:get_entry_set()) do
        rgpQuests:add(pQuest)
    end

    return rgpQuests
end

local function make_available_neighbors_list(tQuests)
    local tpPool = CQuestPath:new()

    for pQuest, _ in pairs(tQuests:get_entry_set()) do
        local pQuestProp = pQuest:get_start()
        tpPool:add(pQuestProp)
    end

    return tpPool
end

local function route_quest_permit_complete(tpPoolProps, pQuestProp, pPlayerState)

end

local function route_quest_suppress_complete(tpPoolProps, pQuestProp, pPlayerState)

end

local function route_quest_attend_update(pQuestTree, tpPoolProps, pCurrentPath, pQuestProp, pPlayerState, ctAccessors, ctAwarders, pFrontierQuests)
    route_quest_permit_complete(tpPoolProps, pQuestProp, pPlayerState)      -- allows visibility of quest ending

    local rgpNeighbors = fetch_neighbors(tpPoolProps, pCurrentPath, pPlayerState, ctAccessors)
    pQuestTree:push_node(pQuestProp, rgpNeighbors)

    rollback_player_state(ctAwarders, pQuestProp, pPlayerState)
    pCurrentPath:add(pQuestProp)

    for _, pNeighborProp in ipairs(rgpNeighbors) do
        pFrontierQuests:add(pNeighborProp, pPlayerState, ctAccessors)
    end
end

local function route_quest_dismiss_update(pQuestTree, tpPoolProps, pCurrentPath, pPlayerState, ctAwarders)
    local rgpBcktQuests = {}

    while not pQuestTree:is_empty() do
        local pQuestProp = pQuestTree:try_pop_node()
        if pQuestProp == nil then
            return
        end

        if pCurrentPath:remove(pQuestProp) then     -- back tracking from the current path
            progress_player_state(ctAwarders, pQuestProp, pPlayerState)
            table.insert(rgpBcktQuests, pQuestProp)
        end
    end

    for _, pBcktQuestProp in ipairs(rgpBcktQuests) do
        route_quest_suppress_complete(tpPoolProps, pBcktQuestProp, pPlayerState)
    end
end

local function route_internal_node(tpPoolProps, pFrontierQuests, pPlayerState, pCurrentPath, pLeadingPath, ctAccessors, ctAwarders)
    local pQuestTree = CGraphTree:new()

    while true do
        local pQuestProp = pFrontierQuests:fetch()
        if pQuestProp == nil then
            break
        end

        route_quest_attend_update(pQuestTree, tpPoolProps, pCurrentPath, pQuestProp, pPlayerState, ctAccessors, ctAwarders, pFrontierQuests, ctAccessors)

        route_quest_dismiss_update(pQuestTree, tpPoolProps, pCurrentPath, pPlayerState, ctAwarders)

        pFrontierQuests:update(pPlayerState)
    end
end

local function route_internal(tQuests, pPlayer, pQuest, pLeadingPath, ctAccessors, ctAwarders)
    local pPlayerState = CPlayer:new(pPlayer)
    local pQuestProp = pQuest:get_start()
    local pCurrentPath = CQuestPath:new()

    if is_eligible_root_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors) then
        local pFrontierQuests = CQuestFrontier:new()
        pFrontierQuests:init(ctAccessors)

        pFrontierQuests:add(pQuestProp, pPlayerState, ctAccessors)

        local tpPool = make_available_neighbors_list(tQuests)
        route_internal_node(tpPool, pFrontierQuests, pPlayerState, pCurrentPath, pLeadingPath, ctAccessors, ctAwarders)
    end
end

function route_graph_quests(tQuests, pPlayer, ctAccessors, ctAwarders)
    local rgPoolQuests = make_pool_list(tQuests)
    local pLeadingPath = CQuestPath:new()

    while not rgPoolQuests:is_empty() do
        local pQuest = rgPoolQuests:remove_last()
        route_internal(tQuests, pPlayer, pQuest, pLeadingPath, ctAccessors, ctAwarders)
    end

    return pLeadingPath
end
