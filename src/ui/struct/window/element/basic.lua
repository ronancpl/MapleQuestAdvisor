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

CToolBasic = createClass({
    pCursor = CCursorElem:new()
})

function CToolBasic:get_cursor()
    return self.pCursor
end

function CToolBasic:get_button()
    return self.pButton
end

function CToolBasic:load()
    self.pCursor:load()
    self.pCursor:update_state(RWndPath.MOUSE.BT_NORMAL)
end

function CToolBasic:update(dt)
    self.pCursor:update(dt)
end

function CToolBasic:draw()
    self.pCursor:draw()
end
