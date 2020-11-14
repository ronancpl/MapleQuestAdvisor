--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("router.procedures.world.path.distance")
require("router.procedures.world.path.table")
require("utils.procedure.constants")
require("utils.procedure.iterate")
require("utils.struct.queue")

local function get_region_by_mapid(tiFieldRegion, iMapid)
    return tiFieldRegion[iMapid]
end

local function pathfind_interregional_entryset(tWorldNodes, iSrcRegionid, iDestRegionid)
    local pQueueFrontierNodeids = SQueue:new()
    local tiVisitedNodeid = {}

    pQueueFrontierNodeids:push(iSrcRegionid)
    tiVisitedNodeid[iSrcRegionid] = -1

    local tiPathedFrom = {}
    local iCurPath = nil
    while true do
        local iRegionid = pQueueFrontierNodeids:poll()
        if iRegionid == nil then
            break
        end

        for iLinkedRegionid, _ in pairs(tWorldNodes[iRegionid]) do
            if tiVisitedNodeid[iLinkedRegionid] == nil then         -- first visited is shortest path
                pQueueFrontierNodeids:push(iLinkedRegionid)
                tiVisitedNodeid[iLinkedRegionid] = iRegionid
            end
        end
    end

    local rgiRevVisitedRegions = {}
    local iRegionid = iDestRegionid
    while tiVisitedNodeid[iRegionid] ~= -1 do
        table.insert(rgiRevVisitedRegions, iRegionid)
        iRegionid = tiVisitedNodeid[iRegionid]
    end

    return rpairs(rgiRevVisitedRegions)
end

local function get_interregional_path(tWorldNodes, tiFieldRegion, iSrcMapid, iDestMapid)
    local iSrcRegionid = get_region_by_mapid(tiFieldRegion, iSrcMapid)
    local iDestRegionid = get_region_by_mapid(tiFieldRegion, iDestMapid)

    local rgiTransitRegionids = {}

    for _, iRegionid in pathfind_interregional_entryset(tWorldNodes, iSrcRegionid, iDestRegionid) do
        table.insert(rgiTransitRegionids, iRegionid)
    end

    return rgiTransitRegionids
end

local function fetch_nearby_region_station(ctFieldsDist, ctFieldsLink, tiFieldRegion, iSrcMapid, iDestRegionid)
    local iStationDist = U_INT_MAX
    local iStationMapid = nil
    local iNextMapid = nil

    local rgpMapLinks = ctFieldsLink:get_stations_to_region(tiFieldRegion, iSrcMapid, iDestRegionid)
    for _, pStationMapLink in ipairs(rgpMapLinks) do
        local iCurStationMapid
        local iCurNextMapid
        iCurStationMapid, iCurNextMapid = pStationMapLink

        local iDist = ctFieldsDist:get_field_distance(iSrcMapid, iCurStationMapid)
        if iDist < iStationDist then
            iStationDist = iDist

            iStationMapid = iCurStationMapid
            iNextMapid = iCurNextMapid
        end
    end

    return iStationMapid, iNextMapid, iStationDist
end

local function calc_interregional_distance(ctFieldsDist, ctFieldsLink, tiFieldRegion, tWorldNodes, iSrcMapid, iDestMapid)
    local rgpTransitRegionids = get_interregional_path(tWorldNodes, tiFieldRegion, iSrcMapid, iDestMapid)

    local iTransitDist = 0
    local iCurMapid = iSrcMapid
    for _, iNextRegionid in ipairs(rgpTransitRegionids) do
        local iStationMapid     -- prioritizes going to nearest station
        local iNextMapid
        local iDist
        iStationMapid, iNextMapid, iDist = fetch_nearby_region_station(ctFieldsDist, ctFieldsLink, tiFieldRegion, iCurMapid, iNextRegionid)

        iTransitDist = iTransitDist + iDist + 1
        iCurMapid = iNextMapid
    end

    iTransitDist = iTransitDist + ctFieldsDist:get_field_distance(iCurMapid, iDestMapid)
    return iTransitDist
end

function fetch_interregional_town_distances(ctFieldsDist, ctFieldsMeta, ctFieldsLink, tiFieldRegion, tWorldNodes)
    local rgiTowns = ctFieldsMeta:get_towns()
    for _, iTownA in ipairs(rgiTowns) do
        for _, iTownB in ipairs(rgiTowns) do
            local iDistance = calc_interregional_distance(ctFieldsDist, ctFieldsLink, tiFieldRegion, tWorldNodes, iTownA, iTownB)
            ctFieldsDist:add_field_distance(iTownA, iTownB, iDistance)
        end
    end
end
