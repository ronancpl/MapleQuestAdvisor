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

CStationConnectionTable = createClass({
    tFieldStations = {}
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

function CStationConnectionTable:get_hub_entries()
    return self.tFieldStations
end
