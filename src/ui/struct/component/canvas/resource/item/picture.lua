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

CRscElemItemPicture = createClass({CRscElemItem, {
    pImg,
    iCount
}})

function CRscElemItemPicture:get_image()
    return self.pImg
end

function CRscElemItemPicture:get_count()
    return self.iCount
end

function CRscElemItemPicture:is_visible_count()
    return self.iCount ~= nil
end

local function calc_image_canvas_pos(pImg, pRscGrid)
    local iImgW, iImgH = pImg:getDimensions()
    local iPicW, iPicH = pRscGrid.W, pRscGrid.H

    local iDx = math.ceil((iImgW - iPicW) / 2)  -- centralized horizontally, next to bottom
    local iDy = iImgH - iPicH

    return iDx, iDy
end

function load_icon_image_canvas(pImg, pRscGrid)
    local iImgW, iImgH = pImg:getDimensions()
    local iPicW, iPicH = pRscGrid.W, pRscGrid.H

    local iImgLim = math.max(iImgW, iImgH)
    local iPicLim = math.max(iPicW, iPicH)

    local iCnvLim = math.max(iImgLim, iPicLim)

    local iDx, iDy = calc_image_canvas_pos(pImg, pRscGrid)

    local pVwCnv = CViewCanvas:new()
    pVwCnv:load(iCnvLim, iCnvLim)

    pVwCnv:render_to(function()
        love.graphics.clear()
        graphics_canvas_draw(pImg, 0, 0, 0, iImgW, iImgH)
    end)

    local pImgData = graphics_canvas_to_image_data(pVwCnv, iDx, iDy, iCnvLim, iCnvLim)
    local pImg = love.graphics.newImage(pImgData)

    return pImg
end

local function make_icon_image(pImg, pRscGrid)
    local pIconImg = load_icon_image_canvas(pImg, pRscGrid)
    return pIconImg
end

function CRscElemItemPicture:load(siType, pImg, iId, iCount, sDesc, iFieldRef, pConfVw)
    self:_load(siType, iId, sDesc, pConfVw.W, pConfVw.H)
    self:_update_position(-1, -1)

    local pRscGrid = tpRscGrid[siType]

    self.pImg = make_icon_image(pImg, pRscGrid)
    self.iCount = iCount
end

function CRscElemItemPicture:update(dt)
    -- do nothing
end

function CRscElemItemPicture:update_position(iPx, iPy)
    self:_update_position(iPx, iPy)
end

function CRscElemItemPicture:draw()
    draw_resource_picture(self)
end
