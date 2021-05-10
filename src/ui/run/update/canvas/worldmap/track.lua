--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.worldmap")
require("ui.struct.component.tooltip.tracer.polyline")

local function fetch_region_fields(pRscTree, iWmapRegionid)
    local pRegionRscTree = pRscTree:get_field_node(iWmapRegionid)

    local rgiMapids = {}
    for iMapid, _ in pairs(pRegionRscTree:get_field_nodes()) do
        local iWmapid = ctFieldsMeta:get_worldmapid_by_area(iMapid)
        if iWmapid == iWmapRegionid then
            table.insert(rgiMapids, iMapid)
        end
    end

    return rgiMapids
end

local function fetch_field_destination(pRscTree)
    for iRegionid, pRegionRscTree in pairs(pRscTree:get_field_nodes()) do
        for iMapid, pResource in pairs(pRegionRscTree:get_field_nodes()) do
            for _, iRscid in ipairs(pResource:get_resources()) do
                local iRscType = math.floor(iRscid / 1000000000)
                if iRscType == RLookupCategory.FIELD_NPC then
                    return iMapid
                end
            end
        end
    end

    return nil
end

local function reset_worldmap_nodes(pUiWmap)
    local pWmapProp = pUiWmap:get_properties()

    local tpMarkers = pWmapProp:get_markers()
    for _, pFieldMarker in pairs(tpMarkers) do
        pFieldMarker:set_type(RWmapMarkerType.DEFAULT)
        pFieldMarker:set_tooltip(nil)
    end
end

local function update_worldmap_resource_nodes(pUiWmap, pUiRscs, iWmapRegionid, pPlayer)
    local pRscTree = pUiRscs:get_properties():get_resource_tree()
    local pRegionRscTree = pRscTree:get_field_node(iWmapRegionid)

    local iOrigMapid = pPlayer:get_mapid()
    local iDestMapid = fetch_field_destination(pRscTree)

    local iRegionidOrig = pLandscape:get_region_by_mapid(iOrigMapid)
    local iRegionidDest = pLandscape:get_region_by_mapid(iDestMapid)

    local iTypeSrc, sTooltipSrc
    if iWmapRegionid == iRegionidDest then
        iTypeSrc = RWmapMarkerType.DEFAULT
        sTooltipSrc = RWmapMarkerType.TARGET
    end

    local iTypeDest, sTooltipDest
    if iWmapRegionid == iRegionidDest then
        iTypeDest = RWmapMarkerType.STATION_IN
        sTooltipDest = RWmapMarkerType.STATION_OUT
    end

    local pWmapProp = pUiWmap:get_properties()

    local iRegOrigMapid = pRscTree:get_field_origin()
    local pFieldMarkerOrig = pWmapProp:get_marker_by_mapid(iRegOrigMapid)
    pFieldMarkerOrig:set_type(iTypeSrc)
    pFieldMarkerOrig:set_tooltip(sTooltipSrc)

    local iRegDestMapid = pRscTree:get_field_destination()
    local pFieldMarkerDest = pWmapProp:get_marker_by_mapid(iRegDestMapid)
    pFieldMarkerDest:set_type(iTypeDest)
    pFieldMarkerDest:set_tooltip(sTooltipDest)
end

local function create_waypoint_trace(pUiWmap, pUiRscs)
    local pVwTrace = CViewPolyline:new()

    local pWmapProp = pUiWmap:get_properties()

    local pRscTree = pUiRscs:get_properties():get_resource_tree()

    local iRegOrigMapid = pRscTree:get_field_origin()
    local pFieldMarkerOrig = pWmapProp:get_marker_by_mapid(iRegOrigMapid)

    local iRegDestMapid = pRscTree:get_field_destination()
    local pFieldMarkerDest = pWmapProp:get_marker_by_mapid(iRegDestMapid)

    local x1, y1 = pFieldMarkerOrig:get_spot()
    local x2, y2 = pFieldMarkerDest:get_spot()

    local rgpQuadBullet = ctVwTracer:get_bullet()
    pVwTrace:load(rgpQuadBullet, {x1, x2, y1, y2})
    pVwTrace:active()

    self.pVwTrace = pVwTrace
end

function update_worldmap_region_track(pUiWmap, pUiRscs, pPlayer)
    local pRscTree = pUiRscs:get_properties()
    local iWmapRegionid = pLandscape:get_region_by_mapid(pUiWmap:get_properties():get_fields()[1])

    reset_worldmap_nodes(pUiWmap)
    update_worldmap_resource_nodes(pUiWmap, pUiRscs, iWmapRegionid, pPlayer)
    create_waypoint_trace(pUiWmap, pUiRscs)
end

function update_worldmap_resource_actives(pUiWmap, pUiRscs)
    local pWmapProp = pUiWmap:get_properties()

    local rgpFieldMarkers = pWmapProp:get_markers()
    for _, pFieldMarker in ipairs(rgpFieldMarkers) do
        pFieldMarker:static()
    end

    local pRscTree = pUiRscs:get_resource_tree()
    local iRegionid = pLandscape:get_region_by_mapid(pWmapProp:get_fields()[1])

    local rgiMapids = fetch_region_fields(pRscTree, iRegionid)
    for _, iMapid in ipairs(rgiMapids) do
        local pFieldMarker = pWmapProp:get_marker_by_mapid(iMapid)
        pFieldMarker:active()
    end
end
