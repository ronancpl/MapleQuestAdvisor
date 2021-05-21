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
require("ui.struct.component.canvas.button.button")
require("utils.struct.class")

CWndBase = createClass({
    pBtClose = CButtonElem:new()
})

local function is_mouse_in_range(pElem, x, y)
    local iLx, iTy, iRx, iBy = pElem:get_object():get_ltrb()
    return math.between(x, iLx, iRx) and math.between(y, iTy, iBy)
end

function CWndBase:_onmousemoved(x, y, dx, dy, istouch)
    -- do nothing
end

function CWndBase:_onmousepressed(x, y, button)
    -- do nothing
end

function CWndBase:_onmousereleased(x, y, button)
    local pElem = self.pBtClose
    if is_mouse_in_range(pElem, x, y) then
        local fn_onmousereleased = pElem.onmousereleased
        if fn_onmousereleased ~= nil then
            fn_onmousereleased(pElem, x, y, button)
        end
    end
end

function CWndBase:_onwheelmoved(dx, dy)
    -- do nothing
end

function CWndBase:_load(iWidth, iHeight)
    self.pBtClose:load(RWndPath.BUTTON.BT_CLOSE, iWidth - RResourceTable.VW_WND.VW_CLOSE.FIL_X, iHeight - RResourceTable.VW_WND.VW_CLOSE.FIL_Y)
end

function CWndBase:get_bt_close()
    return self.pBtClose
end

function CWndBase:_set_window_size(iWidth, iHeight)
    self.pBtClose:set_origin(iWidth - RResourceTable.VW_WND.VW_CLOSE.FIL_X, iHeight - RResourceTable.VW_WND.VW_CLOSE.FIL_Y)
end
