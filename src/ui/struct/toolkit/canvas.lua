--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("ui.struct.toolkit.graphics")

CViewCanvas = createClass({
    pCanvas,

    iOx = 0,
    iOy = 0,

    iLx = U_INT_MAX,
    iRx = 0,
    iTy = U_INT_MAX,
    iBy = 0
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

function CViewCanvas:get_lt()
    return self.iLx, self.iTy
end

function CViewCanvas:get_rb()
    return self.iRx, self.iBy
end

function CViewCanvas:free()
    self:alloc_lt(U_INT_MAX, U_INT_MAX)
    self:alloc_rb(0, 0)
end

function CViewCanvas:load(iWidth, iHeight)
    local iOx = iWidth
    local iOy = iHeight

    self.pCanvas = love.graphics.newCanvas(3 * iOx, 3 * iOy)
    self:set_origin(iOx, iOy)
end

function CViewCanvas:update_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
    local iIx, iIy = self:get_origin()
    iPx = iPx + iIx
    iPy = iPy + iIy

    self:alloc_lt(iPx, iPy)
    self:alloc_rb(iPx + iW, iPy + iH)

    graphics_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
end

function CViewCanvas:render_to(fn_drawing)
    _TK_CANVAS = self
    self.pCanvas:renderTo(fn_drawing)

    _TK_CANVAS = nil
    self:free()
end

function graphics_canvas_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
    local pCanvas = _TK_CANVAS

    local fSw, fSh = graphics_get_scale(pImg, iW, iH)
    local iWidth
    local iHeight
    iWidth, iHeight = pImg:getDimensions()

    local iDw = math.floor(fSw * iWidth)
    iW = iW and math.min(iW, iDw) or iDw

    local iDh = math.floor(fSh * iHeight)
    iH = iH and math.min(iH, iDh) or iDh

    pCanvas:update_draw(pImg, iPx, iPy, iR, iW, iH, iOx, iOy, iKx, iKy)
end

local function fetch_canvas_limits(pCanvas)
    local iLx, iTy = pCanvas:get_lt()
    local iRx, iBy = pCanvas:get_rb()

    local iOx, iOy = pCanvas:get_origin()

    local iSw = iRx - iLx
    local iSh = iBy - iTy

    return iOx, iOy, iLx, iTy, iSw, iSh
end

function graphics_canvas_to_image_data(pCanvas, iPx, iPy, iW, iH)
    local iLx, iTy = pCanvas:get_lt()
    local pCnv = pCanvas:get_canvas()

    local pImgDataCnv = pCnv:newImageData(0, 1, iLx + iPx, iTy + iPy, iW, iH)
    return pImgDataCnv
end

function graphics_draw_canvas(pCanvas, iPx, iPy, iR, iKx, iKy)
    local iOx, iOy, iLx, iTy, iSw, iSh = fetch_canvas_limits(pCanvas)

    local iRx = iLx - iOx
    local iRy = iTy - iOy

    love.graphics.setScissor(iPx + iRx, iPy + iRy, iSw, iSh)
    love.graphics.draw(pCanvas:get_canvas(), iPx + iRx, iPy + iRy, iR, 1, 1, iOx, iOy, iKx, iKy)
    love.graphics.setScissor()
end
