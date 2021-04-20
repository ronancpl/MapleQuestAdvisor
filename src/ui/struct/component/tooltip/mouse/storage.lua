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

CStockCursor = createClass({
    pDirBasicQuads,
    trgpCursorQuads,
    rgsImgItemPath,
    pImgShd
})

function CStockCursor:_load_basic_images()
    local sBasicImgPath = RWndPath.INTF_BASIC

    local pDirBasicQuads = load_quad_storage_from_wz_sub(sBasicImgPath, "Cursor")
    pDirBasicQuads = select_animations_from_storage(pDirBasicQuads, {})

    self.pDirBasicQuads = pDirBasicQuads
end

local function create_cursor_from_quad(pQuad)
    local pQuadImg = pQuad:get_image()

    local pImg = pQuadImg:get_img()
    local pCursor = love.mouse.newCursor(pImg, 0, 0)

    local iOx
    local iOy
    local iZ
    iOx, iOy = pQuadImg:get_origin()
    iZ = pQuadImg:get_z()

    local pCursorQuad = CBasicQuad:new()

    local iDelay = math.max(pQuad:get_delay(), RWndConfig.QUAD_DELAY_DEF)
    pCursorQuad:load(pCursor, iOx, iOy, iZ, iDelay)

    return pCursorQuad
end

function CStockCursor:_load_mouse_cursor(sCursorName)
    local m_pDirBasicQuads = self.pDirBasicQuads
    local rgpQuads = find_animation_on_storage(m_pDirBasicQuads, sCursorName)

    local rgpCursorQuads = {}
    for _, pQuad in ipairs(rgpQuads) do
        local pCursor = create_cursor_from_quad(pQuad)
        table.insert(rgpCursorQuads, pCursor)
    end

    local m_trgpCursorQuads = self.trgpCursorQuads
    m_trgpCursorQuads[sCursorName] = rgpCursorQuads
end

function CStockCursor:_load_mouse_animations()
    self.trgpCursorQuads = {}

    self:_load_mouse_cursor(RWndPath.MOUSE.BT_DOWN)
    self:_load_mouse_cursor(RWndPath.MOUSE.BT_NORMAL)
    self:_load_mouse_cursor(RWndPath.MOUSE.BT_GAME)
end

function CStockCursor:load()
    self:_load_basic_images()
    self:_load_mouse_animations()
end

function CStockCursor:get_mouse_animation(sCursorName)
    local m_trgpCursorQuads = self.trgpCursorQuads
    return m_trgpCursorQuads[sCursorName]
end

function load_image_stock_mouse()
    local ctVwCursor = CStockCursor:new()
    ctVwCursor:load()

    return ctVwCursor
end
