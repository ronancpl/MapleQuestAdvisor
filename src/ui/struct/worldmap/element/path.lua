--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.static")
require("utils.struct.class")

CWmapElemPath = createClass({
    eConst = CStaticElem:new()
})

function CWmapElemPath:get_object()
    return self.eConst
end

function CWmapElemPath:load(pWmapProp, pImg, iOx, iOy, iZ, rX, rY)
    self.eConst:load(pImg, iOx, iOy, iZ, rX, rY)
    self.eConst:instantiate(pWmapProp, true)
end

function CWmapElemPath:reset()
    -- do nothing
end

function CWmapElemPath:update(dt)
    self.eConst:update(dt)
end

function CWmapElemPath:draw()
    self.eConst:draw()
end

function CWmapElemPath:onmousehoverin()
    -- do nothing
end

function CWmapElemPath:onmousehoverout()
    -- do nothing
end

function CWmapElemPath:onmousemoved(rx, ry, dx, dy, istouch)
    -- do nothing
end

function CWmapElemPath:onmousepressed(rx, ry, button)
    -- do nothing
end

function CWmapElemPath:onmousereleased(rx, ry, button)
    -- do nothing
end

function CWmapElemPath:onwheelmoved(dx, dy)
    -- do nothing
end
