--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.stack")

pStackWndPosition = SStack:new()

function push_stack_canvas_position(iRx, iRy)
    pStackWndPosition:push({iRx, iRy})
end

function pop_stack_canvas_position()
    pStackWndPosition:pop()
end

function read_canvas_position()
    local pPos = pStackWndPosition:get_top() or {0, 0}
    return unpack(pPos)
end
