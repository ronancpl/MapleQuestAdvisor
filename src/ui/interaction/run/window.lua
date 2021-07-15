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
    if pUiWnd:is_closed() then return end

    local iRx, iRy = pUiWnd:get_position()
    push_stack_canvas_position(iRx, iRy)
    pUiWnd:onmousemoved(x, y, dx, dy, istouch)
    pop_stack_canvas_position()
end

function _on_mousepressed(pUiWnd, x, y, button)
    if pUiWnd:is_closed() then return end

    local iRx, iRy = pUiWnd:get_position()
    push_stack_canvas_position(iRx, iRy)
    pUiWnd:onmousepressed(x, y, button)
    pop_stack_canvas_position()
end

function _on_mousereleased(pUiWnd, x, y, button)
    if pUiWnd:is_closed() then return end

    local iRx, iRy = pUiWnd:get_position()
    push_stack_canvas_position(iRx, iRy)
    pUiWnd:onmousereleased(x, y, button)
    pop_stack_canvas_position()
end

function _on_wheelmoved(pUiWnd, dx, dy)
    if pUiWnd:is_closed() then return end

    local iRx, iRy = pUiWnd:get_position()
    push_stack_canvas_position(iRx, iRy)
    pUiWnd:onwheelmoved(dx, dy)
    pop_stack_canvas_position()
end
