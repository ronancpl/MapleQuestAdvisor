--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.procedure.unpack")
require("utils.struct.class")

CStationConnectionTable = createClass({
    tFieldStations = {},
    tTravelRegions = {}
})

function CStationConnectionTable:add_hub_entry(iSrcMapid)
    local m_tFieldStations = self.tFieldStations
    m_tFieldStations[iSrcMapid] = {}
end

function CStationConnectionTable:add_hub_link(iSrcMapid, iDestMapid)
    local m_tFieldStations = self.tFieldStations

    local tFieldStation = m_tFieldStations[iSrcMapid]
    table.insert(tFieldStation, iDestMapid)
end

function CStationConnectionTable:get_hub_entry(iSrcMapid)
    return self.tFieldStations[iSrcMapid]
end

function CStationConnectionTable:get_hub_entries()
    return self.tFieldStations
end

function CStationConnectionTable:_create_travel_region_entries(pLandscape)
    local m_tTravelRegions = self.tTravelRegions
    for i = 1, pLandscape:get_region_count(), 1 do
        m_tTravelRegions[i] = {}
    end
end

function CStationConnectionTable:make_index_travel_region(pLandscape)
    self:_create_travel_region_entries(pLandscape)

    local m_tFieldStations = self.tFieldStations
    local m_tTravelRegions = self.tTravelRegions
    for iSrcMapid, rgiDestMapids in pairs(m_tFieldStations) do
        local iSrcRegionid = pLandscape:get_region_by_mapid(iSrcMapid)
        local tDestStationMapids = m_tTravelRegions[iSrcRegionid]

        for _, iDestMapid in ipairs(rgiDestMapids) do
            local iDestRegionid = pLandscape:get_region_by_mapid(iDestMapid)

            local rgpStations = tDestStationMapids[iDestRegionid]
            if rgpStations == nil then
                rgpStations = {}
                tDestStationMapids[iDestRegionid] = rgpStations
            end

            local pSrcMapLink = {iSrcMapid, iDestMapid}
            table.insert(rgpStations, pSrcMapLink)
        end
    end
end

function CStationConnectionTable:determine_regional_station_area_neighbors(pLandscape, ctFieldsDist)
    self:_create_travel_region_entries(pLandscape)

    local m_tFieldStations = self.tFieldStations
    local m_tTravelRegions = self.tTravelRegions
    for iSrcMapid, rgiDestMapids in pairs(m_tFieldStations) do
        local iSrcRegionid = pLandscape:get_region_by_mapid(iSrcMapid)
        local tDestStationMapids = m_tTravelRegions[iSrcRegionid]

        for _, iDestMapid in ipairs(rgiDestMapids) do
            local iDestRegionid = pLandscape:get_region_by_mapid(iDestMapid)

            if iSrcRegionid == iDestRegionid then
                if iSrcRegionid ~= nil then
                    ctFieldsDist:add_field_distance(iSrcMapid, iDestMapid, 1)
                    ctFieldsDist:add_field_distance(iDestMapid, iSrcMapid, 1)
                end
            end
        end
    end
end

function CStationConnectionTable:get_stations_to_region(tiFieldRegion, iSrcMapid, iDestRegionid)
    local m_tTravelRegions = self.tTravelRegions
    local iSrcRegionid = tiFieldRegion[iSrcMapid]

    local tStationsFrom = m_tTravelRegions[iSrcRegionid]
    if tStationsFrom == nil then
        if iSrcRegionid == nil then
            log(LPath.FALLBACK, "stations.txt", "NOT found region from MAPID " .. tostring(iSrcMapid))
        else
            log(LPath.FALLBACK, "stations.txt", "NOT found stations 'FROM' region #" .. tostring(iSrcRegionid))
        end

        tStationsFrom = {}
    end

    local tStationsTo = tStationsFrom[iDestRegionid]
    if tStationsTo == nil then
        log(LPath.FALLBACK, "stations.txt", "NOT found stations 'TO' region #" .. tostring(iDestRegionid))
        tStationsTo = {}
    end

    local rgpSrcStationMapLinks = tStationsTo
    return rgpSrcStationMapLinks
end

function CStationConnectionTable:debug_stations()
    local m_tTravelRegions = self.tTravelRegions

    log(LPath.PROCEDURES, "resources_station.txt", " ---- REGION LINKS ----")
    for iSrcRegionid, tStationsFrom in pairs(m_tTravelRegions) do

        log(LPath.PROCEDURES, "resources_station.txt", "FROM #" .. tostring(iSrcRegionid) .. ":")

        for iDestRegionid, rgpSrcStationMapLinks in pairs(tStationsFrom) do
            local st = ""
            for _, iMapid in ipairs(rgpSrcStationMapLinks) do
                st = st .. tostring(iMapid) .. ","
            end
            log(LPath.PROCEDURES, "resources_station.txt", "    #" .. tostring(iDestRegionid) .. " : [" .. st .. "]")
        end
    end

    log(LPath.PROCEDURES, "resources_station.txt", " ----------------------")
end
