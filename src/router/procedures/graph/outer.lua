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

function fetch_neighbors(tpPoolProps, pCurrentPath, pPlayerState)
    local rgpNeighbors = {}

    for _, pQuestProp in pairs(tpPoolProps:list()) do
        if IN_REQUIREMENT(pQuestProp) and NOT_COMPLETE(pQuestProp, pPlayerState) then
            table.insert(rgpNeighbors, pQuestProp)
        end
    end

    return rgpNeighbors
end

function update_player_state(pQuestProp, pPlayerState, bUndo)
end

function is_route_quest_in_path(pQuestProp, pCurrentPath)
    return pCurrentPath:is_in_path(pQuestProp)
end

function is_route_quest_meet_prerequisites(ctAccessors, pQuestProp, pPlayerState)
    return ctAccessors:is_player_have_prerequisites(true, pPlayerState, pQuestProp)
end
