--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.copy")
require("utils.procedure.unpack")
require("utils.struct.class")
require("utils.struct.mapqueue")

CWndHandler = createClass({
    rgpWnds = {},

    tpWndClosed = {},
    tpWndOpened = {},

    tpActClosed = {},
    tpActOpened = {},

    pFocusUiWnd = nil,
    bUpdFocus = true
})

function CWndHandler:_insert_open(pWnd)
    local m_rgpWnds = self.rgpWnds
    table.insert(m_rgpWnds, pWnd)
end

function CWndHandler:_remove_open(pWnd)
    local m_rgpWnds = self.rgpWnds

    local iIdx = -1
    for i = #m_rgpWnds, 1, -1 do
        if m_rgpWnds[i] == pWnd then
            iIdx = i
            break
        end
    end

    table.remove(m_rgpWnds, iIdx)
end

function CWndHandler:set_opened(pWnd)
    self.tpActOpened[pWnd] = 1
    self.tpWndClosed[pWnd] = nil

    self:_insert_open(pWnd)

    self.bUpdFocus = true
end

function CWndHandler:is_closed(pWnd)
    return self.tpWndOpened[pWnd] == nil
end

function CWndHandler:set_closed(pWnd)
    self:_remove_open(pWnd)

    self.tpActClosed[pWnd] = 1
    self.tpWndOpened[pWnd] = nil

    if pWnd == self.pFocusUiWnd then
        self.bUpdFocus = true
    end
end

local function update_state(tpTo, tpFrom)
    table_merge(tpTo, tpFrom)
    clear_table(tpFrom)
end

function CWndHandler:update()
    update_state(self.tpWndClosed, self.tpActClosed)
    update_state(self.tpWndOpened, self.tpActOpened)
end

function CWndHandler:list_opened()
    local rgpOpenWnds = {}

    local m_tpWndOpened = self.tpWndOpened
    local m_rgpWnds = self.rgpWnds

    local rgpWnds = table_copy(m_rgpWnds)   -- in open order
    for _, pWnd in ipairs(rgpWnds) do
        if m_tpWndOpened[pWnd] ~= nil then
            table.insert(rgpOpenWnds, pWnd)
        end
    end

    return rgpOpenWnds
end

function CWndHandler:_is_mouse_in_range(pUiWnd, x, y)
    local iLx, iTy, iRx, iBy = pUiWnd:get_ltrb()
    return math.between(x, iLx, iRx) and math.between(y, iTy, iBy)
end

function CWndHandler:get_focus_wnd()
    return self.pFocusUiWnd
end

end

function CWndHandler:_find_mouse_focus_wnd(x, y)
    local rgpWndOpened = self:list_opened()
    for i = #rgpWndOpened, 1, -1 do
        local pUiWnd = rgpWndOpened[i]
        if self:_is_mouse_in_range(pUiWnd, x, y) then
            return pUiWnd
        end
    end

    return nil
end

function CWndHandler:_is_mouse_in_wnd(x, y)
    local m_pFocusUiWnd = self.pFocusUiWnd
    return m_pFocusUiWnd ~= nil and self:_is_mouse_in_range(m_pFocusUiWnd, x, y)
end

function CWndHandler:on_mousemoved(x, y, dx, dy, istouch)
    if self:_is_mouse_in_wnd(x, y) then
        self.bUpdFocus = true
    end

    if true then
        local pUiWnd = self:_find_mouse_focus_wnd(x, y)
        if pUiWnd ~= nil then
            self.pFocusUiWnd = pUiWnd
            self.bUpdFocus = false
        end
    end
end
