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
require("router.procedures.quest.requisites")

local function fetch_neighbors(tQuests, pPlayer)

end

local function does_meet_prerequisites(pQuest, pPlayerState)

end

local function update_player_state(pQuest, pPlayerState, bUndo)

end

local function is_route_quest_in_path(pQuestProp, pCurrentPath)
    return pCurrentPath:is_in_path(pQuestProp)
end

local function is_route_quest_meet_prerequisites(pQuestProp, pPlayerState)
    return is_player_have_strong_prerequisites(pPlayerState, pQuestProp)
end
