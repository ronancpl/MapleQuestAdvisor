--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.fields.field_station_table")
require("utils.provider.xml.provider")

local function read_station_links(ctStationsDist, pMapStationsNode)
    local pStationsImgNode = pMapStationsNode:get_child_by_name("MapStations.img")

    for _, pStationNode in pairs(pStationsImgNode:get_children()) do
        local iMapid = pStationNode:get_name_tonumber()
        ctStationsDist:add_hub_entry(iMapid)

        for _, pStationNeighborNode in pairs(pStationNode:get_children()) do
            local iToMapid = pStationNeighborNode:get_value()

            if iMapid ~= iToMapid then
                ctStationsDist:add_hub_link(iMapid, iToMapid)
            end
        end
    end
end

local function init_field_external_links(pMapStationsNode)
    local ctStationsDist = CStationConnectionTable:new()
    read_station_links(ctStationsDist, pMapStationsNode)
    return ctStationsDist
end

function load_resources_stations()
    local sDirPath = RPath.RSC_FIELDS
    local sMapStationsPath = sDirPath .. "/MapStations.img.xml"

    local pMapStationsNode = SXmlProvider:load_xml(sMapStationsPath)

    local ctFieldsExtDist = init_field_external_links(pMapStationsNode)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Stations

    return ctFieldsExtDist
end
