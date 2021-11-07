--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.image")
require("ui.constant.path")
require("utils.struct.class")

CStockStyleBox = createClass({
    tpImgDatum = {},
    tpImgs = {}
})

local function ink(sHexColor)   -- hex color conversion by litearc
    local _,_,r,g,b,a = sHexColor:find('(%x%x)(%x%x)(%x%x)(%x%x)')
    return {tonumber(r,16),tonumber(g,16),tonumber(b,16),tonumber(a,16)}
end

local pBoxColors = ink("113355FF")

RStyleBoxColor = {
    R = pBoxColors[1] / 256,
    G = pBoxColors[2] / 256,
    B = pBoxColors[3] / 256,
    A = 0.8
}

function CStockStyleBox:_load_stylebox_image(sImgDirPath)
    local pImgData = load_image_from_path(sImgDirPath)

    -- white color-coded as transparent

    self.tpImgDatum[sImgDirPath] = pImgData
end

function CStockStyleBox:load()
    local rgsImgPaths = {RWndPath.INTF_SBOX, RWndPath.INTF_ITEM_SHADOW}
    for _, sImgPath in ipairs(rgsImgPaths) do
        self:_load_stylebox_image(sImgPath)
    end
end

function CStockStyleBox:get_image_data(sImgPath)
    local pImgData = self.tpImgDatum[sImgPath]
    return pImgData
end

function CStockStyleBox:get_image(sImgPath)
    local pImgData = self:get_image_data(sImgPath)

    local pImg = self.tpImgs[pImgData]
    if pImg == nil then
        pImg = love.graphics.newImage(pImgData)
    end

    return pImg
end

function load_image_stock_stylebox()
    local ctVwStyle = CStockStyleBox:new()
    ctVwStyle:load()

    return ctVwStyle
end
