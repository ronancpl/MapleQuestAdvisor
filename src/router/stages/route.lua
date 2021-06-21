--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.graph")
require("router.procedures.constant")
require("router.procedures.graph.inner")
require("router.procedures.graph.outer")
require("router.procedures.player.update")
require("router.structs.path")
require("router.structs.trajectory")
require("router.structs.frontier.frontier")
require("router.structs.neighbor.arranger")
require("router.structs.recall.milestone")
require("solver.graph.lane")
require("structs.player")
require("structs.quest.properties")
require("utils.logger.file")
require("utils.struct.array")
require("utils.struct.ranked_set")
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

function make_quest_pool_list(tQuests)
    local rgpPool = SArray:new()

    for pQuest, _ in pairs(tQuests:get_entry_set()) do
        local pQuestProp

        pQuestProp = pQuest:get_start()
        pQuestProp:set_active_on_grid(true)
        rgpPool:add(pQuestProp)

        pQuestProp = pQuest:get_end()
        pQuestProp:set_active_on_grid(false)
        rgpPool:add(pQuestProp)
    end

    rgpPool:sort(fn_compare_quest_id)        -- in order to use bsearch with questid
    rgpPool:reverse()                        -- consumer takes item linearly

    return rgpPool:list()
end

local function route_quest_permit_complete(pQuestProp, pPlayerState)
    local pQuestEndProp = ctQuests:get_quest_by_id(pQuestProp:get_quest_id()):get_end()
    pQuestEndProp:set_active_on_grid(true)
end

local function route_quest_suppress_complete(pQuestProp, pPlayerState)
    local pQuestEndProp = ctQuests:get_quest_by_id(pQuestProp:get_quest_id()):get_end()
    pQuestEndProp:set_active_on_grid(false)
end

local tPathSearched = {}

local function print_path_search_counts()
    log(LPath.OVERALL, "log.txt", "Path length observed:")
    for k, v in pairs(tPathSearched) do
        log(LPath.OVERALL, "log.txt", "", k, v)
    end
end

local function route_path_copy(pQuestPath)
    local pPathNew = CQuestPath:new()

    local rgpQuestProps = pQuestPath:list()
    local nQuestProp = #rgpQuestProps
    for i = 1, nQuestProp, 1 do
        local pQuestProp = rgpQuestProps[i]
        local fVal = pQuestPath:get_node_value(i)
        local pQuestRoll = pQuestPath:get_node_allot(i)

        pPathNew:add(pQuestProp, pQuestRoll, fVal)
    end

    return pPathNew
end

function route_quest_attend_update(pQuestTree, pQuestMilestone, pFrontierQuests, pFrontierArranger, rgpPoolProps, pCurrentPath, pLeadingPath, pQuestProp, pPlayerState, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    route_quest_permit_complete(pQuestProp, pPlayerState)      -- allows visibility of quest ending

    local pQuestRoll
    local fValue
    fValue, pQuestRoll = evaluate_quest_utility(ctFieldsDist, ctAccessors, ctPlayersMeta, pQuestProp, pPlayerState)
    fValue = math.max(fValue, 0.001)

    pCurrentPath:add(pQuestProp, pQuestRoll, fValue)

    if pCurrentPath:value() > pLeadingPath:get_base_value() then    -- try add, ignores if not meet leaderboard
        pLeadingPath:insert(route_path_copy(pCurrentPath), pCurrentPath:value())
    end

    local iPathSize = pCurrentPath:size()
    tPathSearched[iPathSize] = (tPathSearched[iPathSize] or 0) + 1

    progress_player_state(ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)

    local rgpFrontierPoolProps = pFrontierArranger:update_visit(ctAccessors, pPlayerState, pQuestProp, rgpPoolProps)
    table.sort(rgpFrontierPoolProps, fn_compare_quest_id)

    local rgpNeighbors = fetch_neighbors(rgpFrontierPoolProps, pFrontierQuests, pCurrentPath, pPlayerState, ctAccessors)

    local pNeighborsMilestone = pQuestMilestone:get_subpath(rgpNeighbors)
    if pNeighborsMilestone ~= nil then  -- already found result for this subset of neighbors
        rgpNeighbors = {}
    end

    pQuestTree:push_node(pQuestProp, rgpNeighbors)

    for _, pNeighborProp in ipairs(rgpNeighbors) do
        pFrontierQuests:add(pNeighborProp, pPlayerState, ctAccessors)
    end
end

local function route_quest_log_returned_path(pCurrentPath, rgpBcktQuests)
    local sPath = "{"
    for _, pQuestProp in pairs(pCurrentPath:list()) do
        sPath = sPath .. pQuestProp:get_name(true) .. ", "
    end
    for i = #rgpBcktQuests, 1, -1 do
        local pQuestProp = rgpBcktQuests[i]
        sPath = sPath .. pQuestProp:get_name(true) .. ", "
    end
    sPath = sPath .. "}\n"

    log(LPath.QUEST_PATH, "path-" .. pCurrentPath:get_fetch_time() .. ".txt", sPath)
end

function route_quest_dismiss_update(pQuestTree, pQuestMilestone, pFrontierQuests, pFrontierArranger, rgpPoolProps, pCurrentPath, pPlayerState, ctAccessors, ctAwarders)
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

    local nBcktQuests = #rgpBcktQuests
    if nBcktQuests > 0 then
        route_quest_log_returned_path(pCurrentPath, rgpBcktQuests)

        for _, pBcktQuestProp in ipairs(rgpBcktQuests) do
            route_quest_suppress_complete(pBcktQuestProp, pPlayerState)
        end
    end

    return nBcktQuests
end

local function route_internal_node(rgpPoolProps, pFrontierQuests, pFrontierArranger, pPlayerState, pCurrentPath, pLeadingPath, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    local pQuestTree = CGraphTree:new()
    local pQuestMilestone = CGraphMilestone:new()

    pQuestTree:install_entries(rgpPoolProps)

    while true do
        local pQuestProp = pFrontierQuests:peek()
        if pQuestProp == nil then
            break
        elseif not pCurrentPath:is_in_path(pQuestProp) then
            pQuestProp:install_player_state(pPlayerState)       -- allow find quest requisites and rewards player-state specific

            route_quest_attend_update(pQuestTree, pQuestMilestone, pFrontierQuests, pFrontierArranger, rgpPoolProps, pCurrentPath, pLeadingPath, pQuestProp, pPlayerState, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
            local iBcktCount = route_quest_dismiss_update(pQuestTree, pQuestMilestone, pFrontierQuests, pFrontierArranger, rgpPoolProps, pCurrentPath, pPlayerState, ctAccessors, ctAwarders)

            local rgpRefeedQuests
            _, rgpRefeedQuests = pFrontierQuests:fetch(pQuestTree, iBcktCount)      -- retrieve all nodes from frontier that have been backtracked
            pFrontierQuests:restack_quests(rgpRefeedQuests)                         -- set skipped quests again for frontier checkout

            pFrontierQuests:update(pPlayerState)

            pQuestProp:extract_player_state()
        end
    end
end

local function route_internal(tQuests, pPlayer, pQuest, pLeadingPath, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    local pPlayerState = CPlayer:new(pPlayer)
    local pQuestProp = pQuest:get_start()
    local pCurrentPath = CQuestPath:new()

    local rgpPoolProps = make_quest_pool_list(tQuests)
    apply_initial_player_state(pPlayerState, rgpPoolProps)  -- set up quest properties for graphing

    if is_eligible_root_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors) then
        local pFrontierQuests = CQuestFrontier:new()
        pFrontierQuests:init(ctAccessors)

        pFrontierQuests:add(pQuestProp, pPlayerState, ctAccessors)

        local pFrontierArranger = CNeighborArranger:new()
        pFrontierArranger:init(ctAccessors, rgpPoolProps)

        route_internal_node(rgpPoolProps, pFrontierQuests, pFrontierArranger, pPlayerState, pCurrentPath, pLeadingPath, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    end
end

local function make_leading_paths()
    local pSetLeadingPath = SRankedSet:new()
    pSetLeadingPath:set_capacity(RGraph.LEADING_PATH_CAPACITY)

    return pSetLeadingPath
end

function route_graph_quests(tQuests, pPlayer, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    log(LPath.OVERALL, "log.txt", "Route quest board... (" .. tQuests:size() .. " quests)")

    local rgPoolQuests = make_pool_list(tQuests)

    local pLeadingPath = make_leading_paths()

    log(LPath.OVERALL, "log.txt", "Total of quests to search: " .. tQuests:size())
    while not rgPoolQuests:is_empty() do
        local pQuest = rgPoolQuests:remove_last()
        route_internal(tQuests, pPlayer, pQuest, pLeadingPath, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    end

    log(LPath.OVERALL, "log.txt", "Search finished.")

    --print_path_search_counts()
    return pLeadingPath
end
