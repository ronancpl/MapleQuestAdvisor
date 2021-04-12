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
require("ui.struct.component.canvas.slider.storage.image")
require("ui.struct.component.canvas.slider.storage.table")
require("ui.struct.component.element.texture")
require("utils.struct.class")

CViewSlider = createClass({
    pStockTd = CStockSlider:new(),
    pStockTmo = CStockSlider:new(),
    pStockTb = CStockSlider:new(),
    pStockTp = CStockSlider:new(),

    tpStocks    -- maps slider stocks
})

local function make_texture_thumb(pImgThumb)
    local eTexture = CTextureElem:new()
    eTexture:load(0, 0, pImgThumb, 3, 3, 13, 6)

    return eTexture
end

function CViewSlider:_compose_texture(pSliderDsb, pSliderEnb)
    self.pStockTd:load(nil, pSliderDsb:get_base(1), pSliderDsb:get_prev(1), pSliderDsb:get_next(1))
    self.pStockTmo:load(pSliderEnb:get_thumb(1), pSliderEnb:get_base(1), pSliderEnb:get_prev(1), pSliderEnb:get_next(1))
    self.pStockTb:load(pSliderEnb:get_thumb(3), pSliderEnb:get_base(3), pSliderEnb:get_prev(3), pSliderEnb:get_next(3))
    self.pStockTp:load(pSliderEnb:get_thumb(2), pSliderEnb:get_base(2), pSliderEnb:get_prev(2), pSliderEnb:get_next(2))

    self.tpStocks = {
        disabled = self.pStockTd,
        mouseOver = self.pStockTmo,
        normal = self.pStockTb,
        pressed = self.pStockTp
    }
end

function CViewSlider:_load_texture(pDirSliderImgs, sTextureSet)
    local pSlider = CImageSlider:new()
    pSlider:load_texture_set(pDirSliderImgs, sTextureSet)

    return pSlider
end

function CViewSlider:load(sSliderName)
    local pDirSliderImgs = load_image_storage_from_wz_sub(RWndPath.INTF_BASIC, sSliderName)
    pDirSliderImgs = select_images_from_storage(pDirSliderImgs, {})

    local pSliderDsb = self:_load_texture(pDirSliderImgs, sSliderName .. ".disabled")
    local pSliderEnb = self:_load_texture(pDirSliderImgs, sSliderName .. ".enabled")
    self:_compose_texture(pSliderDsb, pSliderEnb)
end

function CViewSlider:_get_slider(sState)
    return self.tpStocks[sState]
end

function CViewSlider:get_thumb(sState)
    local pSlider = self:_get_slider(sState)
    return pSlider:get_thumb()
end

function CViewSlider:get_prev(sState)
    local pSlider = self:_get_slider(sState)
    return pSlider:get_prev()
end

function CViewSlider:get_next(sState)
    local pSlider = self:_get_slider(sState)
    return pSlider:get_next()
end

function CViewSlider:get_bar(sState)
    local pSlider = self:_get_slider(sState)
    return pSlider:get_bar()
end
