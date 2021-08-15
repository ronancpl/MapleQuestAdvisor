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
require("solver.graph.tree.component")
require("ui.constant.view.button")

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
        progress_player_state(ctAwarders, ctQuests:get_quest_by_id(1034):get_end(), pPlayerState, rgpPoolProps)
    else
        log(LPath.FALLBACK, "quest_lane.txt", " NOT FOUND quest " .. tostring(pQuestProp:get_name()) .. " ON ROUTE '" .. pTrack:to_string() .. "'")
    end
end

function player_lane_move_back(pTrack, pPlayerState, rgpPoolProps)
    local pQuestProp = pTrack:move_back()
    if pQuestProp ~= nil then
        rollback_player_state(ctAwarders, pQuestProp, pPlayerState, rgpPoolProps)
        return true
    else
        log(LPath.FALLBACK, "quest_lane.txt", " TRACK BASE REACHED")
        return false
    end
end

function player_lane_look_ahead(pTrack, pPlayerState)
    pTrack:look_ahead(pPlayerState, false)
end

function player_lane_trim_back(pTrack)
    pTrack:trim_back()
end

function player_lane_update_resources(pTrack, pUiRscs, pPlayerState)
    local pRscTree = nil
    local pQuestProp = pTrack:get_top_quest()
    if pQuestProp ~= nil then
        local pPath = pTrack:get_top_lane():get_path_by_quest(pQuestProp)
        if pPath ~= nil then
            pRscTree = pPath:get_node_allot(1):get_resource_tree()
        else
            log(LPath.FALLBACK, "quest_lane.txt", " Could not find " .. tostring(pQuestProp:get_name()) .. " in Path")
        end
    end

    pUiRscs:update_resources(pQuestProp, pRscTree or CSolverTree:new())
end

function player_lane_update_selectbox(pTrack, pUiHud)
    local rgsTextList = {}
    for _, pPath in ipairs(pTrack:get_recommended_paths()) do
        local pQuestProp = pPath:list()[1]
        table.insert(rgsTextList, pQuestProp:get_title())
    end

    local pSlctQuest = pUiHud:get_nav_select_quest()
    pSlctQuest:set_text_options(rgsTextList, RActionElement.NAV_NEXT_QUEST.LINE_WIDTH)
end

function player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName)
    pUiInvt:update_inventory(pIvtItems, pPlayer:get_meso())
    pUiStats:update_stats(pPlayer, siExpRate, siMesoRate, siDropRate)
    pUiWmap:update_region(sWmapName, pUiRscs)
end

function player_lane_update_hud(pTrack, pUiHud)
    pUiHud:set_player_quest(pTrack)
end
