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

local function calc_image_canvas_pos(pImg, pRscGrid)
    local iImgW, iImgH = pImg:getDimensions()
    local iPicW, iPicH = pRscGrid.W, pRscGrid.H

    local iDx = 0 + math.floor((iPicW - iImgW) / 2)
    local iDy = 0 + math.floor((iPicH - iImgH) / 2)

    return iDx, iDy
end

function load_icon_image_canvas(pImg, pRscGrid)
    local iImgW, iImgH = pImg:getDimensions()
    local iPicW, iPicH = pRscGrid.W, pRscGrid.H

    local iImgLim = math.max(iImgW, iImgH)
    local iPicLim = math.max(iPicW, iPicH)

    local iCnvLim = math.max(iImgLim, iPicLim)

    local iPx, iPy = calc_image_canvas_pos(pImg, pRscGrid)

    local pVwCnv = CViewCanvas:new()
    pVwCnv:load(iCnvLim, iCnvLim)

    pVwCnv:render_to(function()
        love.graphics.clear()

        local iDx = math.ceil((iImgW - iPicW) / 2)  -- centralized horizontally, next to bottom
        local iDy = iImgH - iPicH
        graphics_canvas_draw(pImg, iPx + iDx, iPy + iDy, 0, iPicW, iPicH)
    end)

    local iLx, iTy = pVwCnv:get_lt()

    local pCnv = pVwCnv:get_canvas()
    local pImgCnv = pCnv:newImageData(0, 1, iLx, iTy, iCnvLim, iCnvLim)

    local pImg = love.graphics.newImage(pImgCnv)
    return pImg
end

local function make_icon_image(pImg, pRscGrid)
    local pIconImg = load_icon_image_canvas(pImg, pRscGrid)
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
