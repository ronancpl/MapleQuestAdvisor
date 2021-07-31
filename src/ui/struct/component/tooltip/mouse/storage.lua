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
require("ui.struct.component.canvas.window.state")
require("utils.procedure.copy")
require("utils.struct.class")

CStockCursor = createClass({
    tpDirBasicQuads = {},
    tpCursorQuads = {},
    rgsImgItemPath,
    pImgShd
})

function CStockCursor:_load_mouse_quads()
    local pDirBasicQuads = load_quad_storage_from_wz_sub(RWndPath.INTF_BASIC, "Cursor")
    local pDirCursorQuads = select_animations_from_storage(pDirBasicQuads, "")

    for sCursorName, pDirStateQuads in pairs(pDirCursorQuads:get_contents()) do
        local iCursorId = tonumber(sCursorName) or 0
        self.tpDirBasicQuads[iCursorId] = pDirStateQuads
    end
end

local function create_cursor_from_quad(pQuad)
    local pQuadImg = pQuad:get_image()

    local iOx
    local iOy
    local iZ
    iOx, iOy = pQuadImg:get_origin()
    iZ = pQuadImg:get_z()

    local pImg = pQuadImg:get_img()
    local pCursor = love.mouse.newCursor(pImg, iOx, iOy)

    local pCursorQuad = CBasicQuad:new()

    local iDelay = math.max(pQuad:get_delay(), RWndConfig.QUAD_DELAY_DEF)
    pCursorQuad:load(pCursor, iOx, iOy, iZ, iDelay)

    return pCursorQuad
end

function CStockCursor:_load_mouse_cursors()
    local m_tpCursorQuads = self.tpCursorQuads

    local m_tpDirBasicQuads = self.tpDirBasicQuads
    for iCursorId, pDirCursorQuads in pairs(m_tpDirBasicQuads) do
        local trgpCursorQuads = {}
        local sCursorState = RButtonState.NORMAL

        local rgpCursorQuads = {}
        local rgpQuads = pDirCursorQuads
        for _, pQuad in ipairs(rgpQuads) do
            local pCursor = create_cursor_from_quad(pQuad)
            table.insert(rgpCursorQuads, pCursor)
        end

        trgpCursorQuads[sCursorState] = rgpCursorQuads

        m_tpCursorQuads[iCursorId] = trgpCursorQuads
    end
end

function CStockCursor:_load_mouse_frames()
    clear_table(self.tpDirBasicQuads)
    self:_load_mouse_quads()
end

function CStockCursor:_load_mouse_animations()
    clear_table(self.trgpCursorQuads)
    self:_load_mouse_cursors()
end

function CStockCursor:load()
    self:_load_mouse_frames()
    self:_load_mouse_animations()
end

function CStockCursor:get_mouse_animation(iCursorId)
    local m_tpCursorQuads = self.tpCursorQuads
    return m_tpCursorQuads[iCursorId][RButtonState.NORMAL]
end

function load_image_stock_mouse()
    local ctVwCursor = CStockCursor:new()
    ctVwCursor:load()

    return ctVwCursor
end
