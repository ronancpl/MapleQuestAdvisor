--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.path")
require("ui.run.build.interface.storage.split")
require("ui.struct.canvas.worldmap.basic.image")
require("ui.struct.component.canvas.selectbox.storage.image")
require("ui.struct.component.canvas.selectbox.storage.table")
require("ui.struct.component.element.texture")
require("utils.struct.class")

CViewSelectBox = createClass({
    pStockTd = CStockSelectBox:new(),
    pStockTmo = CStockSelectBox:new(),
    pStockTb = CStockSelectBox:new(),
    pStockTp = CStockSelectBox:new(),
    pStockTslct = CStockSelectBox:new(),

    tpStocks    -- maps SelectBox stocks
})

function CViewSelectBox:_compose_texture(pSelectBoxTd, pSelectBoxTmo, pSelectBoxTb, pSelectBoxTp, pSelectBoxTslct)
    self.pStockTd:load(pSelectBoxTd:get_left(), pSelectBoxTd:get_center(), pSelectBoxTd:get_right())
    self.pStockTmo:load(pSelectBoxTmo:get_left(), pSelectBoxTmo:get_center(), pSelectBoxTmo:get_right())
    self.pStockTb:load(pSelectBoxTb:get_left(), pSelectBoxTb:get_center(), pSelectBoxTb:get_right())
    self.pStockTp:load(pSelectBoxTp:get_left(), pSelectBoxTp:get_center(), pSelectBoxTp:get_right())
    self.pStockTslct:load(pSelectBoxTslct:get_left(), pSelectBoxTslct:get_center(), pSelectBoxTslct:get_right())

    self.tpStocks = {
        disabled = self.pStockTd,
        mouseOver = self.pStockTmo,
        normal = self.pStockTb,
        pressed = self.pStockTp,
        selected = self.pStockTslct
    }
end

function CViewSelectBox:_load_texture(pDirSelectBoxImgs, sTextureSet, sTextureFamily)
    local pSelectBox = CImageSelectBox:new()
    pSelectBox:load_texture_set(pDirSelectBoxImgs, sTextureSet, sTextureFamily)

    return pSelectBox
end

function CViewSelectBox:load(sSelectBoxName)
    local pDirSelectBoxImgs = load_image_storage_from_wz_sub(RWndPath.INTF_BASIC, sSelectBoxName)
    pDirSelectBoxImgs = select_images_from_storage(pDirSelectBoxImgs, {})

    local pSelectBoxDsb = self:_load_texture(pDirSelectBoxImgs, sSelectBoxName, "disabled")
    local pSelectBoxTmo = self:_load_texture(pDirSelectBoxImgs, sSelectBoxName, "mouseOver")
    local pSelectBoxTb = self:_load_texture(pDirSelectBoxImgs, sSelectBoxName, "normal")
    local pSelectBoxTp = self:_load_texture(pDirSelectBoxImgs, sSelectBoxName, "pressed")
    local pSelectBoxTslct = self:_load_texture(pDirSelectBoxImgs, sSelectBoxName, "selected")
    self:_compose_texture(pSelectBoxDsb, pSelectBoxTmo, pSelectBoxTb, pSelectBoxTp, pSelectBoxTslct)
end

function CViewSelectBox:_get_selectbox(sState)
    return self.tpStocks[sState]
end

function CViewSelectBox:get_center(sState)
    local pSelectBox = self:_get_selectbox(sState)
    return pSelectBox:get_center()
end

function CViewSelectBox:get_left(sState)
    local pSelectBox = self:_get_selectbox(sState)
    return pSelectBox:get_left()
end

function CViewSelectBox:get_right(sState)
    local pSelectBox = self:_get_selectbox(sState)
    return pSelectBox:get_right()
end
