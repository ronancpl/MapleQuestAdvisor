--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("utils.struct.class")

CStationTable = createClass({
    trgStations = {}
})

function CStationTable:add_entry(iSrcMapid, iDestRegionid, iDestMapid)
    local m_trgStations = self.trgStations
    local rgpStations = m_trgStations[iDestRegionid]

    if rgpStations == nil then
        rgpStations = {}
        m_trgStations[iDestRegionid] = rgpStations
    end

    local pStation = {iSrcMapid, iDestMapid}
    table.insert(rgpStations, pStation)
end

function CStationTable:get_stations(iDestRegionid)
    local m_trgStations = self.trgStations
    local rgpStations = m_trgStations[iDestRegionid]

    return rgpStations
end
