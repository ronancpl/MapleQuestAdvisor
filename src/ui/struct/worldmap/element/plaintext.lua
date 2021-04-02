--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.basic.base")
require("ui.struct.component.element.plaintext")
require("ui.struct.window.summary")
require("utils.struct.class")

CWmapElemPlaintext = createClass({
    eTxt = CTextElem:new(),
    bVisible = false
})

function CWmapElemPlaintext:get_object()
    return self.eTxt
end

function CWmapElemPlaintext:load(sText, pFont, iLineWidth, iPx, iPy)
    self.eTxt:load(sText, pFont, iLineWidth, iPx, iPy)
end

function CWmapElemPlaintext:reset()
    self.bVisible = false
end

function CWmapElemPlaintext:update(dt)
    -- do nothing
end

function CWmapElemPlaintext:draw()
    if self.bVisible then
        self.eTxt:draw()
    end
end

function CWmapElemPlaintext:visible()
    self.bVisible = true
end

function CWmapElemPlaintext:hidden()
    self.bVisible = false
end
