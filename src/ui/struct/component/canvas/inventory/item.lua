--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.draw.canvas.inventory.inventory")
require("ui.struct.component.basic.base")
require("utils.struct.class")

CCanvasItem = createClass({
    eElem = CBasicElem:new(),

    pImg,
    iCount
})

function CCanvasItem:get_origin()
    return self.eElem:get_pos()
end

function CCanvasItem:get_image()
    return self.pImg
end

function CCanvasItem:get_count()
    return self.iCount
end

function CCanvasItem:load(iId, iCount)
    self.eElem:load(0, 0)

    self.pImg = ctVwInvt:get_image_by_itemid(iId)
    self.iCount = iCount
end

function CCanvasItem:update(iPx, iPy)
    self.eElem:load(iPx, iPy)
end

function CCanvasItem:draw()
    draw_inventory_item(self)
end
