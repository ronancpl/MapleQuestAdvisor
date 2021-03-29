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
require("utils.struct.class")

CStyleBoxStock = createClass({
    tpImgDatum = {}
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

function CStyleBoxStock:_load_stylebox_image(sImgPath)
    local pImgData = love.image.newImageData(RWndPath.LOVE_IMAGE_DIR_PATH .. sImgPath)

    -- white color-coded as transparent
    pImgData:mapPixel(function (x, y, r, g, b, a)
        if r == 1 and g == 1 and b == 1 then
            a = 0.0
        -- elseif math.between(r, math.range(RStyleBoxColor.R, -0.2, 0.2)) and math.between(g, math.range(RStyleBoxColor.G, -0.2, 0.2)) and math.between(b, math.range(RStyleBoxColor.B, -0.2, 0.2)) then
        elseif true then
            a = RStyleBoxColor.A
        end

        return r,g,b,a
    end)

    self.tpImgDatum[sImgPath] = pImgData
end

function CStyleBoxStock:load_stylebox_images()
    local rgsImgPaths = {RWndPath.INTF_SBOX, RWndPath.INTF_ITEM_SHADOW}
    for _, sImgPath in ipairs(rgsImgPaths) do
        self:_load_stylebox_image(sImgPath)
    end
end

function CStyleBoxStock:get_image_data(sImgPath)
    local pImgData = self.tpImgDatum[sImgPath]
    return pImgData
end

function load_stylebox_images()
    local pStyleboxStock = CStyleBoxStock:new()
    pStyleboxStock:load_stylebox_images()

    return pStyleboxStock
end
