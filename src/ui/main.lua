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

require("composer.field.field")
require("composer.containers.strings.item")
require("composer.containers.strings.mob")
require("composer.containers.strings.npc")
require("structs.player")
require("structs.storage.inventory")
require("ui.constant.path")
require("ui.constant.view.resource")
require("ui.interaction.handler")
require("ui.run.build.canvas.worldmap.worldmap")
require("ui.run.load.basic")
require("ui.run.load.inventory")
require("ui.run.load.resource")
require("ui.run.load.stat")
require("ui.run.load.worldmap")
require("ui.struct.component.canvas.inventory.storage")
require("ui.struct.component.canvas.resource.storage")
require("ui.struct.component.canvas.style.storage")
require("ui.struct.component.canvas.slider.storage")
require("ui.struct.component.tooltip.mouse.storage")
require("ui.struct.component.tooltip.tracer.polyline")
require("ui.struct.component.tooltip.tracer.storage")
require("ui.struct.images.storage.item")
require("ui.struct.images.storage.mob")
require("ui.struct.images.storage.npc")
require("ui.trace.trace")
require("utils.logger.file")
require("utils.procedure.print")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    love.graphics.setWireframe(love.keyboard.isDown('space'))

    log(LPath.INTERFACE, "load.txt", "Loading solver metadata...")
    dofile("router/stage.lua")

    log(LPath.INTERFACE, "load.txt", "Loading graphic asset...")

    ctFieldsWmap = load_resources_worldmap_ui()

    ctHrItems = load_image_header_inventory()
    ctHrMobs = load_image_header_mobs()
    ctHrNpcs = load_image_header_npcs()

    ctVwStyle = load_image_stock_stylebox()
    ctVwInvt = load_image_stock_inventory()
    ctVwRscs = load_image_stock_resources()
    ctVwCursor = load_image_stock_mouse()
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

    pUiWmap = load_frame_worldmap()

    local sWmapName = "WorldMap010"
    log(LPath.INTERFACE, "load.txt", "Visualizing region '" .. sWmapName .. "'")
    pUiWmap:update_region(sWmapName)

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

    pPlayer = CPlayer:new({iMapid = 2000000, siLevel = 50, siJob = 122})
    pUiStats:update_stats(pPlayer, 10, 10, 10)

    local rgpQuadBullet = ctVwTracer:get_bullet()

    pVwTrace = CViewPolyline:new()
    pVwTrace:load(rgpQuadBullet, {100, 100, 400, 400, 500, 300})

    pUiRscs = load_frame_quest_resources()

    pUiRscs:set_dimensions(RResourceTable.VW_WND.W, RResourceTable.VW_WND.H)

    local pQuestProp = tRoute:list()[1]
    local pRscTree = tRoute:get_node_allot(1):get_resource_tree()
    pUiRscs:update_resources(pQuestProp, pRscTree)
end

local function update_interactions()
    local rgpEvents = pEventHdl:export()
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

    pUiWmap:update(dt)
    pUiInvt:update(dt)
    pUiStats:update(dt)
    pUiRscs:update(dt)
end

function love.draw()
    pUiWmap:draw()
    pUiInvt:draw()
    pUiStats:draw()
    pVwTrace:draw()
    pUiRscs:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
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
