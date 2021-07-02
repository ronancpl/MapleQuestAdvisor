--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.player.update")

function player_lane_move_ahead(pTrack, pQuestProp, pPlayerState, rgpPoolProps)
    local bSuccess = pTrack:move_ahead(pQuestProp)
    if bSuccess then
        progress_player_state(ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
    else
        log(LPath.FALLBACK, "quest_lane.txt", " NOT FOUND quest " .. tostring(pQuestProp:get_name()) .. " ON ROUTE '" .. pTrack:to_string() .. "'")
    end
end

function player_lane_move_back(pTrack, pPlayerState, rgpPoolProps)
    local pQuestProp = pTrack:move_back()
    if pQuestProp ~= nil then
        rollback_player_state(ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
    else
        log(LPath.FALLBACK, "quest_lane.txt", " TRACK BASE REACHED")
    end
end
