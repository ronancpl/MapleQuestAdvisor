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
require("router.procedures.player.update")

local function lookahead_lane_on_move(pTrack, pPlayerState)
    local iMinAhead = U_INT_MAX
    for _, pPath in ipairs(pTrack:get_paths()) do
        iMinAhead = math.min(iMinAhead, pPath:size())
    end

    if iMinAhead <= RWndConfig.TRACK.MAX_AHEAD_TO_BROAD_SEARCH then
        pTrack:look_ahead(pPlayerState, true)   -- moved one quest, find routes for each branch
    end
end

function player_lane_move_ahead(pTrack, pQuestProp, pPlayerState, rgpPoolProps)
    local bSuccess = pTrack:move_ahead(pQuestProp)
    if bSuccess then
        lookahead_lane_on_move(pTrack, pPlayerState)
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

function player_lane_look_ahead(pTrack, pPlayerState)
    pTrack:look_ahead(pPlayerState, false)
end

function player_lane_trim_back(pTrack)
    pTrack:trim_back()
end
