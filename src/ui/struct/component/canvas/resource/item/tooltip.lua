--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.draw.canvas.resource.resource")
require("ui.struct.component.canvas.style.text_box")
require("utils.struct.class")

CCanvasTooltip = createClass({
    pTextbox = CStyleBoxText:new()
})

function CCanvasTooltip:load(sDesc)
    local m_pTextbox = self.pTextbox
    m_pTextbox:load("", sDesc, 0, 0, nil)
end

function CCanvasTooltip:get_textbox()
    return self.pTextbox
end

function CCanvasTooltip:draw()
    draw_resource_tooltip(self)
end
