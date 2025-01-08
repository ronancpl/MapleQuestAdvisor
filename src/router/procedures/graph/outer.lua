--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.player.quest")
require("router.procedures.player.update")
require("router.structs.path")
require("utils.procedure.print")

local function is_route_quest_in_path(pQuestProp, pCurrentPath)
    return pCurrentPath:is_in_path(pQuestProp)
end

local function is_route_quest_accessible(pQuestProp, pPlayerState, ctAccessors)
    local bMetJob = pQuestProp:get_requirement():has_job_access()
    return ctAccessors:is_player_have_prerequisites(true, pPlayerState, pQuestProp) and bMetJob > 0
end

local function is_eligible_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors)
    if not pQuestProp:is_active_on_grid() then
        return false
    end

    if is_quest_state_achieved(pPlayerState, pQuestProp) then
        return false
    end

    if is_route_quest_in_path(pQuestProp, pCurrentPath) then
        return false
    end

    return true
end

function is_eligible_root_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors)
    local bEligible = is_eligible_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors)
    local bMetReqs = is_route_quest_accessible(pQuestProp, pPlayerState, ctAccessors)

    return bEligible and bMetReqs
end

local function fetch_eligible_neighbor(rgpNeighbors, pQuestProp, pFrontierQuests, pCurrentPath, pPlayerState, ctAccessors)
    -- same as is_eligible_root_quest

    if is_eligible_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors) then
        local bMetReqs = pFrontierQuests:is_quest_accessible(pQuestProp) or is_route_quest_accessible(pQuestProp, pPlayerState, ctAccessors)
        if bMetReqs then
            table.insert(rgpNeighbors, pQuestProp)
        end
    end
end

function fetch_neighbors(rgpPoolProps, pFrontierQuests, pCurrentPath, pPlayerState, ctAccessors)
    local rgpNeighbors = {}

    local pQuestCurrent = pCurrentPath:peek()
    local iNextQuestid = pQuestCurrent:get_next_quest_id()
    if iNextQuestid ~= -1 then     -- select next quest from questline over quests from the pool
        local pQuestProp = ctQuests:get_quest_by_id(iNextQuestid):get_start()
        fetch_eligible_neighbor(rgpNeighbors, pQuestProp, pFrontierQuests, pCurrentPath, pPlayerState, ctAccessors)
    end

    if #rgpNeighbors == 0 then
        for _, pQuestProp in ipairs(rgpPoolProps) do
            fetch_eligible_neighbor(rgpNeighbors, pQuestProp, pFrontierQuests, pCurrentPath, pPlayerState, ctAccessors)
        end
    end

    return rgpNeighbors
end
