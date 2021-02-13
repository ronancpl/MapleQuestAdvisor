--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.path.path")
require("utils.struct.class")

CWmapCanvas = createClass({})

function CWmapCanvas:load()
    self.bg = love.graphics.newImage(RInterface.BG_WORLDMAP)
end

function CWmapCanvas:update(dt)
    -- do nothing
end

function CWmapCanvas:draw()
    love.graphics.draw{drawable=self.bg}
end
