--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.resource")
require("ui.struct.component.canvas.resource.item.item")
require("ui.struct.component.element.rect")
require("utils.struct.class")

CCanvasRscLink = createClass({CCanvasRscItem, {
    eBox = CUserboxElem:new()
}})

function CCanvasRscLink:get_object()
    return self.eBox
end

function CCanvasRscLink:load(sDesc, iFieldRef)
    self.eBox:load()
    self:_load_image(iId)

    self.sDesc = sDesc
    self.iFieldRef = iFieldRef
end

function CCanvasRscLink:update(iPx, iPy)
    self.eBox:load(iPx, iPy, RResourceTable.VW_FIELD.W, RResourceTable.VW_FIELD.H)
end

function CCanvasRscLink:draw()
    draw_resource_link(self)
end
