--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

local function read_station_distances(ctStationsDist, pMapStationsNode)
    local pStationsImgNode = pMapStationsNode:get_child_by_name("MapStations.img")

    for _, pStationNode in pairs(pStationsImgNode:get_children()) do
        local iMapid = pStationNode:get_name_tonumber()
        ctStationsDist:add_station_entry(iMapid)

        for _, pStationNeighborNode in pairs(pStationNode:get_children()) do
            local iToMapid = pStationNeighborNode:get_value()

            if iMapid ~= iToMapid then
                ctStationsDist:add_station_distance(iMapid, iToMapid, 1)
            end
        end
    end
end

function init_field_external_distances(pMapStationsNode)
    local ctStationsDist = CStationDistanceTable:new()
    read_station_distances(ctStationsDist, pMapStationsNode)
    return ctStationsDist
end
