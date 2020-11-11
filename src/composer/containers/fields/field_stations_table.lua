--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]


require("utils.procedure.unpack")
require("utils.struct.class")

CStationDistanceTable = createClass({
    tFieldStations = {}
})

function CStationDistanceTable:add_region_link(iSrcRegionid, iDestRegionid, iSrcMapid, iDestMapid)
    local m_tFieldDistance = self.tFieldDistance

    local pRegionStations = m_tFieldDistance[iSrcRegionid]
    if pRegionStations == nil then
        pRegionStations = CStationTable:new()
        m_tFieldDistance[iSrcRegionid] = pRegionStations
    end

    pRegionStations:add_entry(iSrcMapid, iDestRegionid, iDestMapid)
end
