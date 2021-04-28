--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.constants.path")
require("ui.struct.component.basic.base")
require("ui.struct.component.canvas.resource.item.tooltip")
require("ui.run.draw.canvas.resource.resource")
require("utils.struct.class")

CCanvasResource = createClass({
    eElem = CBasicElem:new(),
    pTooltip = CCanvasTooltip:new()
})

function CCanvasResource:_update_position(iRx, iRy)
    self.eElem:load(iRx, iRy)
end

function CCanvasResource:get_position()
    return self.eElem:get_pos()
end

function CCanvasResource:_load_tooltip(sDesc)
    local m_pTooltip = self.pTooltip
    m_pTooltip:load(sDesc)
end

function CCanvasResource:_load(sDesc)
    self:_load_tooltip(sDesc)
    self.eElem:load(-1, -1)
end

function CCanvasResource:draw_tooltip()
    draw_resource_tooltip(self)
end
