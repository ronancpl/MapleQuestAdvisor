--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.dynamic")
require("utils.struct.class")

CWmapElemPointer = createClass({
    eDynam = CDynamicElem:new()
})

function CWmapElemPointer:get_object()
    return self.eDynam
end

function CWmapElemPointer:load(rX, rY, pWmapProp, rgpQuads)
    self.eDynam:load(rX, rY, rgpQuads)
    self.eDynam:instantiate(pWmapProp, true)
    self.eDynam:after_load()
end

function CWmapElemPointer:update(dt)
    self.eDynam:update(dt)
end

function CWmapElemPointer:draw()
    self.eDynam:draw()
end
