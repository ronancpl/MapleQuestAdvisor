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

local function select_quest_ahead(pPlayerState, pTrack)
    local pQuestProp = pPlayerState:get_quests():get_item(pQuest:get_quest_id()) < 1 and pQuest:get_start() or pQuest:get_end()

    local pNextQuestProp = nil
    for _, pPath in pairs(pTrack:get_recommended_paths()) do
        pNextQuestProp = pPath:list()[1]
    end

    local pQuestProp
    if not pTrack:is_ahead(pQuestProp) then
        pQuestProp = pNextQuestProp
    end

    return pQuestProp
end

function fn_bt_nav_next(pUiHud, pTrack, pPlayerState, rgpPoolProps, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    local pSlctBox = pUiHud:get_nav_select_quest()

    local sQuestTitle = pSlctBox:get_text_opt()
    if sQuestTitle ~= nil then
        local pQuest = ctQuests:get_quest_by_title(sQuestTitle)
        if pQuest ~= nil then
            local pQuestProp = select_quest_ahead(pPlayerState, pTrack)

            player_lane_move_ahead(pTrack, pQuestProp, pPlayerState, rgpPoolProps)
            player_lane_look_ahead(pTrack, pPlayerState)

            player_lane_update_resources(pTrack, pUiRscs, pPlayerState)
            player_lane_update_selectbox(pTrack, pUiHud)
            player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
            player_lane_update_hud(pTrack, pUiHud)
        else
            log(LPath.FALLBACK, "quest_title.txt", "NOT found quest data for '" .. tostring(sQuestTitle) .. "'")
        end
    end
end

function fn_bt_nav_prev(pUiHud, pTrack, pPlayerState, rgpPoolProps, pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
    local bMovedBack = player_lane_move_back(pTrack, pPlayerState, rgpPoolProps)
    player_lane_trim_back(pTrack)

    if bMovedBack then
        player_lane_update_resources(pTrack, pUiRscs, pPlayerState)
        player_lane_update_selectbox(pTrack, pUiHud)
        player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pPlayer, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName, pUiRscs)
        player_lane_update_hud(pTrack, pUiHud)
    end
end
