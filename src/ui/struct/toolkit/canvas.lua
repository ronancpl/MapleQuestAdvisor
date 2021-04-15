--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.toolkit.graphics")

CViewCanvas = createClass({
    pCanvas,

    iOx = 0,
    iOy = 0,

    iLx,
    iRx,
    iTy,
    iBy
})

function CViewCanvas:get_canvas()
    return self.pCanvas
end

function CViewCanvas:get_origin()
    return self.iOx, self.iOy
end

function CViewCanvas:set_origin(iOx, iOy)
    self.iOx = iOx
    self.iOy = iOy
end

function CViewCanvas:alloc_lt(x, y)
    self.iLx = math.min(x, self.iLx)
    self.iTy = math.min(y, self.iTy)
end

function CViewCanvas:alloc_rb(x, y)
    self.iRx = math.max(x, self.iRx)
    self.iBy = math.max(y, self.iBy)
end

function CViewCanvas:free()
    self:alloc_lt(0, 0)
    self:alloc_rb(0, 0)
end

function CViewCanvas:load(iWidth, iHeight)
    local iOx = iWidth
    local iOy = iHeight

    self.pCanvas = love.graphics.newCanvas(2 * iOx, 2 * iOy)
    self:set_origin(iOx, iOy)
end

function CViewCanvas:update_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
    local iOx, iOy = self:get_origin()
    iPx = iPx + iOx
    iPy = iPy + iOy

    graphics_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
end

function CViewCanvas:render_to(fn_drawing)
    _TK_CANVAS = self
    self.pCanvas:renderTo(fn_drawing)
    _TK_CANVAS = nil
end

function graphics_canvas_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
    local pCanvas = _TK_CANVAS
    pCanvas:update_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
end
