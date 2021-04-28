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
require("ui.struct.toolkit.subimage")
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

local function make_icon_image(pImg, iPictWidth, iPictHeight)
    local fCx, fCy = 0.2, 0.2
    local iW, iH = pImg:getDimensions()

    local iPx = math.iclamp(fCx * iW, 0, iW - iPictWidth)
    local iPy = math.iclamp(fCy * iH, 0, iH - iPictHeight)

    local pIconImg = make_subimage(pImg, iPx, iPy, iPictWidth, iPictHeight)
    return pIconImg
end

function CCanvasRscPicture:load(pImg, iCount, sDesc, iFieldRef, pConfVw)
    self:_load(sDesc, iFieldRef, pConfVw)

    self.pImg = make_icon_image(pImg, pConfVw.W, pConfVw.H)
    self.iCount = iCount
end

function CCanvasRscPicture:update(iPx, iPy)
    self:_update_position(iPx, iPy)
end

function CCanvasRscPicture:draw()
    draw_resource_picture(self)
end
