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
require("ui.constant.view.resource")
require("ui.run.build.interface.storage.split")
require("ui.run.build.interface.storage.basic.image")
require("ui.struct.component.basic.texture_data")
require("ui.texture.composition")
require("utils.procedure.unpack")
require("utils.struct.class")

CStockResourceTab = createClass({
    rgpTxtTabNames = {},
    tpImgTabQuads = {},

    pImgBgrd,
    pImgTextArea
})

local function load_image(sImgDirPath, sImgName)
    local pImgData = load_image_from_path(RWndPath.LOVE_IMAGE_DIR_PATH .. sImgDirPath .. "/" .. sImgName .. ".png")
    return love.graphics.newImage(pImgData)
end

local function load_tab_quad(tpImgTabQuads, sQuadName)
    tpImgTabQuads[sQuadName] = load_image(RWndPath.INTF_INVT_TAB, sQuadName)
end

function CStockResourceTab:_load_tab_names()
    local pFont = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "amaranthbd.ttf", 12)

    local m_rgpTxtTabNames = self.rgpTxtTabNames
    clear_table(m_rgpTxtTabNames)

    local rgsTabNames = {RResourceTable.TAB.MOBS.NAME, RResourceTable.TAB.ITEMS.NAME, RResourceTable.TAB.NPC.NAME, RResourceTable.TAB.FIELD_ENTER.NAME}
    for _, sName in ipairs(rgsTabNames) do
        local pTxtName = love.graphics.newText(pFont, sName)
        table.insert(m_rgpTxtTabNames, pTxtName)
    end
end

function CStockResourceTab:load()
    local m_tpImgTabQuads = self.tpImgTabQuads
    load_tab_quad(m_tpImgTabQuads, "fill0")
    load_tab_quad(m_tpImgTabQuads, "fill1")
    load_tab_quad(m_tpImgTabQuads, "left0")
    load_tab_quad(m_tpImgTabQuads, "left1")
    load_tab_quad(m_tpImgTabQuads, "middle0")
    load_tab_quad(m_tpImgTabQuads, "middle1")
    load_tab_quad(m_tpImgTabQuads, "middle2")
    load_tab_quad(m_tpImgTabQuads, "right0")
    load_tab_quad(m_tpImgTabQuads, "right1")

    self:_load_tab_names()
end

function CStockResourceTab:get_tab_components()
    return self.tpImgTabQuads
end

function CStockResourceTab:get_tab_names()
    return self.rgpTxtTabNames
end

function CStockResourceTab:get_background()
    return self.pImgBgrd
end

CStockResourceItem = createClass({
    pFontInfo,

    pTooltipBox,
    iIx, iIy, iIw, iIh
})

function CStockResourceItem:_load_fonts()
    self.pFontInfo = love.graphics.newFont(RWndPath.LOVE_FONT_DIR_PATH .. "amaranthbd.ttf", 12)
end

function CStockResourceItem:_load_images()
    self.pTooltipBox = love.graphics.newImage(ctVwStyle:get_image_data(RWndPath.INTF_SBOX))
    self.iIx, self.iIy, self.iIw, self.iIh = 3, 3, 115, 6
end

function CStockResourceItem:load()
    self:_load_fonts()
    self:_load_images()
end

function CStockResourceItem:get_font_info()
    return self.pFontInfo
end

function CStockResourceItem:get_background_tooltip()
    return self.pTooltipBox, self.iIx, self.iIy, self.iIw, self.iIh
end

CStockResource = createClass({
    pBgrdTextureData,
    pStockTab = CStockResourceTab:new(),
    pStockItem = CStockResourceItem:new()
})

function CStockResource:_load_texture_background()
    local pDirRscImgs = load_image_storage_from_wz_sub(RWndPath.INTF_BASIC, "Notice3")
    pDirRscImgs = select_images_from_storage(pDirRscImgs, {})

    local rgpImgBox = {}
    table.insert(rgpImgBox, love.graphics.newImage(find_image_on_storage(pDirRscImgs, "Notice3.t")))
    table.insert(rgpImgBox, love.graphics.newImage(find_image_on_storage(pDirRscImgs, "Notice3.c")))
    table.insert(rgpImgBox, love.graphics.newImage(find_image_on_storage(pDirRscImgs, "Notice3.s")))

    local pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh = compose_texture_from_imageset(rgpImgBox, 1, 15, 15)

    local pBgrdData = CBasicTexture:new()
    pBgrdData:load(pImgBox, iIx, iIy, iIw, iIh, iOx, iOy, iOw, iOh)

    self.pBgrdTextureData = pBgrdData
end

function CStockResource:_build_text_field(pImgTextField)
    local iW, iH = pImgTextField:getDimensions()
    local pCanvas = love.graphics.newCanvas(iW, iH)

    pCanvas:renderTo(function()
        love.graphics.clear()

        local iPx, iPy = 0, 0

        love.graphics.setScissor(0, 0, 285, iH)
        love.graphics.draw(pImgTextField, iPx, iPy)

        love.graphics.setScissor(0, 0, iW - 415, iH)
        love.graphics.draw(pImgTextField, iPx + 285 - 415, iPy)
    end)

    local pImgData = pCanvas:newImageData(0, 1, 0, 0, 285 + (iW - 415), iH)
    return love.graphics.newImage(pImgData)
end

function CStockResource:_load_text_field()
    local pDirRscImgs = load_image_storage_from_wz_sub(RWndPath.INTF_ITC, "MyPage")
    pDirRscImgs = select_images_from_storage(pDirRscImgs, {})

    local pImgTextField = love.graphics.newImage(find_image_on_storage(pDirRscImgs, "MyPage.backgrnd"))
    local pImg = self:_build_text_field(pImgTextField)

    self.pImgTextArea = pImg
end

function CStockResource:load()
    self.pStockTab:load()
    self.pStockItem:load()

    self:_load_texture_background()
    self:_load_text_field()
end

function CStockResource:get_background_data()
    return self.pBgrdTextureData
end

function CStockResource:get_background_text()
    return self.pImgTextArea
end

function CStockResource:get_tab_names()
    return self.pStockTab:get_tab_names()
end

function CStockResource:get_tab_components()
    return self.pStockTab:get_tab_components()
end

function CStockResource:get_font_info()
    return self.pStockItem:get_font_info()
end

function CStockResource:get_background_tooltip()
    return self.pStockItem:get_background_tooltip()
end

function load_image_stock_resources()
    local ctVwRscs = CStockResource:new()
    ctVwRscs:load()

    return ctVwRscs
end
