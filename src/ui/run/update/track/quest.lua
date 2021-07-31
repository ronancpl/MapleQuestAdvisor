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

function fn_bt_nav_next(pUiHud, pTrack, pPlayerState, rgpPoolProps, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    local sQuestTitle = pUiHud:get_nav_select_quest():get_text_selected()
    if sQuestTitle ~= nil then
        local pQuestProp = ctQuests:get_quest_by_title(sQuestTitle)

        player_lane_move_ahead(pTrack, pQuestProp, pPlayerState, rgpPoolProps)
        player_lane_look_ahead(pTrack, pPlayerState)

        player_lane_update_selectbox(pTrack, pUiHud)
        player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
        pUiHud:set_player_quest(pTrack)
    end
end

function fn_bt_nav_prev(pUiHud, pTrack, pPlayerState, rgpPoolProps, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    player_lane_move_back(pTrack, pPlayerState, rgpPoolProps)
    player_lane_trim_back(pTrack)

    player_lane_update_selectbox(pTrack, pUiHud)
    player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    pUiHud:set_player_quest(pTrack)
end
