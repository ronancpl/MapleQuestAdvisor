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

local function init_field_entries(ctFieldsDist, pNeighborsImgNode)
    for _, pFieldNode in pairs(pNeighborsImgNode:get_children()) do
        local iMapid = pFieldNode:get_name_tonumber()
        ctFieldsDist:add_field_entry(iMapid)
    end
end

local function in_same_region(iMapid, iToMapid)
    return math.floor(iMapid / 10000000) == math.floor(iToMapid / 10000000) and iMapid > iToMapid
end

local function read_field_distances(ctFieldsDist, pNeighborsImgNode)
    for _, pFieldNode in pairs(pNeighborsImgNode:get_children()) do
        local iMapid = pFieldNode:get_name_tonumber()

        for _, pFieldNeighborNode in pairs(pFieldNode:get_children()) do
            local iToMapid = pFieldNeighborNode:get_value()

            if in_same_region(iMapid, iToMapid) then
                -- bidirectional graph, accept as neighbors if referenced mapid share region (unlink FM rooms)

                ctFieldsDist:add_field_distance(iMapid, iToMapid, 1)
                ctFieldsDist:add_field_distance(iToMapid, iMapid, 1)
            end
        end
    end
end

local function init_field_distances(pMapNeighborsNode)
    local ctFieldsDist = CFieldDistanceTable:new()

    local pNeighborsImgNode = pMapNeighborsNode:get_child_by_name("MapNeighbors.img")
    init_field_entries(ctFieldsDist, pNeighborsImgNode)
    read_field_distances(ctFieldsDist, pNeighborsImgNode)

    return ctFieldsDist
end

function load_resources_fields()
    local sDirPath = RPath.RSC_FIELDS
    local sMapNeighborsPath = sDirPath .. "/MapNeighbors.img.xml"

    local pMapNeighborsNode = SXmlProvider:load_xml(sMapNeighborsPath)

    local ctFieldsDist = init_field_distances(pMapNeighborsNode)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Neighbors
    return ctFieldsDist
end

local function load_field_return_areas(ctFieldsMeta, sFilePath)
    local tFieldOverworld = read_plain_table(sFilePath)

    for _, pFieldEntry in ipairs(tFieldOverworld) do
        local iSrcid = tonumber(string.sub(pFieldEntry[1], 20, -9))
        local iDestId = tonumber(pFieldEntry[2])

        ctFieldsMeta:add_field_return(iSrcid, iDestId)
    end
end

local function load_field_overworld_areas(ctFieldsMeta, sFilePath)
    local tFieldOverworld = read_plain_table(sFilePath)

    for _, pFieldEntry in ipairs(tFieldOverworld) do
        local nEntries = #pFieldEntry
        if (nEntries <= 2) then    -- ignore not-in-overworld areas
            local iSrcid = tonumber(pFieldEntry[1])
            local iDestId = tonumber(pFieldEntry[2])

            ctFieldsMeta:add_field_overworld(iSrcid, iDestId)
        end
    end
end

local function load_field_names(ctFieldsMeta, pMapStringNode)
    local pMapStringNode = pMapStringNode:get_child_by_name("Map.img")

    for _, pRegionNode in pairs(pMapStringNode:get_children()) do

        for _, pFieldNode in pairs(pRegionNode:get_children()) do
            local iMapid = pFieldNode:get_name_tonumber()

            local sStreetName = pFieldNode:get_child_by_name("streetName")
            local sMapName = pFieldNode:get_child_by_name("mapName")

            ctFieldsMeta:set_field_name(iMapid, sStreetName, sMapName)
        end
    end
end

local function load_field_string(ctFieldsMeta)
    local sDirPath = RPath.RSC_STRINGS
    local sMapStringsPath = sDirPath .. "/Map.img.xml"

    local pMapStringNode = SXmlProvider:load_xml(sMapStringsPath)
    load_field_names(ctFieldsMeta, pMapStringNode)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: String
end

function load_more_resources_fields()
    local sDirPath = RPath.RSC_META_FIELDS
    local sMapOverworldPath = sDirPath .. "/map_overworld.txt"
    local sMapReturnPath = sDirPath .. "/map_return_areas.txt"

    local ctFieldsMeta = CFieldMetaTable:new()
    load_field_overworld_areas(ctFieldsMeta, sMapOverworldPath)
    load_field_return_areas(ctFieldsMeta, sMapReturnPath)
    load_field_string(ctFieldsMeta)

    return ctFieldsMeta
end
