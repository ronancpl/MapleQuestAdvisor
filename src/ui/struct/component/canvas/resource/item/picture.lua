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
require("ui.constant.view.inventory")
require("ui.run.draw.canvas.resource.resource")
require("ui.struct.component.canvas.resource.item.item")
require("ui.struct.component.element.rect")
require("ui.struct.toolkit.canvas")
require("utils.struct.class")

CCanvasRscPicture = createClass({CCanvasResource, {
    pImg,
    iCount
}})

function CCanvasRscPicture:get_image()
    return self.pImg
end

function CCanvasRscPicture:get_count()
    return self.iCount
end

function CCanvasRscPicture:is_visible_count()
    return self.iCount ~= nil
end

local function calc_icon_dimension_scale(iPicLength, iImgLength)
    if iImgLength < iPicLength then
        return 1.0
    end

    local fSc = iPicLength / iImgLength
    return fSc
end

local function calc_icon_image_scale(pImg, pRscGrid)
    local fSc

    local iIw, iIh = pImg:getDimensions()
    if iIw > iIh then
        fSc = calc_icon_dimension_scale(pRscGrid.W, iIw)
    else
        fSc = calc_icon_dimension_scale(pRscGrid.H, iIh)
    end

    return fSc
end

function load_scale_image_canvas(pImg, fSc)
    local iImgW, iImgH = pImg:getDimensions()

    local iScW = math.ceil(fSc * iImgW)
    local iScH = math.ceil(fSc * iImgH)

    local iScLim = math.max(iScW, iScH)
    log_st(LPath.INTERFACE, "_rsc.txt", "f" .. fSc .. " " .. iScLim .. " w" .. iImgW .. ",h" .. iImgH)

    local pVwCnv = CViewCanvas:new()
    pVwCnv:load(iScLim, iScLim)

    pVwCnv:render_to(function()
        love.graphics.clear()

        local iDx = math.ceil((iScLim - iScW) / 2)  -- centralized horizontally, next to bottom
        local iDy = iScLim - iScH
        graphics_canvas_draw(pImg, 0 + iDx, 0 + iDy, 0, iScW, iScH)
    end)

    local iLx, iTy = pVwCnv:get_lt()

    local pCnv = pVwCnv:get_canvas()
    local pImgCnv = pCnv:newImageData(0, 1, iLx, iTy, iScLim, iScLim)

    local pImg = love.graphics.newImage(pImgCnv)
    return pImg
end

local function make_icon_image(pImg, pRscGrid)
    local fSc = calc_icon_image_scale(pImg, pRscGrid)

    local pIconImg = load_scale_image_canvas(pImg, fSc)
    return pIconImg
end

function CCanvasRscPicture:load(siType, pImg, iId, iCount, sDesc, iFieldRef, pConfVw)
    self:_load(siType, iId, sDesc, iFieldRef, pConfVw)

    local pRscGrid = tpRscGrid[siType]

    self.pImg = make_icon_image(pImg, pRscGrid)
    self.iCount = iCount
end

function CCanvasRscPicture:update(iPx, iPy)
    self:_update_position(iPx, iPy)
end

function CCanvasRscPicture:draw()
    draw_resource_picture(self)
end
