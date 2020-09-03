--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.fields.field_distance_table")
require("router.filters.path")

function read_field_distances(tFieldDist, pMapNeighborsNode)
    local pNeighborsImgNode = pMapNeighborsNode:get_child_by_name("MapNeighbors.img")

    for _, pFieldNode in pairs(pNeighborsImgNode:get_children()) do
        local iMapid = pFieldNode:get_name_tonumber()
        tFieldDist:add_field_entry(iMapid)

        for _, pFieldNeighborNode in pairs(pFieldNode:get_children()) do
            local iToMapid = pFieldNeighborNode:get_value()
            tFieldDist:add_field_distance(iMapid, iToMapid, 1)
        end
    end
end

function init_field_distances(pMapNeighborsNode)
    local tFieldDist = CFieldDistanceTable:new()
    read_field_distances(tFieldDist, pMapNeighborsNode)
    return tFieldDist
end

function load_resources_fields()
    local sDirPath = RPath.RSC_FIELDS
    local sMapNeighborsPath = sDirPath .. "/MapNeighbors.img.xml"

    SXmlProvider:init()
    local pMapNeighborsNode = SXmlProvider:load_xml(sMapNeighborsPath)

    local tFieldDist = init_field_distances(pMapNeighborsNode)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Neighbors
    return tFieldDist
end
