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
require("ui.struct.window.element.basic.mouse")
require("utils.struct.class")

CWndBasic = createClass({
    pCursor = CWndCursor:new()
})

function CWndBasic:get_cursor()
    return self.pCursor
end

function CWndBasic:load()
    self.pCursor:load()
    self.pCursor:load_mouse(RWndPath.MOUSE.BT_GAME)
end

function CWndBasic:update(dt)
    self.pCursor:update(dt)
end

function CWndBasic:draw()
    self.pCursor:draw()
end
