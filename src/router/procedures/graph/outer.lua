--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.player.quest")
require("router.procedures.player.update")
require("router.structs.path")
require("utils.print")

local function is_route_quest_in_path(pQuestProp, pCurrentPath)
    return pCurrentPath:is_in_path(pQuestProp)
end

local function is_eligible_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors)
    if is_quest_state_achieved(pPlayerState, pQuestProp) then
        return false
    end

    if is_route_quest_in_path(pQuestProp, pCurrentPath) then
        return false
    end

    return true
end

function is_eligible_root_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors)
    return is_eligible_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors)
end

function fetch_neighbors(tpPoolProps, pCurrentPath, pPlayerState, ctAccessors)
    local rgpNeighbors = {}

    for _, pQuestProp in pairs(tpPoolProps:list()) do
        if is_eligible_quest(pQuestProp, pCurrentPath, pPlayerState, ctAccessors) then
            table.insert(rgpNeighbors, pQuestProp)
        end
    end

    return rgpNeighbors
end
