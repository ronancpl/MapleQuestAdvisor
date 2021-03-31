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
require("ui.constant.path")
require("ui.interaction.handler")
require("ui.run.build.worldmap.worldmap")
require("ui.run.load.basic")
require("ui.run.load.worldmap")
require("ui.struct.component.canvas.style.basic")
require("utils.logger.file")
require("utils.procedure.print")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    log(LPath.INTERFACE, "load.txt", "Loading graphic asset...")
    ctFieldsWmap = load_resources_worldmap()
    ctFieldsMeta = load_meta_resources_fields()

    log(LPath.INTERFACE, "load.txt", "Loading action handler...")
    pEventHdl = CActionHandler:new()
    pEventHdl:install("ui.interaction.worldmap.run")

    log(LPath.INTERFACE, "load.txt", "Loading user interface...")
    pFrameBasic = load_frame_basic()
    pFrameBasic:load_mouse(RWndPath.MOUSE.BT_GAME)

    pFrameStylebox = load_stylebox_images()

    pUiWmap = load_frame_worldmap()

    local sWmapName = "WorldMap010"
    log(LPath.INTERFACE, "load.txt", "Visualizing region '" .. sWmapName .. "'")
    pUiWmap:update_region(sWmapName)
end

local function update_interactions()
    local rgpEvents = pEventHdl:export()
    for _, pEvent in ipairs(rgpEvents) do
        local fn_action
        local rgpActions
        fn_action, rgpActions = unpack(pEvent)

        for _, pAction in ipairs(rgpActions) do
            local rgpArgs = pAction
            fn_action(unpack(rgpArgs))
        end
    end
end

function love.update(dt)
    update_interactions()

    pFrameBasic:update(dt)
    pFrameBasic:refresh_cursor()

    pUiWmap:update(dt)
end

function love.draw()
    pUiWmap:draw()
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
