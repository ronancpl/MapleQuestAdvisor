--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.quad")
require("ui.path.path")
require("ui.run.build.interface.storage.basic.quad")
require("ui.run.build.interface.storage.split")
require("ui.struct.component.element.dynamic")
require("utils.struct.class")

CBasicStorage = createClass({
    eDynam = CDynamicElem:new(),
    pCurMouse,
    pDirBasicQuads,
    trgpCursorQuads
})

function CBasicStorage:_load_basic_images()
    local sBasicImgPath = RInterface.INTF_BASIC

    local pDirBasicQuads = load_quad_storage_from_wz_sub(sBasicImgPath, "Cursor")
    pDirBasicQuads = select_animations_from_storage(pDirBasicQuads, {})

    self.pDirBasicQuads = pDirBasicQuads
end

local function create_cursor_from_quad(pQuad)
    local iDelay = pQuad:get_delay()
    local pQuadImg = pQuad:get_image()

    local pImg = pQuadImg:get_img()
    local pCursor = love.mouse.newCursor(pImg, 0, 0)

    local iOx
    local iOy
    local iZ
    iOx, iOy = pQuadImg:get_origin()
    iZ = pQuadImg:get_z()

    local pCursorQuad = CBasicQuad:new()
    pCursorQuad:load(pCursor, iOx, iOy, iZ, iDelay)

    return pCursorQuad
end

function CBasicStorage:_load_mouse_cursor(sCursorName)
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

function CBasicStorage:_load_mouse_animations()
    self.trgpCursorQuads = {}

    self:_load_mouse_cursor(RInterface.MOUSE.BT_DOWN)
    self:_load_mouse_cursor(RInterface.MOUSE.BT_NORMAL)
    self:_load_mouse_cursor(RInterface.MOUSE.BT_GAME)
end

function CBasicStorage:load_mouse(sCursorName)
    local m_trgpCursorQuads = self.trgpCursorQuads

    self.eDynam:load(0, 0, m_trgpCursorQuads[sCursorName])
    --self.eDynam:instantiate()
    self.eDynam:after_load()
end

function CBasicStorage:load()
    self:_load_basic_images()
    self:_load_mouse_animations()
end

function CBasicStorage:update(dt)
    self.eDynam:update(dt)
end

function CBasicStorage:refresh_cursor()
    local pCurImg = self.eDynam:update_drawing()
    local pNextCursor = pCurImg:get_img()

    if self.pCurMouse ~= pNextCursor then
        self.pCurMouse = pNextCursor
        love.mouse.setCursor(pNextCursor)
    end
end

function CBasicStorage:draw()
    -- do nothing
end
