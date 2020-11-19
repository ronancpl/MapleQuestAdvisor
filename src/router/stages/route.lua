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
require("router.structs.neighbor.arranger")
require("router.structs.recall.milestone")
require("structs.player")
require("structs.quest.properties")
require("utils.struct.array")
require("utils.struct.table")

local function make_pool_list(tQuests)
    local rgpQuests = SArray:new()

    for pQuest, _ in pairs(tQuests:get_entry_set()) do
        rgpQuests:add(pQuest)
    end

    return rgpQuests
end

local function fn_compare_quest_id(a, b)
    return CQuestProperties.compare(a, b) < 0
end

local function make_quest_pool_list(tQuests)
    local rgpPool = SArray:new()

    for pQuest, _ in pairs(tQuests:get_entry_set()) do
        local pQuestProp

        pQuestProp = pQuest:get_start()
        rgpPool:add(pQuestProp)

        pQuestProp = pQuest:get_end()
        rgpPool:add(pQuestProp)
    end

    rgpPool:sort(fn_compare_quest_id)        -- in order to use bsearch with questid
    rgpPool:reverse()                        -- consumer takes item linearly

    return rgpPool
end

local function route_quest_permit_complete(rgpQuestProps, pQuestProp, pPlayerState)

end

local function route_quest_suppress_complete(rgpQuestProps, pQuestProp, pPlayerState)

end

local function is_quest_attainable(ctAccessors, pQuestProp, pPlayerState)
    return ctAccessors:is_player_have_prerequisites(true, pPlayerState, pQuestProp)
end

local tPathSearched = {}

local function print_path_search_counts()
    print("Path length observed:")
    for k, v in pairs(tPathSearched) do
        print("", k, v)
    end
end

local function route_quest_attend_update(pQuestTree, pQuestMilestone, pFrontierQuests, pFrontierArranger, rgpPoolProps, pCurrentPath, pQuestProp, pPlayerState, ctAccessors, ctAwarders)
    route_quest_permit_complete(rgpPoolProps, pQuestProp, pPlayerState)      -- allows visibility of quest ending

    pCurrentPath:add(pQuestProp)

    local iPathSize = pCurrentPath:size()
    tPathSearched[iPathSize] = tPathSearched[iPathSize] and (tPathSearched[iPathSize] + 1) or 1

    progress_player_state(ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)

    local rgpFrontierPoolProps = pFrontierArranger:update_visit(ctAccessors, pPlayerState, pQuestProp)
    local rgpNeighbors = fetch_neighbors(rgpFrontierPoolProps, pCurrentPath, pPlayerState, ctAccessors)

    local pNeighborsMilestone = pQuestMilestone:get_subpath(rgpNeighbors)
    if pNeighborsMilestone ~= nil then  -- already found result for this subset of neighbors
        rgpNeighbors = {}
    end

    pQuestTree:push_node(pQuestProp, rgpNeighbors)

    for _, pNeighborProp in ipairs(rgpNeighbors) do
        pFrontierQuests:add(pNeighborProp, pPlayerState, ctAccessors)
    end
end

local function route_quest_dismiss_update(pQuestTree, pQuestMilestone, pFrontierQuests, pFrontierArranger, rgpPoolProps, pCurrentPath, pPlayerState, ctAccessors, ctAwarders)
    local rgpBcktQuests = {}

    while not pQuestTree:is_empty() do
        local pQuestProp = pQuestTree:try_pop_node()
        if pQuestProp == nil then
            break
        end

        if pCurrentPath:remove(pQuestProp) then     -- back tracking from the current path
            rollback_player_state(ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
            pFrontierArranger:rollback_visit(ctAccessors, pQuestProp)
            table.insert(rgpBcktQuests, pQuestProp)

            pQuestMilestone:add_subpath(rgpBcktQuests)
        end
    end

    for _, pBcktQuestProp in ipairs(rgpBcktQuests) do
        route_quest_suppress_complete(rgpPoolProps, pBcktQuestProp, pPlayerState)
        pFrontierQuests:fetch()
    end
end

local function route_internal_node(rgpPoolProps, pFrontierQuests, pFrontierArranger, pPlayerState, pCurrentPath, pLeadingPath, ctAccessors, ctAwarders)
    local pQuestTree = CGraphTree:new()
    local pQuestMilestone = CGraphMilestone:new()

    while true do
        local pQuestProp = pFrontierQuests:peek()
        if pQuestProp == nil then
            break
        end

        pFrontierQuests:fetch()

        route_quest_attend_update(pQuestTree, pQuestMilestone, pFrontierQuests, pFrontierArranger, rgpPoolProps, pCurrentPath, pQuestProp, pPlayerState, ctAccessors, ctAwarders)

        route_quest_dismiss_update(pQuestTree, pQuestMilestone, pFrontierQuests, pFrontierArranger, rgpPoolProps, pCurrentPath, pPlayerState, ctAccessors, ctAwarders)

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

        local rgpPoolProps = make_quest_pool_list(tQuests)

        local pFrontierArranger = CNeighborArranger:new()
        pFrontierArranger:init(ctAccessors, rgpPoolProps)

        route_internal_node(rgpPoolProps, pFrontierQuests, pFrontierArranger, pPlayerState, pCurrentPath, pLeadingPath, ctAccessors, ctAwarders)
    end
end

function route_graph_quests(tQuests, pPlayer, ctAccessors, ctAwarders)
    print("Route quest board... (" .. tQuests:size() .. " quests)")

    local rgPoolQuests = make_pool_list(tQuests)
    local pLeadingPath = CQuestPath:new()

    print("Total of quests to search: " .. tQuests:size())
    while not rgPoolQuests:is_empty() do
        local pQuest = rgPoolQuests:remove_last()
        route_internal(tQuests, pPlayer, pQuest, pLeadingPath, ctAccessors, ctAwarders)
    end

    print("Search finished.")
    print_path_search_counts()
    return pLeadingPath
end
