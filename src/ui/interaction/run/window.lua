--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.update.canvas.position")

function _on_mousemoved(pUiWnd, x, y, dx, dy, istouch)
    local fn_onwnd_act = pUiWnd.onmousemoved
    if pUiWnd:is_closed() or not fn_onwnd_act or not pWndHandler:is_focus_wnd(pUiWnd) then return end

    local iRx, iRy = pUiWnd:get_position()
    push_stack_canvas_position(iRx, iRy)
    fn_onwnd_act(pUiWnd, x, y, dx, dy, istouch)
    pop_stack_canvas_position()
end

function _on_mousepressed(pUiWnd, x, y, button)
    local fn_onwnd_act = pUiWnd.onmousepressed
    if pUiWnd:is_closed() or not fn_onwnd_act or not pWndHandler:is_focus_wnd(pUiWnd) then return end

    local wx, wy = pUiWnd:get_position()
    push_stack_canvas_position(wx, wy)
    fn_onwnd_act(pUiWnd, x - wx, y - wy, button)
    pop_stack_canvas_position()
end

function _on_mousereleased(pUiWnd, x, y, button)
    local fn_onwnd_act = pUiWnd.onmousereleased
    if pUiWnd:is_closed() or not fn_onwnd_act or not pWndHandler:is_focus_wnd(pUiWnd) then return end

    local wx, wy = pUiWnd:get_position()
    push_stack_canvas_position(wx, wy)
    fn_onwnd_act(pUiWnd, x - wx, y - wy, button)
    pop_stack_canvas_position()
end

function _on_wheelmoved(pUiWnd, dx, dy)
    local fn_onwnd_act = pUiWnd.onwheelmoved
    if pUiWnd:is_closed() or not fn_onwnd_act or not pWndHandler:is_focus_wnd(pUiWnd) then return end

    local wx, wy = pUiWnd:get_position()
    push_stack_canvas_position(wx, wy)
    fn_onwnd_act(pUiWnd, dx, dy)
    pop_stack_canvas_position()
end
