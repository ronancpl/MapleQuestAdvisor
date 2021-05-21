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
require("utils.procedure.copy")
require("utils.struct.class")

CStockButton = createClass({
    pDirBasicQuads,
    trgpButtonQuads
})

function CStockButton:_load_basic_images()
    local sBasicImgPath = RWndPath.INTF_BASIC

    local pDirBasicQuads = load_quad_storage_from_wz_sub(sBasicImgPath, "BtClose")
    pDirBasicQuads = select_animations_from_storage(pDirBasicQuads, {})

    self.pDirBasicQuads = pDirBasicQuads
end

local function create_button_from_quad(pQuad)
    local pQuadImg = pQuad:get_image()

    local pImg = pQuadImg:get_img()

    local iOx
    local iOy
    local iZ
    iOx, iOy = pQuadImg:get_origin()
    iZ = pQuadImg:get_z()

    local pButtonQuad = CBasicQuad:new()

    local iDelay = RWndConfig.QUAD_DELAY_DEF
    pButtonQuad:load(pImg, iOx, iOy, iZ, iDelay)

    return pButtonQuad
end

function CStockButton:_load_button(sButtonName)
    local m_pDirBasicQuads = self.pDirBasicQuads
    local rgpQuads = find_animation_on_storage(m_pDirBasicQuads, sButtonName)

    local rgpButtonQuads = {}
    for _, pQuad in ipairs(rgpQuads) do
        local pButton = create_button_from_quad(pQuad)
        table.insert(rgpButtonQuads, pButton)
    end

    local m_trgpButtonQuads = self.trgpButtonQuads
    m_trgpButtonQuads[sButtonName] = rgpButtonQuads
end

function CStockButton:load()
    self:_load_basic_images()

    self.trgpButtonQuads = {}
    self:_load_button("normal")
    self:_load_button("mouseOver")
    self:_load_button("disabled")
    self:_load_button("pressed")
end

function load_image_stock_button()
    local ctVwButton = CStockButton:new()
    ctVwButton:load()

    return ctVwButton
end
