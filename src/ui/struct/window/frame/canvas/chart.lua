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
require("ui.run.update.canvas.worldmap.track")
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

local function is_marker_active(pPropMarker, rgiMapids)
    for _, iMapid in ipairs(rgiMapids) do
        if pPropMarker:contains(iMapid) then
            return true
        end
    end

    return false
end

local function activate_region_fields(pUiWmap, pUiRscs)
    -- activation based on having resources

    local rgpPropMarkers = pUiWmap:get_properties():get_map_fields()
    local rgiMapids = pUiRscs:get_properties():get_fields()

    for _, pPropMarker in ipairs(rgpPropMarkers) do
        pPropMarker:static()
    end

    for _, pPropMarker in ipairs(rgpPropMarkers) do
        if is_marker_active(pPropMarker, rgiMapids) then
            pPropMarker:active()
        end
    end
end

function CWndWmap:update_region(sWmapName, pPlayer, pUiRscs)
    self.pCanvas:reset()

    local pWmapRegion
    local pDirWmapImgs
    pWmapRegion, pDirWmapImgs = self.pCache:load_region(sWmapName)

    local pDirHelperQuads
    pDirHelperQuads, _ = self.pCache:get_worldmap_helper()

    local iWmapid = ctFieldsWmap:get_worldmap_id(sWmapName)
    self.pProp:set_worldmap_id(iWmapid)

    self.pProp:update_region(pWmapRegion, pDirHelperQuads, pDirWmapImgs, pUiRscs)

    if pPlayer ~= nil then
        update_worldmap_region_track(self, pUiRscs, pPlayer, pDirHelperQuads)
        update_worldmap_resource_actives(self, pUiRscs)
    end

    activate_region_fields(self, pUiRscs)

    self.pCanvas:build(self.pProp)
end

function CWndWmap:load()
    self.pProp:reset()

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
