--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.userdata.rates")
require("router.procedures.userdata.player.character")
require("router.procedures.userdata.player.inventory")
require("ui.interaction.handler")
require("ui.interaction.window")
require("ui.run.control.player")
require("ui.run.control.rates")
require("ui.run.control.route")
require("ui.run.load.basic")
require("ui.run.load.hud")
require("ui.run.load.inventory")
require("ui.run.load.resource")
require("ui.run.load.stat")
require("ui.run.load.worldmap")
require("ui.struct.path.logging")
require("utils.logger.file")

log(LPath.INTERFACE, "load.txt", "Loading action handler...")
pEventHdl = CActionHandler:new()
pEventHdl:reset()
pEventHdl:install("ui.interaction.run.basic")
pEventHdl:install("ui.interaction.run.hud")
pEventHdl:install("ui.interaction.run.inventory")
pEventHdl:install("ui.interaction.run.stat")
pEventHdl:install("ui.interaction.run.worldmap")
pEventHdl:install("ui.interaction.run.resource")

log(LPath.INTERFACE, "load.txt", "Loading user data...")
local pPlayer = load_csv_player("../" .. RPath.SAV_UPATH .. "/character.csv")
load_csv_inventory(pPlayer, "../" .. RPath.SAV_UPATH .. "/inventory.csv", function (pPlayer) return pPlayer:get_items():get_inventory() end)
load_csv_inventory(pPlayer, "../" .. RPath.SAV_UPATH .. "/quest.csv", function (pPlayer) return pPlayer:get_quests() end)

local siExpRate, siMesoRate, siDropRate = load_csv_rates("../" .. RPath.SAV_UPATH .. "/rates.csv")

log(LPath.INTERFACE, "load.txt", "Loading user interface...")
pWndHandler = CWndHandler:new()

pFrameBasic = load_frame_basic()
pUiHud = CWndHud:new()

pUiWmap = load_frame_worldmap()
pUiInvt = load_frame_player_inventory()
pUiStats = load_frame_stat()
pUiRscs = load_frame_quest_resources()

local pIvtItems = pPlayer:get_items():get_inventory()
pUiInvt:update_inventory(pIvtItems, pPlayer:get_meso())
log(LPath.INTERFACE, "load.txt", "Visualizing inventory '" .. pIvtItems:tostring() .. "'")

local sWmapName = "WorldMap"
log(LPath.INTERFACE, "load.txt", "Visualizing region '" .. sWmapName .. "'")
local iMapid = pPlayer:get_mapid()
pPlayer:move_access_mapid(iMapid)
pPlayer:move_access_mapid(iMapid)
pUiWmap:set_player(pPlayer)

local _, tQuests, tRoute

local bStartup = true
if bStartup then
    local pPlayerRoute = pPlayer:clone()
    _, tQuests, tRoute = generate_quest_route(pPlayerRoute, pUiWmap)

    --pUiHud:_fn_bt_save(pPlayer, pUiStats, tRoute, tQuests)
else
    --pUiHud:_fn_bt_load(pUiStats, pPlayer)
    --pUiHud:_fn_bt_go(pPlayer)
end

pUiRscs:update_resources(nil, CSolverTree:new())
pUiWmap:update_region(sWmapName, pUiRscs)

local pTrack = pUiWmap:get_properties():get_track()
pUiHud = load_frame_hud(pPlayer, pUiStats, pTrack, tRoute, tQuests, pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, siExpRate, siMesoRate, siDropRate, sWmapName)

player_lane_update_resources(pTrack, pUiRscs, pPlayer)
player_lane_update_selectbox(pTrack, pUiHud)
player_lane_update_stats(pUiWmap, pUiStats, pUiInvt, pUiRscs, pIvtItems, pPlayer, siExpRate, siMesoRate, siDropRate, sWmapName)
player_lane_update_hud(pTrack, pUiHud)

pEventHdl:bind("ui.interaction.run.inventory", pUiInvt)
pEventHdl:bind("ui.interaction.run.stat", pUiStats)
pEventHdl:bind("ui.interaction.run.worldmap", pUiWmap)
pEventHdl:bind("ui.interaction.run.resource", pUiRscs)
pEventHdl:bind("ui.interaction.run.hud", pUiHud)

-- in open order
pWndHandler:set_opened(pUiWmap)
pWndHandler:set_opened(pUiHud)
--pWndHandler:set_opened(pUiRscs)
--pWndHandler:set_opened(pUiStats)
--pWndHandler:set_opened(pUiInvt)

pWndHandler:set_focus_wnd(pUiHud)

local btGo, btSave, btLoad, btDelete = pUiHud:get_buttons_route()
--btGo:update_state(RButtonState.DISABLED)
btSave:update_state(RButtonState.DISABLED)
btLoad:update_state(RButtonState.DISABLED)
btDelete:update_state(RButtonState.DISABLED)
