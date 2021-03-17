--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.config")
require("ui.struct.window.frame.canvas")
require("ui.struct.window.element.storage")
require("ui.struct.worldmap.properties")
require("ui.struct.worldmap.layer.background")
require("ui.struct.worldmap.layer.fragment")
require("ui.struct.worldmap.layer.map_link")
require("ui.struct.worldmap.layer.map_list")
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
    local pDirWmapImgs
    pWmapRegion, pDirWmapImgs = self.pCache:load_region(sWmapName)

    local pDirHelperImgs
    pDirHelperQuads, pDirHelperImgs = self.pCache:get_worldmap_helper()

    self.pProp:update_region(pWmapRegion, pDirHelperImgs, pDirWmapImgs)
    self.pCanvas:build(self.pProp)
end

function CWndWmap:load()
    local iBx
    local iBy
    iBx, iBy = unpack(RWndConfig.WMAP_BGRD_SIZE)
    self.pProp:set_origin(iBx / 2, iBy / 2)

    self.pCanvas:load({CWmapNavBackground, CWmapNavMapLink, CWmapNavMapList, CWmapNavFragment})
    self.pCache:load()
end

function CWndWmap:update(dt)
    self.pCanvas:update(dt)
end

function CWndWmap:draw()
    self.pCanvas:draw()
end
