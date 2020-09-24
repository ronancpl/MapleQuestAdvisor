--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.structs.path")
require("router.structs.trajectory")
require("structs.player")
require("utils.array")

local function make_pool_list(tQuests)
    local rgpQuests = SArray:new()

    for pQuest, _ in pairs(tQuests:get_entry_set()) do
        rgpQuests:add(pQuest)
    end

    return rgpQuests
end

local function route_quest_attend_update(pQuestTree, pCurrentPath, pQuestProp, pPlayerState)
    pQuestTree:push_node(pQuestProp, NEIGHBORS)

    UPDATE_WITH_QUEST_PROGRESS
    pCurrentPath:add(pQuestProp)
end

local function route_quest_dismiss_update(pQuestTree, pCurrentPath, pPlayerState)
    while not pQuestTree:is_empty() do
        local pQuestProp = try_pop()
        if pQuestProp == nil then
            return
        end

        if pCurrentPath:remove(pQuestProp) then     -- back tracking from the current path
            UN_UPDATE_WITH_QUEST_PROGRESS
        end
    end
end

local function route_internal_node(rgFrontierQuests, pPlayerState, pCurrentPath, pLeadingPath)
    local pQuestTree = CGraphTree:new()

    while not rgFrontierQuests:is_empty() do
        local pQuestProp = rgFrontierQuests:remove_last()

        if not pCurrentPath:is_in_path(pQuestProp) then
            if is_route_quest_meet_prerequisites(pQuestProp, pPlayerState) then
                EVAL_QUEST(pQuestProp, pPlayerState)
                if WORTH_PROGRESS then
                    route_quest_attend_update(pQuestTree, pCurrentPath, pQuestProp, pPlayerState)

                    for _, pNeighborProp in ipairs(NEIGHBORS) do
                        rgFrontierQuests:add(pNeighborProp)
                    end
                end
            end
        end

        route_quest_dismiss_update(pQuestTree, pCurrentPath, pQuestProp, pPlayerState)
    end
end

local function route_internal(tQuests, pPlayerState, pQuest, pLeadingPath)
    local pQuestProp = pQuest:get_start()

    local rgFrontierQuests = SArray:new()
    rgFrontierQuests:add(pQuestProp)

    local pCurrentPath = CQuestPath:new()
    route_internal_node(rgFrontierQuests, pPlayerState, pCurrentPath, pLeadingPath)
end

function route_graph_quests(tQuests, pPlayer)
    local pPlayerState = CPlayer:new(pPlayer)
    local rgPoolQuests = make_pool_list(tQuests)

    local pLeadingPath = CQuestPath:new()

    while not rgPoolQuests:is_empty() do
        local pQuest = rgPoolQuests:remove_last()
        route_internal(tQuests, pPlayerState, pQuest, pCurrentPath, pLeadingPath)
    end

    return pLeadingPath
end
