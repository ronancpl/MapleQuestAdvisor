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
require("ui.struct.window.summary")
require("ui.struct.window.frame.canvas")
require("ui.struct.canvas.worldmap.storage")
require("ui.struct.canvas.worldmap.layer.background")
require("ui.struct.canvas.worldmap.layer.fragment")
require("ui.struct.canvas.worldmap.layer.map_link")
require("ui.struct.canvas.worldmap.layer.map_list")
require("ui.struct.canvas.worldmap.layer.plaintext")
require("ui.struct.canvas.worldmap.properties")
require("utils.struct.class")

CWndWmap = createClass({
    pCanvas = CWndCanvas:new(),
    pProp = CWmapProperties:new(),
    pCache = CWmapStorage:new()
})

function CWndWmap:get_properties()
    return self.pProp
end

function CWndWmap:update_region(sWmapName)
    self.pCanvas:reset()

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

    self.pCanvas:load({CWmapNavBackground, CWmapNavMapLink, CWmapNavMapList, CWmapNavFragment, CWmapNavInfo}) -- follows sequence: LLayer
    self.pCache:load()
end

function CWndWmap:update(dt)
    self.pCanvas:update(dt)
end

function CWndWmap:draw()
    self.pCanvas:draw()
end

function CWndWmap:onmousemoved(x, y, dx, dy, istouch)
    self.pCanvas:onmousemoved(x, y, dx, dy, istouch)
end

function CWndWmap:onmousepressed(x, y, button)
    self.pCanvas:onmousepressed(x, y, button)
end

function CWndWmap:onmousereleased(x, y, button)
    self.pCanvas:onmousereleased(x, y, button)
end

function CWndWmap:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
