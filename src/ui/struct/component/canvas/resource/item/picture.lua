--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.inventory")
require("ui.run.draw.canvas.resource.resource")
require("ui.struct.component.canvas.resource.item.item")
require("ui.struct.component.element.rect")
require("utils.struct.class")

CCanvasRscPicture = createClass({CCanvasResource, {
    eBox = CUserboxElem:new(),

    pImg,
    iPictWidth,
    iPictHeight,

    iCount
}})

function CCanvasRscPicture:get_object()
    return self.eBox
end

function CCanvasRscPicture:get_image()
    return self.pImg
end

function CCanvasRscPicture:get_count()
    return self.iCount
end

function CCanvasRscPicture:is_visible_count()
    return self.iCount ~= nil
end

function CCanvasRscPicture:load(pImg, iCount, sDesc, iFieldRef, iPictWidth, iPictHeight)
    self.sDesc = sDesc
    self.iFieldRef = iFieldRef

    self.eBox:load()
    self:load_text(sDesc, iFieldRef)

    self.pImg = pImg
    self.iCount = iCount

    self.iPictWidth = iPictWidth
    self.iPictHeight = iPictHeight
end

function CCanvasRscPicture:update(iPx, iPy)
    self.eBox:load(iPx, iPy, self.iPictWidth, self.iPictHeight)
end

function CCanvasRscPicture:draw()
    draw_resource_picture(self)
end
