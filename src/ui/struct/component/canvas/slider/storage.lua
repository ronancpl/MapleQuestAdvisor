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
require("ui.struct.component.element.texture")
require("utils.struct.class")

CStockSlider = createClass({
    pImgLeft,
    pImgMid,
    pImgRight,

    eTextureTd,
    eTextureTmo,
    eTextureTb,
    eTextureTp
})

local function make_image_bar(pDirSliderImgs, sImgName)
    local pImgDataBar = find_image_on_storage(pDirSliderImgs, sImgName)
    local pImgBar = love.graphics.newImage(pImgDataBar)

    return pImgBar
end

local function make_texture_thumb(pDirSliderImgs, sImgName)
    local pImgDataBox = find_image_on_storage(pDirSliderImgs, sImgName)
    local pImgBox = love.graphics.newImage(pImgDataBox)

    local eTexture = CTextureElem:new()
    eTexture:load(0, 0, pImgBox, 3, 3, 13, 6)

    return eTexture
end

function CStockSlider:_load_texture(pDirSliderImgs)
    self.pImgLeft = make_image_bar(pDirSliderImgs, "Slider.left")
    self.pImgMid = make_image_bar(pDirSliderImgs, "Slider.mid")
    self.pImgRight = make_image_bar(pDirSliderImgs, "Slider.right")

    self.eTextureTd = make_texture_thumb(pDirSliderImgs, "Slider.thumbDisabled")
    self.eTextureTmo = make_texture_thumb(pDirSliderImgs, "Slider.thumbMouseOver")
    self.eTextureTb = make_texture_thumb(pDirSliderImgs, "Slider.thumbNormal")
    self.eTextureTp = make_texture_thumb(pDirSliderImgs, "Slider.thumbPressed")

    self.teTextures = {
        thumbDisabled = self.eTextureTd,
        thumbMouseOver = self.eTextureTmo,
        thumbNormal = self.eTextureTb,
        thumbPressed = self.eTextureTp
    }
end

function CStockSlider:load()
    local pDirSliderImgs = load_image_storage_from_wz_sub(RWndPath.INTF_BASIC, "Slider")
    pDirSliderImgs = select_images_from_storage(pDirSliderImgs, {})

    self:_load_texture(pDirSliderImgs)
end

function CStockSlider:get_thumb(sThumbName)
    local m_teTextures = self.teTextures
    return m_teTextures[sThumbName]
end

function CStockSlider:get_bar()
    return self.pImgLeft, self.pImgMid, self.pImgRight
end

function load_image_stock_slider()
    local ctVwSlider = CStockSlider:new()
    ctVwSlider:load()

    return ctVwSlider
end
