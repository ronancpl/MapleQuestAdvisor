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

require("ui.constant.path")
require("ui.run.build.worldmap.worldmap")
require("ui.run.load.basic")
require("ui.run.load.worldmap")
require("utils.logger.file")
require("utils.procedure.print")

function love.load()
    log(LPath.INTERFACE, "load.txt", "Loading graphic asset...")
    ctFieldsWmap = load_resources_worldmap()

    log(LPath.INTERFACE, "load.txt", "Loading user interface...")
    pFrameBasic = load_frame_basic()
    pFrameBasic:load_mouse(RWndPath.MOUSE.BT_GAME)

    pUiWmap = load_frame_worldmap()

    local sWmapName = "WorldMap"
    log(LPath.INTERFACE, "load.txt", "Visualizing region '" .. sWmapName .. "'")
    pUiWmap:update_region(sWmapName)
end

function love.update(dt)
    pFrameBasic:update(dt)
    pFrameBasic:refresh_cursor()

    pUiWmap:update(dt)
end

function love.draw()
    pUiWmap:draw()
end

function love.mousepressed(x, y, button)
    -- Use a custom cursor when the left mouse button is pressed.
    if button == 1 then
        pFrameBasic:load_mouse(RWndPath.MOUSE.BT_DOWN)
    end
end

function love.mousereleased(x, y, button)
    -- Go back to the default cursor when the left mouse button is released.
    if button == 1 then
        pFrameBasic:load_mouse(RWndPath.MOUSE.BT_NORMAL)
    end
end
