--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.worldmap.layer.background")
require("ui.struct.worldmap.layer.map_link")
require("ui.struct.worldmap.layer.map_list")
require("ui.struct.worldmap.layer.text_box")
require("utils.struct.class")

CWndWmap = createClass({
    pNavBg = CWmapNavBackground:new(),
    pNavMapLink = CWmapNavMapLink:new(),
    pNavMapList = CWmapNavMapList:new(),
    pNavTextbox = CWmapNavTextBox:new()
})

function CWndWmap:load()
    self.pNavBg:load()
    self.pNavMapLink:load()
    self.pNavMapList:load()
    self.pNavTextbox:load()
end

function CWndWmap:update(dt)
    self.pNavBg:update(dt)
    self.pNavMapLink:update(dt)
    self.pNavMapList:update(dt)
    self.pNavTextbox:update(dt)
end

function CWndWmap:draw()
    self.pNavBg:draw()
    self.pNavMapLink:draw()
    self.pNavMapList:draw()
    self.pNavTextbox:draw()
end
