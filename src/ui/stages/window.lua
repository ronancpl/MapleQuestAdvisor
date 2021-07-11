--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.interaction.handler")
require("ui.interaction.window")
require("ui.run.load.basic")
require("ui.run.load.inventory")
require("ui.run.load.resource")
require("ui.run.load.stat")
require("ui.run.load.worldmap")
require("utils.logger.file")

local function make_leading_paths()
    local pSetLeadingPath = SRankedSet:new()
    pSetLeadingPath:set_capacity(RGraph.LEADING_PATH_CAPACITY)

    return pSetLeadingPath
end

local function load_route_quests(pTrack)
    local pSetLeadingPath = make_leading_paths()

    for pQuestPath, fVal in pairs(pTrack:get_root_lane():get_path_entries()) do
        pSetLeadingPath:insert(pQuestPath, fVal)
    end

    return pSetLeadingPath
end

log(LPath.INTERFACE, "load.txt", "Loading action handler...")
pEventHdl = CActionHandler:new()
pEventHdl:reset()
pEventHdl:install("ui.interaction.run.basic")
pEventHdl:install("ui.interaction.run.inventory")
pEventHdl:install("ui.interaction.run.stat")
pEventHdl:install("ui.interaction.run.worldmap")
pEventHdl:install("ui.interaction.run.resource")

log(LPath.INTERFACE, "load.txt", "Loading user interface...")
pWndHandler = CWndHandler:new()

pFrameBasic = load_frame_basic()
pUiWmap = load_frame_worldmap()
pUiInvt = load_frame_player_inventory()
pUiStats = load_frame_stat()
pUiRscs = load_frame_quest_resources()

pPlayer = CPlayer:new({iId = 1})
local _, tQuests, tRoute = generate_quest_route(pPlayer, pUiWmap)

-- load enviroment info
run_rates_bt_load(pUiStats, pPlayer)
run_player_bt_load(pPlayer)

log(LPath.INTERFACE, "load.txt", "Visualizing inventory '" .. pIvtItems:tostring() .. "'")
local pIvtItems = pPlayer:get_items():get_inventory()
pUiInvt:update_inventory(pIvtItems)

local tQuests = load_board_quests()
local pTrack, tRoute = run_route_bt_load()

local pPath = pTrack:get_paths()[1]
local pQuestProp = pPath:list()[1]
local pLeRscTree = pPath:get_node_allot(1):get_resource_tree()

local pRscTree = CSolverTree:new()
pRscTree:set_field_source(pLeRscTree:get_field_source())
pRscTree:set_field_destination(pLeRscTree:get_field_destination())

local iVal = keys(pLeRscTree:get_field_nodes())[1]
local pLeRscTreeRegion = pLeRscTree:get_field_node(iVal)

pRscTreeRegion = CSolverTree:new()
pRscTreeRegion:set_field_source(104000000)
pRscTreeRegion:set_field_destination(103000000)

pRscTree:add_field_node(23, pRscTreeRegion)

local pRscNode1 = CSolverResource:new()
pRscTreeRegion:add_field_node(104000400, pRscNode1)
local rgiResourceids = {2003010001, 2003010002}
pRscNode1:set_resources(rgiResourceids)

local pRscNode2 = CSolverResource:new()
pRscTreeRegion:add_field_node(103020000, pRscNode2)
local rgiResourceids = {1002220000, 2003010000}
pRscNode2:set_resources(rgiResourceids)

local pRscNode3 = CSolverResource:new()
pRscTreeRegion:add_field_node(104010000, pRscNode3)
local rgiResourceids = {2004010000, 2004010001}
pRscNode3:set_resources(rgiResourceids)

local pRscNode4 = CSolverResource:new()
pRscTreeRegion:add_field_node(104040000, pRscNode4)
local rgiResourceids = {2004010002}
pRscNode4:set_resources(rgiResourceids)

local rgiResourceids = {1002220000, 2003010000, 2003010001, 2003010002, 2004010000, 2004010001, 2004010002}
pRscTreeRegion:set_resources(rgiResourceids)

local pRscNode = CSolverResource:new()
pRscTreeRegion:add_field_node(103000000, pRscNode)
pRscNode:set_resources({4001013000})

pRscTree:make_remissive_index_resource_fields()
pUiRscs:update_resources(pQuestProp, pRscTree)

local sWmapName = "WorldMap010"
log(LPath.INTERFACE, "load.txt", "Visualizing region '" .. sWmapName .. "'")

pInfoSrv = pUiStats:get_properties():get_info_server()

save_player(pPlayer)
save_inventory(pPlayer)
save_rates(pInfoSrv)

pUiWmap:set_player(pPlayer)
pUiWmap:update_region(sWmapName, pUiRscs)

pEventHdl:bind("ui.interaction.run.inventory", pUiInvt)
pEventHdl:bind("ui.interaction.run.stat", pUiStats)
pEventHdl:bind("ui.interaction.run.worldmap", pUiWmap)
pEventHdl:bind("ui.interaction.run.resource", pUiRscs)

-- in open order
pWndHandler:set_opened(pUiWmap)
pWndHandler:set_opened(pUiRscs)
pWndHandler:set_opened(pUiStats)
pWndHandler:set_opened(pUiInvt)
