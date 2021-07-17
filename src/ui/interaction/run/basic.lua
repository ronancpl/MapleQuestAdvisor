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

function on_mousepressed(x, y, button)
    if button == 1 then
        pFrameBasic:get_cursor():load_mouse(RWndPath.MOUSE.BT_DOWN)
    end
end

function on_mousereleased(x, y, button)
    if button == 1 then
        pFrameBasic:get_cursor():load_mouse(-RWndPath.MOUSE.BT_DOWN)
    end
end
