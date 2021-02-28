--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.struct.window.canvas")
require("ui.struct.window.storage")
require("ui.struct.worldmap.properties")
require("ui.struct.worldmap.layer.background")
require("ui.struct.worldmap.layer.map_link")
require("ui.struct.worldmap.layer.map_list")
require("ui.struct.worldmap.layer.text_box")
require("utils.struct.class")

CWndWmap = createClass({
    pCanvas = CWndCanvas:new(),
    pProp = CWmapProperties:new(),
    pCache = CWndStorage:new()
})

function CWndWmap:get_properties()
    return self.pProp
end

function CWndWmap:update_region(sWmapName)
    local pWmapRegion
    local tpWmapImgs
    pWmapRegion, tpWmapImgs = self.pCache:load_region(sWmapName)

    local tpHelperImages
    _, tpHelperImages = self.pCache:get_worldmap_helper()

    self.pProp:update_region(pWmapRegion, tpHelperImages, tpWmapImgs)
    self.pCanvas:build(self.pProp)
end

function CWndWmap:load()
    self.pCanvas:load({CWmapNavBackground, CWmapNavMapLink, CWmapNavMapList, CWmapNavTextBox})
    self.pCache:load()
end

function CWndWmap:update(dt)
    self.pCanvas:update(dt)
end

function CWndWmap:draw()
    self.pCanvas:draw()
end
