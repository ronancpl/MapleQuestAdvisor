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
require("composer.containers.fields.field_meta_table")
require("router.filters.path")
require("utils.provider.text.table")

function read_field_distances(tFieldDist, pMapNeighborsNode)
    local pNeighborsImgNode = pMapNeighborsNode:get_child_by_name("MapNeighbors.img")

    for _, pFieldNode in pairs(pNeighborsImgNode:get_children()) do
        local iMapid = pFieldNode:get_name_tonumber()
        tFieldDist:add_field_entry(iMapid)

        for _, pFieldNeighborNode in pairs(pFieldNode:get_children()) do
            local iToMapid = pFieldNeighborNode:get_value()

            if iMapid ~= iToMapid then
                tFieldDist:add_field_distance(iMapid, iToMapid, 1)
            end
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

function load_field_return_areas(pFieldMeta, sFilePath)
    local tFieldOverworld = read_plain_table(sFilePath)

    for _, pFieldEntry in ipairs(tFieldOverworld) do
        local iSrcid = tonumber(string.sub(pFieldEntry[1], 20, -9))
        local iDestId = tonumber(pFieldEntry[2])

        pFieldMeta:add_field_return(iSrcid, iDestId)
    end
end

function load_field_overworld_areas(pFieldMeta, sFilePath)
    local tFieldOverworld = read_plain_table(sFilePath)

    for _, pFieldEntry in ipairs(tFieldOverworld) do
        local iEntryLen = #pFieldEntry

        if (iEntryLen <= 2) then    -- ignore not-in-overworld areas
            local iSrcid = tonumber(pFieldEntry[1])
            local iDestId = tonumber(pFieldEntry[2])

            pFieldMeta:add_field_overworld(iSrcid, iDestId)
        end
    end
end

function load_more_resources_fields()
    local sDirPath = RPath.RSC_META_FIELDS
    local sMapOverworldPath = sDirPath .. "/map_overworld.txt"
    local sMapReturnPath = sDirPath .. "/map_return_areas.txt"

    local pFieldMeta = CFieldMetaTable:new()
    load_field_overworld_areas(pFieldMeta, sMapOverworldPath)
    load_field_return_areas(pFieldMeta, sMapReturnPath)

    return pFieldMeta
end
