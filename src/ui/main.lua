--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

package.path = package.path .. ';?.lua'

require("composer.containers.strings.item")
require("composer.containers.strings.mob")
require("composer.containers.strings.npc")
require("composer.quest.quest")
require("router.procedures.persist.delete.rates")
require("router.procedures.persist.delete.player.character")
require("router.procedures.persist.delete.player.inventory")
require("router.procedures.persist.load.rates")
require("router.procedures.persist.load.player.character")
require("router.procedures.persist.load.player.inventory")
require("router.procedures.persist.save.rates")
require("router.procedures.persist.save.player.character")
require("router.procedures.persist.save.player.inventory")
require("router.stages.load")
require("structs.player")
require("structs.storage.inventory")
require("ui.constant.path")
require("ui.interaction.handler")
require("ui.interaction.window")
require("ui.run.build.canvas.worldmap.worldmap")
require("ui.run.control.procedures")
require("ui.run.load.basic")
require("ui.run.load.inventory")
require("ui.run.load.resource")
require("ui.run.load.stat")
require("ui.run.load.worldmap")
require("ui.run.update.navigation")
require("ui.struct.component.canvas.inventory.storage")
require("ui.struct.component.canvas.resource.storage")
require("ui.struct.component.canvas.style.storage")
require("ui.struct.component.canvas.slider.storage")
require("ui.struct.component.tooltip.button.storage")
require("ui.struct.component.tooltip.mouse.storage")
require("ui.struct.component.tooltip.tracer.storage")
require("ui.struct.images.storage.item")
require("ui.struct.images.storage.mob")
require("ui.struct.images.storage.npc")
require("ui.struct.window.pool.canvas_pool")
require("ui.struct.window.pool.font_pool")
require("ui.struct.window.pool.image_pool")
require("ui.struct.window.pool.worldmap_pool")
require("ui.trace.trace")
require("utils.logger.file")
require("utils.persist.act.call")
require("utils.persist.serial.databus")
--require("utils.persist.serial.table")
require("utils.procedure.print")
require("utils.struct.maptimed")
require("utils.struct.ranked_set")

local function is_tree_leaf(pRscNode)
    return pRscNode.make_remissive_index_resource_fields == nil
end

local function make_remissive_index_tree_resource_fields(pRscNode)
    if not is_tree_leaf(pRscNode) then
        pRscNode:make_remissive_index_resource_fields()
        for _, pRegionRscTree in pairs(pRscNode:get_field_nodes()) do
            make_remissive_index_tree_resource_fields(pRegionRscTree)
        end
    end
end

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

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    love.graphics.setWireframe(love.keyboard.isDown('space'))

    log(LPath.INTERFACE, "load.txt", "Loading solver metadata...")

    dofile("router/stage.lua")

    pPlayer = CPlayer:new({iId = 1, iMapid = 2000000, siLevel = 50, siJob = 122})

    dofile("router/route.lua")

    --dofile("persist/init.lua")    -- initialized as background process
    tpDbTableCols = load_db_table_cols()

    ctFieldsWmap = load_resources_worldmap_ui()

    log(LPath.INTERFACE, "load.txt", "Loading graphic asset...")

    ctPoolCnv = CPoolCanvas:new()
    ctPoolCnv:init()

    ctPoolFont = CPoolFont:new()
    ctPoolFont:init()

    ctPoolImg = CPoolImage:new()
    ctPoolImg:init()

    ctPoolWmap = CPoolWorldmap:new()
    ctPoolWmap:init()

    ctInactiveTextures = SMapTimed:new()

    ctHrItems = load_image_header_inventory()
    ctHrMobs = load_image_header_mobs()
    ctHrNpcs = load_image_header_npcs()

    ctVwStyle = load_image_stock_stylebox()
    ctVwInvt = load_image_stock_inventory()
    ctVwRscs = load_image_stock_resources()
    ctVwCursor = load_image_stock_mouse()
    ctVwButton = load_image_stock_button()
    ctVwSlider = load_image_stock_slider()
    ctVwTracer = load_image_stock_tracer()

    log(LPath.INTERFACE, "load.txt", "Loading action handler...")
    pEventHdl = CActionHandler:new()
    pEventHdl:reset()
    pEventHdl:install("ui.interaction.run.basic")
    pEventHdl:install("ui.interaction.run.inventory")
    pEventHdl:install("ui.interaction.run.stat")
    pEventHdl:install("ui.interaction.run.worldmap")
    pEventHdl:install("ui.interaction.run.resource")

    log(LPath.INTERFACE, "load.txt", "Loading user interface...")
    pFrameBasic = load_frame_basic()

    pWndHandler = CWndHandler:new()

    pUiWmap = load_frame_worldmap()

    local _, tQuests, tRoute = generate_quest_route(pPlayer, pUiWmap)

    pUiInvt = load_frame_player_inventory()

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

    log(LPath.INTERFACE, "load.txt", "Visualizing inventory '" .. pIvtItems:tostring() .. "'")
    pUiInvt:update_inventory(pIvtItems)

    pUiStats = load_frame_stat()

    pPlayer:get_items():get_inventory():include_inventory(pIvtItems)

    pUiStats:update_stats(pPlayer, 10, 10, 10)

    pUiRscs = load_frame_quest_resources()

    local pTrack = pUiWmap:get_properties():get_track()

    run_bt_save(tRoute)
    save_board_quests(tQuests)

    local tRoute = load_route_quests(pTrack)
    local tQuests = load_board_quests()
    local pTrack = run_bt_load(pPlayer, tRoute)

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

    local pInfoSrv = pUiStats:get_properties():get_info_server()

    log(LPath.INTERFACE, "load.txt", "Loading persisted data")

    save_player(pPlayer)
    save_inventory(pPlayer)
    save_rates(pInfoSrv)

    log(LPath.DB, "rdbms.txt", "Saving data")

    load_rates(pInfoSrv)
    load_inventory(pPlayer)
    load_player(pPlayer)

    log(LPath.DB, "rdbms.txt", "Loading data")

    delete_rates(pInfoSrv)
    delete_inventory(pPlayer)
    delete_player(pPlayer)

    log(LPath.DB, "rdbms.txt", "Deleting data")

    local rgpPoolProps = {}
    for pQuest, _ in pairs(tQuests:get_entry_set()) do
        table.insert(rgpPoolProps, pQuest:get_start())
        table.insert(rgpPoolProps, pQuest:get_end())
    end

    player_lane_move_ahead(pTrack, pQuestProp, pPlayer, rgpPoolProps)

    player_lane_move_back(pTrack, pPlayer, rgpPoolProps)

end

local function update_interactions()
    local rgpEvents = pEventHdl:export(nil, pWndHandler:get_focus_wnd())
    for _, pEvent in ipairs(rgpEvents) do
        local rgfn_actions
        local rgpActions
        rgfn_actions, rgpActions = unpack(pEvent)

        for _, pAction in ipairs(rgpActions) do
            local rgpArgs = pAction

            for _, fn_action in ipairs(rgfn_actions) do
                fn_action(unpack(rgpArgs))
            end
        end
    end
end

function love.update(dt)
    update_interactions()

    pFrameBasic:update(dt)

    pWndHandler:update()

    for _, pWnd in ipairs(pWndHandler:list_opened()) do
        pWnd:update(dt)
    end
end

function love.draw()
    for _, pWnd in ipairs(pWndHandler:list_opened()) do
        pWnd:draw()
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    pWndHandler:on_mousemoved(x, y, dx, dy, istouch)
    pEventHdl:push("on_mousemoved", {x, y, dx, dy, istouch})
end

function love.mousepressed(x, y, button)
    pEventHdl:push("on_mousepressed", {x, y, button})
end

function love.mousereleased(x, y, button)
    pEventHdl:push("on_mousereleased", {x, y, button})
end

function love.wheelmoved(dx, dy)
    pEventHdl:push("on_wheelmoved", {dx, dy})
end

function love.quit()
    dofile("persist/close.lua")
end
