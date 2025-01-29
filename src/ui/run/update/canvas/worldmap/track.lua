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
require("solver.lookup.constant")
require("ui.constant.view.worldmap")
require("ui.struct.component.tooltip.tracer.polyline")
require("ui.struct.window.summary")
require("utils.procedure.unpack")

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

local function is_player_region_in_worldmap_area(pPlayer, pUiWmap)
    local rgiWmapRegionids = get_worldmap_regionids(pUiWmap)

    local iRegionid = ctFieldsLandscape:get_region_by_mapid(pPlayer:get_mapid())
    for _, iWmapRegionid in ipairs(rgiWmapRegionids) do
        if iRegionid == iWmapRegionid then
            return true
        end
    end

    return false
end

local function reset_worldmap_nodes(pUiWmap, pDirHelperQuads)
    local pWmapProp = pUiWmap:get_properties()

    local tpMarkers = pWmapProp:get_markers()
    for _, pFieldMarker in pairs(tpMarkers) do
        pFieldMarker:set_static(RWmapMarkerState.DEFAULT)
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

local function contains_field_npc(pResource)
    for _, iRscid in pairs(pResource:get_resources()) do
        local iRscType = math.floor(iRscid / 1000000000)
        if iRscType == RLookupCategory.FIELD_NPC then
            return true
        end
    end

    return false
end

local function has_quest_npc(pRegionRscTree, iMapid)
    local pFieldRsc = pRegionRscTree:get_field_node(iMapid)
    return pFieldRsc ~= nil and contains_field_npc(pFieldRsc)
end

local function update_worldmap_resource_nodes(pUiWmap, pRegionRscTree, pPlayer, pDirHelperQuads)
    local rgiWmapRegionids = get_worldmap_regionids(pUiWmap)
    local bBaseWmap = (pUiWmap:get_properties():get_worldmap_name() == S_WORLDMAP_BASE)

    -- verify if current worldmap contains the player and destination
    local iOrigMapid = pRegionRscTree:get_field_source()
    local iDestMapid = pRegionRscTree:get_field_destination()

    local iRegionidOrig = ctFieldsLandscape:get_region_by_mapid(iOrigMapid) or -1
    local iRegionidDest = ctFieldsLandscape:get_region_by_mapid(iDestMapid) or -1

    local iRegionidPlayer = ctFieldsLandscape:get_region_by_mapid(pPlayer:get_mapid())

    -- setup tooltips for player, destination & stations present
    local bStaticSrc = nil
    local sTooltipSrc = nil
    if is_worldmap_subregion(iRegionidOrig, rgiWmapRegionids) then
        if iRegionidOrig == iRegionidPlayer then
            sTooltipSrc = RWmapTooltipType.PLAYER
            bStaticSrc = (iRegionidPlayer == iRegionidOrig or iRegionidDest == -1 or bBaseWmap) and RWmapMarkerState.PLAYER or RWmapMarkerState.STATION_IN
        else
            bStaticSrc = RWmapMarkerState.STATION_IN
        end
    end

    local bStaticDest = nil
    local sTooltipDest = nil
    if is_worldmap_subregion(iRegionidDest, rgiWmapRegionids) then
        if has_quest_npc(pRegionRscTree, iDestMapid) then   -- current region has NPC
            sTooltipDest = RWmapTooltipType.TARGET
            bStaticDest = ((iRegionidOrig == iRegionidDest and bStaticSrc ~= RWmapMarkerState.STATION_IN) or iRegionidDest == -1 or bBaseWmap) and RWmapMarkerState.TARGET or RWmapMarkerState.STATION_OUT
        elseif iRegionidOrig ~= iRegionidDest then
            bStaticDest = RWmapMarkerState.STATION_OUT
        end
    end

    -- apply prepared tooltips for the nodes present on this worldmap

    local pWmapProp = pUiWmap:get_properties()

    local iRegOrigMapid = ctFieldsMeta:get_field_overworld(pRegionRscTree:get_field_source())

    local pFieldMarkerOrig = pWmapProp:get_marker_by_mapid(iRegOrigMapid)
    if pFieldMarkerOrig ~= nil then
        pFieldMarkerOrig:set_static(false)
        if bStaticSrc ~= nil then
            pFieldMarkerOrig:set_static(bStaticSrc)
        end

        if sTooltipSrc ~= nil then
            pFieldMarkerOrig:set_tooltip(sTooltipSrc, pDirHelperQuads, pWmapProp)
        end
    end

    local iRegDestMapid = ctFieldsMeta:get_field_overworld(pRegionRscTree:get_field_destination())
    local pFieldMarkerDest = pWmapProp:get_marker_by_mapid(iRegDestMapid)
    if pFieldMarkerDest ~= nil then
        pFieldMarkerDest:set_static(false)
        if bStaticDest ~= nil then
            pFieldMarkerDest:set_static(bStaticDest)
        end

        if sTooltipDest ~= nil then
            pFieldMarkerDest:set_tooltip(sTooltipDest, pDirHelperQuads, pWmapProp)
        end
    end
end

local function create_waypoint_trace(pUiWmap, pPlayer, pRegionRscTree)
    local pWmapProp = pUiWmap:get_properties()

    local iRegOrigMapid = pRegionRscTree:get_field_source()

    local pFieldMarkerOrig = pWmapProp:get_marker_by_mapid(iRegOrigMapid)

    local iRegDestMapid = pRegionRscTree:get_field_destination()
    local pFieldMarkerDest = pWmapProp:get_marker_by_mapid(iRegDestMapid)

    local pVwTrace
    if pFieldMarkerOrig ~= nil and pFieldMarkerDest ~= nil and pPlayer:get_mapid() == iRegOrigMapid then
        local x1, y1 = pFieldMarkerOrig:get_object():get_center()
        local x2, y2 = pFieldMarkerDest:get_object():get_center()

        local rgpQuadBullet = ctVwTracer:get_bullet()

        pVwTrace = CViewPolyline:new()
        pVwTrace:load(rgpQuadBullet, {x1, y1, x2, y2})
        pVwTrace:active()
    else
        pVwTrace = nil
    end

    return pVwTrace
end

local function is_field_station(iMapid)
    return ctFieldsLink:get_hub_entry(iMapid) ~= nil
end

local function is_region_in_worldmap(iRegionid, pUiWmap)
    local rgiRegionids = get_worldmap_regionids(pUiWmap)
    for _, iWmapRegionid in ipairs(rgiRegionids) do
        if iRegionid == iWmapRegionid then
            return true
        end
    end

    return false
end

local function fetch_source_resource_tree(iPlayerMapid, pUiWmap)
    local iRegionid = ctFieldsLandscape:get_region_by_mapid(iPlayerMapid)
    return is_region_in_worldmap(iRegionid, pUiWmap) and iPlayerMapid or -1
end

local function fetch_destination_resource_tree(tiMapidDest, iMapidSrc, iMapidDest)
    local iRegionid = ctFieldsLandscape:get_region_by_mapid(iMapidDest)
    if is_region_in_worldmap(iRegionid, pUiWmap) then
        return iMapidDest
    end

    iRegionid = ctFieldsLandscape:get_region_by_mapid(iMapidSrc)
    if is_region_in_worldmap(iRegionid, pUiWmap) then
        local iWmapMapidDest = tiMapidDest[iRegionid]
        if iWmapMapidDest == nil then
            _, iWmapMapidDest = next(tiMapidDest)
        end

        return iWmapMapidDest or -1
    end

    return -1
end

local function build_worldmap_resource_tree(pRscTree, pUiWmap, iPlayerMapid)
    local pWmapRscTree = CSolverTree:new()

    local iMapidSrc = -1
    local tiMapidDest = {}

    local rgiRegionids = get_worldmap_regionids(pUiWmap)
    for _, iWmapRegionid in ipairs(rgiRegionids) do
        local pRegionRscTree = pRscTree:get_field_node(iWmapRegionid)
        if pRegionRscTree ~= nil then
            for iMapid, pRsc in pairs(pRegionRscTree:get_field_nodes()) do
                pWmapRscTree:add_field_node(iMapid, pRsc)
            end

            local iCurMapidSrc = pRegionRscTree:get_field_source()
            if is_field_station(iCurMapidSrc) then
                iMapidSrc = iCurMapidSrc
            end

            local iCurMapidDest = pRegionRscTree:get_field_destination()
            if is_field_station(iCurMapidDest) or tiMapidDest[iWmapRegionid] == nil then
                tiMapidDest[iWmapRegionid] = iCurMapidDest
            end
        end
    end

    local iWmapSrc = fetch_source_resource_tree(iPlayerMapid, pUiWmap, iMapidSrc)
    iMapidSrc = iWmapSrc > -1 and iWmapSrc or iMapidSrc

    local iMapidDest = fetch_destination_resource_tree(tiMapidDest, iMapidSrc, pRscTree:get_field_destination())
    pWmapRscTree:set_field_source(iMapidSrc > -1 and iMapidSrc or pWmapRscTree:get_field_source())
    pWmapRscTree:set_field_destination(iMapidDest > -1 and iMapidDest or pWmapRscTree:get_field_destination())

    return pWmapRscTree
end

function clear_worldmap_region_track(pUiWmap)
    local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)
    pLyr:reset_elements(LChannel.WMAP_MARK_TRACE)
end

function update_worldmap_region_track(pUiWmap, pUiRscs, pPlayer, pDirHelperQuads)
    clear_worldmap_region_track(pUiWmap)
    reset_worldmap_nodes(pUiWmap, pDirHelperQuads)

    local pRscTree = pUiRscs:get_properties():get_resource_tree()
    local pWmapRegionRscTree = build_worldmap_resource_tree(pRscTree, pUiWmap, pPlayer:get_mapid())
    update_worldmap_resource_nodes(pUiWmap, pWmapRegionRscTree, pPlayer, pDirHelperQuads)

    local pLyr = pUiWmap:get_layer(LLayer.NAV_WMAP_MISC)

    --local pElemTrace = create_waypoint_trace(pUiWmap, pPlayer, pWmapRegionRscTree)
    local pElemTrace = nil
    if pElemTrace ~= nil then
        pLyr:add_element(LChannel.WMAP_MARK_TRACE, pElemTrace)
    end
end

local function reset_worldmap_resource_actives(pUiWmap)
    local pWmapProp = pUiWmap:get_properties()

    local tpMarkers = pWmapProp:get_markers()
    for _, pFieldMarker in pairs(tpMarkers) do
        pFieldMarker:static()
    end
end

local function apply_worldmap_resource_actives(pUiWmap, pUiRscs)
    local pWmapProp = pUiWmap:get_properties()

    local pRscTree = pUiRscs:get_properties():get_resource_tree()
    local pWmapRscTree = build_worldmap_resource_tree(pRscTree, pUiWmap, pPlayer:get_mapid())

    for iMapid, _ in pairs(pWmapRscTree:get_field_nodes()) do
        local pFieldMarker = pWmapProp:get_marker_by_mapid(iMapid)
        if pFieldMarker ~= nil then
            pFieldMarker:active()
        end
    end
end

function update_worldmap_resource_actives(pUiWmap, pUiRscs)
    reset_worldmap_resource_actives(pUiWmap)
    apply_worldmap_resource_actives(pUiWmap, pUiRscs)
end

local function apply_selected_worldmap_resource_active(pUiWmap, pRscTree, pVwRsc)
    local pWmapProp = pUiWmap:get_properties()

    local sWmapName = pWmapProp:get_worldmap_name()
    local pWmapRegion = ctFieldsWmap:get_region_entry(sWmapName)

    local tRegions = {}
    for _, iMapid in ipairs(pWmapRegion:get_areas()) do
        local iRegionid = ctFieldsLandscape:get_region_by_mapid(iMapid)
        if iRegionid ~= nil then
            tRegions[iRegionid] = 1
        end
    end

    local iRscid = pVwRsc:get_resource_id()
    for iRegionid, _ in pairs(tRegions) do
        local pRscRegion = pRscTree:get_field_node(iRegionid)
        if pRscRegion ~= nil then
            local rgiMapids = pRscRegion:get_fields_from_resource(iRscid)
            for _, iMapid in ipairs(rgiMapids) do
                local pFieldMarker = pWmapProp:get_marker_by_mapid(iMapid)
                pFieldMarker:active()
            end
        end
    end
end

function select_worldmap_resource_active(pUiWmap, pRscTree, pVwRsc)
    reset_worldmap_resource_actives(pUiWmap)
    apply_selected_worldmap_resource_active(pUiWmap, pRscTree, pVwRsc)
end
