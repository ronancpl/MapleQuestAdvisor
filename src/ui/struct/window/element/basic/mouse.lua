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
require("ui.struct.component.element.dynamic")
require("utils.struct.class")

CWndCursor = createClass({
    eDynam = CDynamicElem:new(),
    pCurMouse
})

function CWndCursor:load_mouse(sCursorName)
    local m_trgpCursorQuads = self.trgpCursorQuads

    self.eDynam:load(0, 0, m_trgpCursorQuads[sCursorName])
    --self.eDynam:instantiate()
    self.eDynam:after_load()
end

function CWndCursor:_refresh_cursor()
    local pCurImg = self.eDynam:update_drawing()
    local pNextCursor = pCurImg:get_img()

    if self.pCurMouse ~= pNextCursor then
        self.pCurMouse = pNextCursor
        love.mouse.setCursor(pNextCursor)
    end
end

function CWndCursor:update(dt)
    self.eDynam:update(dt)
    self:_refresh_cursor()
end

function CWndCursor:draw()
    -- do nothing
end
