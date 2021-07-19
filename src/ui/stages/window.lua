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
require("ui.run.control.player")
require("ui.run.control.rates")
require("ui.run.control.route")
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

local function save_to_bt(pPlayer, pUiStats)
    save_player(pPlayer)
    save_inventory(pPlayer)
    save_rates(pUiStats)
end

log(LPath.INTERFACE, "load.txt", "Loading action handler...")
pEventHdl = CActionHandler:new()
pEventHdl:reset()
pEventHdl:install("ui.interaction.run.basic")
pEventHdl:install("ui.interaction.run.inventory")
pEventHdl:install("ui.interaction.run.stat")
pEventHdl:install("ui.interaction.run.worldmap")
pEventHdl:install("ui.interaction.run.resource")

pPlayer = CPlayer:new({iId = 1})

log(LPath.INTERFACE, "load.txt", "Loading user interface...")
pWndHandler = CWndHandler:new()

pFrameBasic = load_frame_basic()
pUiWmap = load_frame_worldmap()
pUiInvt = load_frame_player_inventory()
pUiStats = load_frame_stat()
pUiRscs = load_frame_quest_resources()

local _, tQuests, tRoute = generate_quest_route(pPlayer, pUiWmap)

local pIvtItems = CInventory:new()
pIvtItems:add_item(1002067, 1)      -- outfit FTW
pIvtItems:add_item(1402046, 1)
pIvtItems:add_item(1082140, 1)
pIvtItems:add_item(1060091, 7)
pIvtItems:add_item(1072154, 7)
pIvtItems:add_item(1040103, 7)

pIvtItems:add_item(3010000, 4)
pIvtItems:add_item(3010001, 2)
pIvtItems:add_item(3010002, 2)
pIvtItems:add_item(3010003, 2)
pIvtItems:add_item(3010004, 2)
pIvtItems:add_item(3010005, 2)
pIvtItems:add_item(3010006, 2)

pIvtItems:add_item(2010000, 4)
pIvtItems:add_item(2010001, 1)
pIvtItems:add_item(2010002, 4)
pIvtItems:add_item(2010003, 1)
pIvtItems:add_item(2010004, 4)
pIvtItems:add_item(2010005, 1)
pIvtItems:add_item(2010006, 4)
pIvtItems:add_item(4010000, 4)
pIvtItems:add_item(4010001, 1)
pIvtItems:add_item(4010002, 4)
pIvtItems:add_item(4010003, 1)
pIvtItems:add_item(4010004, 4)
pIvtItems:add_item(4010005, 1)
pIvtItems:add_item(4010006, 4)
pIvtItems:add_item(4010000, 4)
pIvtItems:add_item(4010001, 1)
pIvtItems:add_item(4010002, 4)
pIvtItems:add_item(4010003, 1)
pIvtItems:add_item(4010004, 4)
pIvtItems:add_item(4010005, 1)
pIvtItems:add_item(4010006, 4)
pIvtItems:add_item(4010000, 4)
pIvtItems:add_item(4010001, 1)
pIvtItems:add_item(4010002, 4)
pIvtItems:add_item(4010003, 1)
pIvtItems:add_item(4010004, 4)
pIvtItems:add_item(4010005, 1)
pIvtItems:add_item(4010006, 4)
pIvtItems:add_item(4010000, 4)
pIvtItems:add_item(4010001, 1)
pIvtItems:add_item(4010002, 4)
pIvtItems:add_item(4010003, 1)
pIvtItems:add_item(4010004, 4)
pIvtItems:add_item(4010005, 1)
pIvtItems:add_item(4010006, 4)
pIvtItems:add_item(4010000, 4)
pIvtItems:add_item(4010001, 1)
pIvtItems:add_item(4010002, 4)
pIvtItems:add_item(4010003, 1)
pIvtItems:add_item(4010004, 4)
pIvtItems:add_item(4010005, 1)
pIvtItems:add_item(4010006, 4)
pIvtItems:add_item(4010000, 4)
pIvtItems:add_item(4010001, 1)
pIvtItems:add_item(4010002, 4)
pIvtItems:add_item(4010003, 1)
pIvtItems:add_item(4010004, 4)
pIvtItems:add_item(4010005, 1)
pIvtItems:add_item(4010006, 4)
pIvtItems:add_item(4010010, 4)
pIvtItems:add_item(4010011, 1)
pIvtItems:add_item(4010012, 4)
pIvtItems:add_item(4010013, 1)
pIvtItems:add_item(4010014, 4)
pIvtItems:add_item(4010015, 1)
pIvtItems:add_item(4010016, 4)
pIvtItems:add_item(4010017, 4)
pIvtItems:add_item(4010018, 4)
pIvtItems:add_item(4010019, 4)
pIvtItems:add_item(4010020, 4)
pIvtItems:add_item(4010021, 4)
pIvtItems:add_item(4010022, 4)
pIvtItems:add_item(4010023, 4)
pIvtItems:add_item(4010024, 4)
pIvtItems:add_item(4010025, 4)
pIvtItems:add_item(4010026, 4)
pIvtItems:add_item(4010027, 4)
pIvtItems:add_item(4010028, 4)
pIvtItems:add_item(4010029, 4)
pIvtItems:add_item(4010030, 4)
pIvtItems:add_item(4010031, 4)
pIvtItems:add_item(4010032, 4)
pIvtItems:add_item(4010033, 4)
pIvtItems:add_item(4010034, 4)
pIvtItems:add_item(4010035, 4)

--local pIvtItems = pPlayer:get_items():get_inventory()


log(LPath.INTERFACE, "load.txt", "Visualizing inventory '" .. pIvtItems:tostring() .. "'")
pUiInvt:update_inventory(pIvtItems)

--[[

-- save enviroment info
save_to_bt(pPlayer, pUiStats)
run_route_bt_save(tRoute)
save_board_quests(tQuests)

-- load enviroment info
run_rates_bt_load(pUiStats, pPlayer)
run_player_bt_load(pPlayer)

local tQuests = load_board_quests()
local pTrack, tRoute = run_route_bt_load(pPlayer)
]]--

local pTrack = pUiWmap:get_properties():get_quest_route()

local pPath = pTrack:get_paths()[1]
local pQuestProp = pPath:list()[1]

local pRscTree = pPath:get_node_allot(1):get_resource_tree()
if pRscTree == nil then
    pRscTree = CSolverTree:new()
end

pUiRscs:update_resources(pQuestProp, pRscTree)

pUiStats:update_stats(pPlayer, 10, 10, 10)

local sWmapName = "WorldMap010"
log(LPath.INTERFACE, "load.txt", "Visualizing region '" .. sWmapName .. "'")

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
