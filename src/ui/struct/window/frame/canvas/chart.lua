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
require("ui.run.update.canvas.position")
require("ui.run.update.canvas.worldmap.track")
require("ui.struct.component.canvas.canvas")
require("ui.struct.window.summary")
require("ui.struct.window.type")
require("ui.struct.window.frame.canvas")
require("ui.struct.canvas.worldmap.storage")
require("ui.struct.canvas.worldmap.layer.background")
require("ui.struct.canvas.worldmap.layer.fragment")
require("ui.struct.canvas.worldmap.layer.map_link")
require("ui.struct.canvas.worldmap.layer.map_list")
require("ui.struct.canvas.worldmap.layer.plaintext")
require("ui.struct.canvas.worldmap.properties")
require("utils.struct.class")

CWndWmap = createClass({CWndBase, {
    pCanvas = CWndCanvas:new(),
    pProp = CWmapProperties:new(),
    pCache = CWmapStorage:new(),

    pPlayer = nil
}})

function CWndWmap:get_properties()
    return self.pProp
end

function CWndWmap:get_window_position()
    return self:get_position()
end

function CWndWmap:set_window_position(iRx, iRy)
    self:set_position(iRx, iRy)
end

function CWndWmap:get_player()
    return self.pPlayer
end

function CWndWmap:set_player(pPlayer)
    self.pPlayer = pPlayer
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

function CWndWmap:update_region(sWmapName, pUiRscs, pVwRsc)
    self.pCanvas:reset()

    local pWmapRegion
    local pDirWmapImgs
    pWmapRegion, pDirWmapImgs = self.pCache:load_region(sWmapName)

    local pDirHelperQuads
    pDirHelperQuads, _ = self.pCache:get_worldmap_helper()

    self.pProp:set_worldmap_name(sWmapName)

    self.pProp:update_region(pWmapRegion, pDirHelperQuads, pDirWmapImgs, pUiRscs)

    local pPlayer = self:get_player()
    if pPlayer ~= nil then
        update_worldmap_region_track(self, pUiRscs, pPlayer, pDirHelperQuads)
    end

    if pVwRsc ~= nil then
        local pRscTree = pUiRscs:get_properties():get_resource_tree()
        select_worldmap_resource_active(pUiWmap, pRscTree, pVwRsc)
    else
        update_worldmap_resource_actives(self, pUiRscs)
    end

    self.pCanvas:build(self.pProp)
    activate_region_fields(self, pUiRscs)
end

function CWndWmap:set_dimensions(iWidth, iHeight)
    self:_set_window_size(iWidth, iHeight)
end

function CWndWmap:load()
    local iBx
    local iBy
    iBx, iBy = unpack(RWndConfig.WMAP_BGRD_SIZE)

    self:_load(iBx, iBy, RWndBtClose.TYPE1)
    self:get_bt_close():update_state(RButtonState.DISABLED)

    self.pProp:reset()
    self.pProp:set_origin(iBx / 2, iBy / 2)

    self:set_dimensions(iBx, iBy)

    self.pCanvas:load({CWmapNavBackground, CWmapNavMapLink, CWmapNavMapList, CWmapNavFragment, CWmapNavInfo}) -- follows sequence: LLayer
    self.pCache:load()
end

function CWndWmap:update(dt)
    self:_update(dt)
    self.pCanvas:update(dt)
end

function CWndWmap:draw()
    local iRx, iRy = self:get_window_position()

    push_stack_canvas_position(iRx, iRy)
    self.pCanvas:draw()
    pop_stack_canvas_position()

    self:_draw()
end

function CWndWmap:onmousemoved(x, y, dx, dy, istouch)
    self:_onmousemoved(x, y, dx, dy, istouch)

    local iPx, iPy = self:fetch_relative_pos(x, y)
    self.pCanvas:onmousemoved(iPx, iPy, dx, dy, istouch)
end

function CWndWmap:onmousepressed(x, y, button)
    self:_onmousepressed(x, y, button)

    local iPx, iPy = self:fetch_relative_pos(x, y)
    self.pCanvas:onmousepressed(iPx, iPy, button)
end

function CWndWmap:onmousereleased(x, y, button)
    self:_onmousereleased(x, y, button)

    local iPx, iPy = self:fetch_relative_pos(x, y)
    self.pCanvas:onmousereleased(iPx, iPy, button)
end

function CWndWmap:hide_elements()
    self:_hide_elements()
    self.pCanvas:hide_elements()
end

function CWndWmap:get_layer(iLayer)
    return self.pCanvas:get_layer(iLayer)
end
