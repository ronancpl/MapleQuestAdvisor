--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.static")
require("utils.struct.class")

CWmapElemBackground = createClass({
    eConst = CStaticElem:new()
})

function CWmapElemBackground:load(pImg, iOx, iOy, iZ, rX, rY)
    self.eConst:load(pImg, iOx, iOy, iZ, rX, rY)
end

function CWmapElemBackground:update(dt)
    self.eConst:update(dt)
end

function CWmapElemBackground:draw()
    self.eConst:draw()
end
