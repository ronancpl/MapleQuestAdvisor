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
require("ui.run.load.canvas.resource.picture")
require("ui.struct.component.basic.base")
require("ui.struct.component.canvas.resource.item.item")
require("ui.struct.component.element.rect")
require("ui.struct.toolkit.canvas")
require("utils.struct.class")

CRscElemItemPicture = createClass({CRscElemItem, {
    eImgOrig = CBasicElem:new(),

    pImg,
    iCount
}})

function CRscElemItemPicture:get_image()
    return self.pImg
end

function CRscElemItemPicture:get_picture()
    return self.pCnvImg
end

function CRscElemItemPicture:get_image_origin()
    return self.eImgOrig:get_pos()
end

function CRscElemItemPicture:get_count()
    return self.iCount
end

function CRscElemItemPicture:is_visible_count()
    return self.iCount ~= nil
end

local function calc_image_canvas_pos(pImg, pRscGrid, bUseShadow)
    local iImgW, iImgH = pImg:getDimensions()
    local iPicW, iPicH = pRscGrid.W, pRscGrid.H

    local iDx, iDy
    if bUseShadow then
        iDx = math.ceil((iImgW - iPicW) / 2)
        iDy = math.ceil((iImgH - iPicH) / 2)
    else
        iDx = math.ceil((iImgW - iPicW) / 2)  -- centralized horizontally, next to bottom
        iDy = iImgH - iPicH
    end

    return iDx, iDy
end

local function calc_scale_image_data(iDx, iDy, iCnvW, iCnvH, iToW, iToH)
    local fW = iToW / iCnvW
    local fH = iToH / iCnvH

    return math.ceil(iDx * fW), math.ceil(iDy * fH)
end

local function load_icon_image_canvas(pImg, pRscGrid, bUseShadow, pToVw)
    local iOrgW, iOrgH = pImg:getDimensions()
    local iImgW, iImgH = pToVw.W, pToVw.H
    local iPicW, iPicH = pRscGrid.W, pRscGrid.H

    local iOrgLim = math.max(iOrgW, iOrgH)
    local iPicLim = math.max(iPicW, iPicH)

    local iCnvLim = math.max(iOrgLim, iPicLim)

    local iDx, iDy = calc_image_canvas_pos(pImg, pRscGrid, bUseShadow)
    iDx, iDy = calc_scale_image_data(iDx, iDy, iCnvLim, iCnvLim, pToVw.W, pToVw.H)

    local pVwCnv = CViewCanvas:new()
    pVwCnv:load(iCnvLim, iCnvLim)

    pVwCnv:render_to(function()
        love.graphics.clear()
        graphics_canvas_draw(pImg, 0, 0, 0, iImgW, iImgH)
    end)

    local pImgData = graphics_canvas_to_image_data(pVwCnv, 0, 0, iCnvLim, iCnvLim)

    local pImg = love.graphics.newImage(pImgData)
    return pImg, 0 - iDx, 0 - iDy
end

function CRscElemItemPicture:_make_icon_image(pImg, siType, pToVw)
    local pRscGrid = self:get_conf()
    local bUseShadow = siType == RResourceTable.TAB.ITEMS.ID

    local pIconImg, iDx, iDy = load_icon_image_canvas(pImg, pRscGrid, bUseShadow, pToVw)
    return pIconImg, iDx, iDy
end

function CRscElemItemPicture:load(siType, tpRscGrid, pImg, iId, iCount, sDesc, iFieldRef, pConfVw, pToVw)
    self:_load(siType, tpRscGrid, iId, sDesc, pConfVw.W, pConfVw.H, iFieldRef)
    self:_update_position(-1, -1)

    local rX, rY
    self.pImg, rX, rY = self:_make_icon_image(pImg, siType, pToVw)

    local m_eImgOrig = self.eImgOrig
    m_eImgOrig:load(rX, rY)

    self.iCount = iCount

    self.pCnvImg = load_resource_picture(self)
end

function CRscElemItemPicture:update(dt)
    -- do nothing
end

function CRscElemItemPicture:update_position(iPx, iPy)
    self:_update_position(iPx, iPy)
end

function CRscElemItemPicture:draw(iPx, iPy)
    draw_resource_picture(self, iPx, iPy)
end
