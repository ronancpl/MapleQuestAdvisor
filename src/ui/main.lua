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

require("composer.field.worldmap")
require("ui.run.build.worldmap")
require("utils.logger.file")
require("utils.procedure.print")

function love.load()
    log(LPath.INTERFACE, "load.txt", "Loading graphic asset...")
    ctFieldsWmap = load_resources_worldmap()

    log(LPath.INTERFACE, "load.txt", "Loading user interface...")
    pUiWmap = load_frame_worldmap()

    local sWmapName = "WorldMap"
    log(LPath.INTERFACE, "load.txt", "Visualizing region '" .. sWmapName .. "'")
    pUiWmap:update_region(sWmapName)
end

function love.update(dt)
    pUiWmap:update(dt)
end

function love.draw()
    pUiWmap:draw()
end
