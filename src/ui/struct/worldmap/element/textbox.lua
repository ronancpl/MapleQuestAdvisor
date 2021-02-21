--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.component.element.static")
require("utils.struct.class")

CWmapElemTextBox = createClass({
    eConst = CStaticElem:new(),
    sTitle,
    sDesc
})

function CWmapElemTextBox:set_title(sTitle)
    self.sTitle = sTitle
end

function CWmapElemTextBox:set_desc(sDesc)
    self.sDesc = sDesc
end

function CWmapElemTextBox:load(pImg, iOx, iOy, iZ, rX, rY)
    self.eDynam:load(pImg, iOx, iOy, iZ, rX, rY)
end

function CWmapElemTextBox:update(dt)
    self.eDynam:update(dt)
end

function CWmapElemTextBox:draw()
    self.eDynam:draw()
end
