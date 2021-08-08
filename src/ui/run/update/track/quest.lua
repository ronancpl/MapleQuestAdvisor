--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.update.navigation")

local function select_quest_ahead(pPlayerState, pTrack, iOpt)
    local rgsQuestProps = {}
    for _, pPath in pairs(pTrack:get_recommended_paths()) do
        local pQuestProp = pPath:list()[1]
        table.insert(rgsQuestProps, pQuestProp)
    end

    return rgsQuestProps[iOpt]
end

function fn_bt_nav_next(pUiHud, pTrack, pPlayerState, rgpPoolProps, pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, siExpRate, siMesoRate, siDropRate, sWmapName)
    local pSlctBox = pUiHud:get_nav_select_quest()

    local iOpt = pSlctBox:get_opt()
    if iOpt ~= nil then
        local pQuestProp = select_quest_ahead(pPlayerState, pTrack, iOpt)
        if pQuestProp ~= nil then
            player_lane_move_ahead(pTrack, pQuestProp, pPlayerState, rgpPoolProps)
            player_lane_look_ahead(pTrack, pPlayerState)
            pUiWmap:reset_region(pUiRscs, pPlayerState)

            player_lane_update_resources(pTrack, pUiRscs, pPlayerState)
            player_lane_update_selectbox(pTrack, pUiHud)
            player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, pPlayerState, siExpRate, siMesoRate, siDropRate, sWmapName)
            player_lane_update_hud(pTrack, pUiHud)
        end
    end
end

function fn_bt_nav_prev(pUiHud, pTrack, pPlayerState, rgpPoolProps, pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, siExpRate, siMesoRate, siDropRate, sWmapName)
    local bMovedBack = player_lane_move_back(pTrack, pPlayerState, rgpPoolProps)
    player_lane_trim_back(pTrack)
    pUiWmap:reset_region(pUiRscs, pPlayerState)

    if bMovedBack then
        player_lane_update_resources(pTrack, pUiRscs, pPlayerState)
        player_lane_update_selectbox(pTrack, pUiHud)
        player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, pPlayerState, siExpRate, siMesoRate, siDropRate, sWmapName)
        player_lane_update_hud(pTrack, pUiHud)
    end
end
