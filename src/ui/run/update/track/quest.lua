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
    local rgpQuestProps = {}
    for _, pPath in ipairs(pTrack:get_recommended_paths()) do
        local pQuestProp = pPath:list()[1]
        table.insert(rgpQuestProps, pQuestProp)
    end

    return rgpQuestProps[iOpt]
end

local function is_worldmap_container(iWmapid1, iWmapid2)
    return iWmapid1 == iWmapid2 or iWmapid1 == (math.floor(iWmapid2 / 10) * 10)
end

local function fetch_name_worldmap_container(sWmapName, iMapid)
    local sBaseWmapName = "WorldMap"
    local iWmapid = tonumber(sWmapName:sub(-3))

    if iWmapid == nil or not is_worldmap_container(iWmapid, ctFieldsWmap:get_worldmapid_by_area(iMapid)) then
        sWmapName = sBaseWmapName
    end

    return sWmapName
end

function fn_bt_nav_next(pUiHud, rgpPoolProps, pUiWmap, pUiStats, pUiInvt, pUiRscs, siExpRate, siMesoRate, siDropRate)
    local pTrack = pUiWmap:get_properties():get_track()
    local pPlayerState = pUiWmap:get_properties():get_player()

    local pSlctBox = pUiHud:get_nav_select_quest()
    local iOpt = pSlctBox:get_opt()
    if iOpt ~= nil then
        local pQuestProp = select_quest_ahead(pPlayerState, pTrack, iOpt)
        if pQuestProp ~= nil then
            player_lane_move_ahead(pTrack, pQuestProp, pPlayerState, rgpPoolProps)
            player_lane_look_ahead(pTrack, pPlayerState)

            local sWmapName = pUiWmap:get_properties():get_worldmap_name()
            pUiWmap:reset_region(pUiRscs, pPlayerState)

            sWmapName = fetch_name_worldmap_container(sWmapName,pPlayerState:get_mapid())

            player_lane_update_resources(pTrack, pUiRscs, pPlayerState)
            player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pUiRscs, pPlayerState, siExpRate, siMesoRate, siDropRate, sWmapName)
            player_lane_update_hud(pTrack, pUiHud)
            player_lane_update_selectbox(pTrack, pUiHud)
        end
    end
end

function fn_bt_nav_prev(pUiHud, rgpPoolProps, pUiWmap, pUiStats, pUiInvt, pUiRscs, siExpRate, siMesoRate, siDropRate, sWmapName)
    local pTrack = pUiWmap:get_properties():get_track()
    local pPlayerState = pUiWmap:get_properties():get_player()

    local bMovedBack = player_lane_move_back(pTrack, pPlayerState, rgpPoolProps)
    player_lane_trim_back(pTrack)

    local sWmapName = pUiWmap:get_properties():get_worldmap_name()
    pUiWmap:reset_region(pUiRscs, pPlayerState)

    if bMovedBack then
        sWmapName = fetch_name_worldmap_container(sWmapName, pPlayerState:get_mapid())

        player_lane_update_resources(pTrack, pUiRscs, pPlayerState)
        player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pUiRscs, pPlayerState, siExpRate, siMesoRate, siDropRate, sWmapName)
        player_lane_update_hud(pTrack, pUiHud)
        player_lane_update_selectbox(pTrack, pUiHud)

        pUiHud:get_nav_select_quest():reset()
    end
end
