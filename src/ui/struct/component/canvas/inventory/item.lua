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
require("ui.run.draw.canvas.inventory.inventory")
require("ui.run.draw.canvas.inventory.item")
require("ui.struct.component.element.rect")
require("utils.struct.class")

CCanvasItem = createClass({
    eBox = CUserboxElem:new(),

    pImg,
    pView,
    iCount
})

function CCanvasItem:get_object()
    return self.eBox
end

function CCanvasItem:get_image()
    return self.pImg
end

function CCanvasItem:get_view()
    return self.pView
end

function CCanvasItem:get_count()
    return self.iCount
end

function CCanvasItem:is_visible_count()
    local siType = math.floor(self.iId / 1000000)
    return not (siType == 1 or siType == 5)
end

function CCanvasItem:_load_image()
    local pImg = ctVwInvt:get_image_by_itemid(self.iId)

    self.pImg = pImg
    self.pView = load_item_canvas(pImg, RInventory.VW_INVT_ITEM.W, RInventory.VW_INVT_ITEM.H)
end

function CCanvasItem:load(iId, iCount)
    self.iId = iId
    self.iCount = iCount

    self.eBox:load()
    self:_load_image(iId)
end

function CCanvasItem:update(iPx, iPy)
    self.eBox:load(iPx, iPy, RInventory.VW_INVT_ITEM.W, RInventory.VW_INVT_ITEM.H)
end

function CCanvasItem:draw()
    draw_inventory_item(self)
end
