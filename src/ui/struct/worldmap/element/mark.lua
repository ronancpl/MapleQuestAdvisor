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

CWmapElemMark = createClass({
    eDynam = CDynamicElem:new(),
    rgiFields,
    pPath,
    pTextbox
})

function CWmapElemMark:set_mapno(rgiFields)
    self.rgiFields = rgiFields
end

function CWmapElemMark:get_path()
    return self.pPath
end

function CWmapElemMark:set_path(pPath)
    self.pPath = pPath
end

function CWmapElemMark:get_textbox()
    return self.pTextbox
end

function CWmapElemMark:set_textbox(pTextbox)
    self.pTextbox = pTextbox
end

function CWmapElemMark:load(rX, rY, rgpQuads)
    self.eDynam:load(rX, rY, rgpQuads)
end

function CWmapElemMark:update(dt)
    self.eDynam:update(dt)
end

function CWmapElemMark:draw()
    self.eDynam:draw()
end
