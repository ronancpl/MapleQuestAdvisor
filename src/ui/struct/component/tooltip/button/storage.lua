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
require("ui.constant.view.button")
require("ui.constant.view.resource")
require("utils.procedure.copy")
require("utils.procedure.string")
require("utils.struct.class")

CStockButton = createClass({
    tpDirBasicQuads = {},
    trgpButtonQuads = {}
})

local function fetch_button_name_path(sButtonImg)
    local iIdx = string.rfind(sButtonImg, ".img")
    return sButtonImg:sub(iIdx + 5), sButtonImg:sub(1, iIdx + 3)
end

local function fetch_button_inner_path(sButtonImg)
    return fetch_button_name_path(sButtonImg)
end

local function fetch_button_name(sButtonPath)
    local iIdx = string.rfind(sButtonPath, "/") or 0
    return (sButtonPath:sub(iIdx+1))
end

function CStockButton:_load_button_images(sButtonImgPath)
    local sButtonPath, sButtonImg = fetch_button_name_path("UI.wz/" .. sButtonImgPath)

    local pDirBasicQuads = load_quad_storage_from_wz_sub(sButtonImg, sButtonPath)
    pDirBasicQuads = select_animations_from_storage(pDirBasicQuads, {})

    self.tpDirBasicQuads[sButtonPath] = pDirBasicQuads
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

function CStockButton:_load_button_animation(sButtonImg)
    local m_tpDirBasicQuads = self.tpDirBasicQuads

    local sButtonPath = fetch_button_inner_path(sButtonImg)
    local pDirCursorQuads = m_tpDirBasicQuads[sButtonPath]

    local tpStateButtons = {}
    for _, sCursorState in pairs(RButtonState) do
        local rgpButtonQuads = {}

        local rgpQuads = find_animation_on_storage(pDirCursorQuads, sCursorState)
        if rgpQuads ~= nil then
            for _, pQuad in ipairs(rgpQuads) do
                local pButton = create_button_from_quad(pQuad)
                table.insert(rgpButtonQuads, pButton)
            end
        end

        tpStateButtons[sCursorState] = rgpButtonQuads
    end

    local m_trgpButtonQuads = self.trgpButtonQuads

    local sButtonName = fetch_button_name(sButtonPath)
    m_trgpButtonQuads[sButtonName] = tpStateButtons
end

function CStockButton:get_button(sButtonName)
    local m_trgpButtonQuads = self.trgpButtonQuads
    return m_trgpButtonQuads[sButtonName]
end

function CStockButton:_load_button(sBtPath)
    self:_load_button_images(sBtPath)
    self:_load_button_animation(sBtPath)
end

function CStockButton:load()
    clear_table(self.tpDirBasicQuads)
    clear_table(self.trgpButtonQuads)

    self:_load_button("Basic.img/BtClose")
    for _, pBtItem in pairs(RActionButton) do
        self:_load_button(pBtItem.PATH)
    end
end

function load_image_stock_button()
    local ctVwButton = CStockButton:new()
    ctVwButton:load()

    return ctVwButton
end
