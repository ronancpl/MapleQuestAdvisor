--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("router.procedures.graph.outer")
require("router.procedures.player.update")
require("router.structs.frontier.frontier")
require("router.structs.neighbor.arranger")
require("router.structs.recall.milestone")
require("router.structs.path")
require("router.structs.trajectory")
require("structs.player")
require("utils.procedure.unpack")
require("utils.provider.io.wordlist")
require("utils.struct.ranked_set")

function csvify_route_quest_path(pLeadingPath)
    local rgsPaths = {}
    for pQuestPath, fVal in pairs(pLeadingPath:get_entry_set()) do
        local st = ""

        local rgpQuestProps = pQuestPath:list()
        local nQuestProps = #rgpQuestProps
        for i = 1, nQuestProps, 1 do
            local pQuestProp = rgpQuestProps[i]
            local fValIdx = pQuestPath:get_node_value(i)

            st = st .. pQuestProp:get_name() .. "," .. tostring(fValIdx) .. ","
        end

        st = st .. tostring(fVal)

        table.insert(rgsPaths, st)
    end

    return rgsPaths
end

local function make_leading_paths()
    local pSetLeadingPath = SRankedSet:new()
    pSetLeadingPath:set_capacity(RGraph.LEADING_PATH_CAPACITY)

    local pQuestPath = CQuestPath:new()
    pSetLeadingPath:insert(pQuestPath, 0.0)

    return pSetLeadingPath
end

local function find_quest_by_name(sQuestName)
    local iQuestid = tonumber(sQuestName:sub(1, -2))
    local bStart = string.starts_with(sQuestName:sub(-1), "S")

    local pQuest = ctQuests:get_quest_by_id(iQuestid)
    local pQuestProp = bStart and pQuest:get_start() or pQuest:get_end()

    return pQuestProp
end

local function load_quest_roll(pQuestProp, pPlayerState)
    local _, pQuestRoll = evaluate_quest_utility(ctFieldsDist, ctAccessors, ctPlayersMeta, pQuestProp, pPlayerState)
    return pQuestRoll
end

function csv_read_route_quest_path(rgsLines, pPlayerState)
    local pLeadingPath = make_leading_paths()
    for _, sLine in ipairs(rgsLines) do
        local rgsLineSp = split_csv(sLine)

        local sVal = table.remove(rgsLineSp)
        local fVal = tonumber(sVal)

        local pQuestPath = CQuestPath:new()

        local nSp = #rgsLineSp
        for i = 1, nSp, 2 do
            local sQuestName = rgsLineSp[i]
            local fValIdx = tonumber(rgsLineSp[i + 1])

            local pQuestProp = find_quest_by_name(sQuestName)
            local pQuestRoll = load_quest_roll(pQuestProp, pPlayerState)

            pQuestPath:add(pQuestProp, pQuestRoll, fValIdx)
        end

        pLeadingPath:insert(pQuestPath, fVal)
    end

    return pLeadingPath
end

local function load_quest_paths(rgsLines, pPlayer)
    local pLeadingPath = csv_read_route_quest_path(rgsLines, pPlayer)

    local rgpPaths = SArray:new()
    for _, pPath in ipairs(pLeadingPath:list()) do
        local rgpQuestProps = pPath:list()
        rgpPaths:add(rgpQuestProps)
    end

    return rgpPaths
end

local function route_internal_node(rgpPoolProps, rgpQuestProps, pFrontierQuests, pFrontierArranger, pPlayerState, pCurrentPath, pLeadingPath, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    local pQuestTree = CGraphTree:new()
    local pQuestMilestone = CGraphMilestone:new()

    pQuestTree:install_entries(rgpPoolProps)

    while true do
        local pQuestProp = pFrontierQuests:peek()
        if pQuestProp == nil then
            route_quest_backtrack_update(pQuestTree, pQuestMilestone, pFrontierArranger, rgpPoolProps, pCurrentPath, pPlayerState, ctAccessors, ctAwarders)
            break
        elseif not pCurrentPath:is_in_path(pQuestProp) and pCurrentPath:size() < RGraph.LANE_PATH_MAX_SIZE then
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

local function route_internal(tQuests, pPlayer, rgpQuestProps, pLeadingPath, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    local pPlayerState = pPlayer:clone()
    local pCurrentPath = CQuestPath:new()

    local rgpPoolProps = make_quest_pool_list(tQuests)
    apply_initial_player_state(pPlayerState, rgpPoolProps)  -- set up quest properties for graphing

    if #rgpQuestProps > 0 then
        local pQuestProp = rgpQuestProps[1]
        if is_eligible_root_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors) then
            local pFrontierQuests = CQuestFrontier:new()
            pFrontierQuests:init(ctAccessors)

            pFrontierQuests:add(pQuestProp, pPlayerState, ctAccessors)

            local pFrontierArranger = CNeighborArranger:new()
            pFrontierArranger:init(ctAccessors, rgpPoolProps)

            route_internal_node(rgpPoolProps, rgpQuestProps, pFrontierQuests, pFrontierArranger, pPlayerState, pCurrentPath, pLeadingPath, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
        end
    end
end

local function fetch_most_value_path(pLeadingPath, rgpPaths)
    local pMvPath = nil
    local fMaxVal = U_INT_MIN

    local tpItVal = pLeadingPath:get_entry_set()

    for _, pPath in ipairs(rgpPaths) do
        local fVal = tpItVal[pPath]
        if fMaxVal < fVal then
            pMvPath = pPath
            fMaxVal = fVal
        end
    end

    return pMvPath
end

function load_route_graph_quests(pPlayer, rgsPaths, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    local rgpFixedPaths = load_quest_paths(rgsPaths, pPlayer)

    log(LPath.OVERALL, "log.txt", "Load route quest board... (" .. tQuests:size() .. " quests)")

    local pLeadingPath = make_leading_paths()

    log(LPath.OVERALL, "log.txt", "Total of quests to search: " .. tQuests:size())
    while not rgpFixedPaths:is_empty() do
        local rgpQuestProps = rgpFixedPaths:remove_last()
        route_internal(tQuests, pPlayer, rgpQuestProps, pLeadingPath, ctAccessors, ctAwarders, ctFieldsDist, ctPlayersMeta)
    end

    log(LPath.OVERALL, "log.txt", "Search finished.")
    return pLeadingPath
end
