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
require("ui.constant.config")
require("ui.constant.path")
require("ui.run.build.interface.storage.basic.quad")
require("ui.run.build.interface.storage.split")
require("ui.struct.component.canvas.window.state")
require("ui.struct.component.element.dynamic")
require("utils.struct.class")

local bit = require("bit")

CCursorElem = createClass({
    eDynam = CDynamicElem:new(),
    pCurMouse,
    btState = 0,
    bScrollVert,
    iCursorId = -1
})

function CCursorElem:_reset_state_bitfield()
    self.btState = bit.tobit(0)
end

function CCursorElem:_update_state_bitfield(iId, bApply)
    local m_btState = self.btState
    if bApply then
        local btOpt = bit.lshift(1, iId)
        self.btState = bit.bor(m_btState, btOpt)
    else
        local btOpt = bit.bnot(bit.lshift(1, iId))
        self.btState = bit.band(m_btState, btOpt)
    end
end

RMouseState = {
    PRESSED = 0,
    SCROLL = 1,
    CLICKABLE = 2
}

function CCursorElem:_update_state_mouse(iOpt)
    local iCursorId = math.abs(iOpt)
    if iCursorId == RWndPath.MOUSE.BT_DOWN then
        self:_update_state_bitfield(RMouseState.PRESSED, iOpt > 0)
    elseif iCursorId == RWndPath.MOUSE.BT_SCROLL_X or iCursorId == RWndPath.MOUSE.BT_SCROLL_Y then
        self.bScrollVert = iCursorId == RWndPath.MOUSE.BT_SCROLL_Y
        self:_update_state_bitfield(RMouseState.SCROLL, iOpt > 0)
    elseif iCursorId == RWndPath.MOUSE.BT_CLICKABLE then
        self:_update_state_bitfield(RMouseState.CLICKABLE, iOpt > 0)
    elseif iCursorId == RWndPath.MOUSE.BT_NORMAL then
        self:_reset_state_bitfield()
    end
end

function CCursorElem:_fetch_mouse_state(iCursorOpt)
    local iUpdateCursorId = math.abs(iCursorOpt)

    local m_btState = self.btState
    if bit.band(m_btState, bit.lshift(1, RMouseState.PRESSED)) ~= 0 then
        return RWndPath.MOUSE.BT_DOWN
    elseif bit.band(m_btState, bit.lshift(1, RMouseState.SCROLL)) ~= 0 then
        return self.bScrollVert and RWndPath.MOUSE.BT_SCROLL_Y or RWndPath.MOUSE.BT_SCROLL_X
    elseif bit.band(m_btState, bit.lshift(1, RMouseState.CLICKABLE)) ~= 0 then
        return RWndPath.MOUSE.BT_CLICKABLE
    else
        return RWndPath.MOUSE.BT_NORMAL
    end
end

function CCursorElem:_fetch_state(iCursorOpt)
    self:_update_state_mouse(iCursorOpt)

    local iNextCursorId = self:_fetch_mouse_state(iCursorOpt)
    return iNextCursorId
end

function CCursorElem:load_mouse(iCursorOpt)
    local iNewCursorId = self:_fetch_state(iCursorOpt)
    if self.iCursorId ~= iNewCursorId then
        self.iCursorId = iNewCursorId

        local rgpCursorQuads = ctVwCursor:get_mouse_animation(iNewCursorId)
        self.eDynam:load(0, 0, rgpCursorQuads)
        --self.eDynam:instantiate()
        self.eDynam:after_load()
    end
end

function CCursorElem:_refresh_cursor()
    local pCurImg = self.eDynam:update_drawing()
    local pNextCursor = pCurImg:get_img()

    if self.pCurMouse ~= pNextCursor then
        self.pCurMouse = pNextCursor
        love.mouse.setCursor(pNextCursor)
    end
end

function CCursorElem:load()
    -- do nothing
end

function CCursorElem:update(dt)
    self.eDynam:update(dt)
    self:_refresh_cursor()
end

function CCursorElem:draw()
    -- do nothing
end
