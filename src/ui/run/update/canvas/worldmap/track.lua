--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.constant")
require("solver.graph.tree.component")
require("ui.constant.view.worldmap")
require("ui.struct.component.tooltip.tracer.polyline")
require("ui.struct.window.summary")
require("utils.procedure.unpack")

local function fetch_field_destination(pRegionRscTree)
    for iMapid, pResource in pairs(pRegionRscTree:get_field_nodes()) do
        for _, iRscid in ipairs(pResource:get_resources()) do
            local iRscType = math.floor(iRscid / 1000000000)
            if iRscType == RLookupCategory.FIELD_NPC then
                return iMapid
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

local function is_worldmap_subregion(iRegionid, rgiWmapRegionids)
    for _, iWmapRegionid in ipairs(rgiWmapRegionids) do
        if iWmapRegionid == iRegionid then
            return true
        end
    end

    return false
end

local function get_worldmap_regionids(pUiWmap)
    local tpRegionids = {}

    for _, iMapid in ipairs(pUiWmap:get_properties():get_fields()) do
        local iWmapRegionid = ctFieldsLandscape:get_region_by_mapid(iMapid)
        if iWmapRegionid ~= nil then
            tpRegionids[iWmapRegionid] = 1
        end
    end

    return keys(tpRegionids)
end

local function update_worldmap_resource_nodes(pUiWmap, pRegionRscTree, pPlayer, pDirHelperQuads)
    local rgiWmapRegionids = get_worldmap_regionids(pUiWmap)

    -- verify if current worldmap contains the player and destination

    local iOrigMapid = pPlayer:get_mapid()
    local iDestMapid = fetch_field_destination(pRegionRscTree)

    local iRegionidOrig = ctFieldsLandscape:get_region_by_mapid(iOrigMapid) or -1
    local iRegionidDest = ctFieldsLandscape:get_region_by_mapid(iDestMapid) or -1

    -- setup tooltips for player, destination & stations present

    local iTypeSrc = nil
    local sTooltipSrc = nil
    if is_worldmap_subregion(iRegionidOrig, rgiWmapRegionids) then
        iTypeSrc = RWmapMarkerType.STATION_OUT
        sTooltipSrc = RWmapTooltipType.TARGET
    end

    local iTypeDest = nil
    local sTooltipDest = nil
    if is_worldmap_subregion(iRegionidDest, rgiWmapRegionids) then
        iTypeDest = RWmapMarkerType.STATION_IN
        sTooltipDest = RWmapTooltipType.PLAYER
    end

    local pWmapProp = pUiWmap:get_properties()

    local iRegOrigMapid = ctFieldsMeta:get_field_overworld(pRegionRscTree:get_field_source())
    local pFieldMarkerOrig = pWmapProp:get_marker_by_mapid(iRegOrigMapid)

    if iTypeSrc ~= nil then
        pFieldMarkerOrig:set_type(iTypeSrc)
    end

    if sTooltipSrc ~= nil then
        pFieldMarkerOrig:set_tooltip(sTooltipSrc, pDirHelperQuads, pWmapProp)
    end

    local iRegDestMapid = ctFieldsMeta:get_field_overworld(pRegionRscTree:get_field_destination())
    local pFieldMarkerDest = pWmapProp:get_marker_by_mapid(iRegDestMapid)

    if iTypeDest ~= nil then
        pFieldMarkerDest:set_type(iTypeDest)
    end

    if sTooltipDest ~= nil then
        pFieldMarkerDest:set_tooltip(sTooltipDest, pDirHelperQuads, pWmapProp)
    end
end

local function create_waypoint_trace(pUiWmap, pRegionRscTree)
    local pWmapProp = pUiWmap:get_properties()

    local iRegOrigMapid = pRegionRscTree:get_field_source()

    local pFieldMarkerOrig = pWmapProp:get_marker_by_mapid(iRegOrigMapid)

    local iRegDestMapid = pRegionRscTree:get_field_destination()
    local pFieldMarkerDest = pWmapProp:get_marker_by_mapid(iRegDestMapid)

    local x1, y1, _, _ = pFieldMarkerOrig:get_object():get_ltrb()
    local x2, y2, _, _ = pFieldMarkerDest:get_object():get_ltrb()

    local rgpQuadBullet = ctVwTracer:get_bullet()

    local pVwTrace = CViewPolyline:new()
    pVwTrace:load(rgpQuadBullet, {x1, x2, y1, y2})
    pVwTrace:active()

    return pVwTrace
end

local function is_field_station(iMapid)
    return ctFieldsLink:get_hub_entry(iMapid) ~= nil
end

local function build_worldmap_resource_tree(pRscTree, pUiWmap)
    local pWmapRscTree = CSolverTree:new()

    local iMapidSrc = U_INT_MAX
    local iMapidDest = U_INT_MAX

    local rgiRegionids = get_worldmap_regionids(pUiWmap)
    for _, iWmapRegionid in ipairs(rgiRegionids) do
        local pRegionRscTree = pRscTree:get_field_node(iWmapRegionid)
        if pRegionRscTree ~= nil then
            for iMapid, pRsc in pairs(pRegionRscTree:get_field_nodes()) do
                pWmapRscTree:add_field_node(iMapid, pRsc)
            end

            local iCurMapidSrc = pRegionRscTree:get_field_source()
            if is_field_station(iCurMapidSrc) or iMapidSrc == U_INT_MAX then
                iMapidSrc = iCurMapidSrc
            end

            local iCurMapidDest = pRegionRscTree:get_field_destination()
            if is_field_station(iCurMapidDest) or iMapidDest == U_INT_MAX then
                iMapidDest = iCurMapidDest
            end
        end
    end

    pWmapRscTree:set_field_source(iMapidSrc)
    pWmapRscTree:set_field_destination(iMapidDest)

    return pWmapRscTree
end

function update_worldmap_region_track(pUiWmap, pUiRscs, pPlayer, pDirHelperQuads)
    reset_worldmap_nodes(pUiWmap)

    local pRscTree = pUiRscs:get_properties():get_resource_tree()
    local pWmapRscTree = build_worldmap_resource_tree(pRscTree, pUiWmap)

    update_worldmap_resource_nodes(pUiWmap, pWmapRscTree, pPlayer, pDirHelperQuads)

    local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_TRACE)
    pLyr:set_trace(create_waypoint_trace(pUiWmap, pWmapRscTree))
end

function update_worldmap_resource_actives(pUiWmap, pUiRscs)
    local pWmapProp = pUiWmap:get_properties()

    local rgpFieldMarkers = pWmapProp:get_markers()
    for _, pFieldMarker in ipairs(rgpFieldMarkers) do
        pFieldMarker:static()
    end

    local pRscTree = pUiRscs:get_properties():get_resource_tree()
    local pWmapRscTree = build_worldmap_resource_tree(pRscTree, pUiWmap)

    for iMapid, _ in ipairs(pWmapRscTree:get_field_nodes()) do
        local pFieldMarker = pWmapProp:get_marker_by_mapid(iMapid)
        pFieldMarker:active()
    end
end
