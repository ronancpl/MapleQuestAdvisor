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
require("ui.interaction.run.window")

local function fetch_ui_window()
    return pUiWmap
end

function on_mousemoved(x, y, dx, dy, istouch)
    local pUiWnd = fetch_ui_window()
    _on_mousemoved(pUiWnd, x, y, dx, dy, istouch)
end

function on_mousepressed(x, y, button)
    local pUiWnd = fetch_ui_window()
    _on_mousepressed(pUiWnd, x, y, button)
end

function on_mousereleased(x, y, button)
    local pUiWnd = fetch_ui_window()
    _on_mousereleased(pUiWnd, x, y, button)
end

function on_wheelmoved(dx, dy)
    local pUiWnd = fetch_ui_window()
    _on_wheelmoved(pUiWnd, dx, dy)
end
