--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.fields.field_distance_table")
require("composer.containers.fields.field_meta_table")
require("composer.string.field")
require("router.constants.graph")
require("router.constants.path")
require("router.procedures.constant")
require("utils.procedure.euclidean")
require("utils.procedure.string")
require("utils.procedure.unpack")
require("utils.provider.text.table")
require("utils.provider.xml.provider")

local function init_field_entries(ctFieldsDist, pNeighborsImgNode)
    local tiMapid = {}

    for _, pFieldNode in pairs(pNeighborsImgNode:get_children()) do
        local iMapid = pFieldNode:get_name_tonumber()
        tiMapid[iMapid] = 1

        for _, pFieldNeighborNode in pairs(pFieldNode:get_children()) do
            local iToMapid = pFieldNeighborNode:get_value()
            tiMapid[iToMapid] = 1
        end
    end

    for iMapid, _ in pairs(tiMapid) do
        ctFieldsDist:add_field_entry(iMapid)
    end
end

local function get_world_map_section_id(ctFieldsWmap, iMapid)
    local iWmapid = ctFieldsWmap:get_worldmapid_by_area(iMapid) or -10
    return math.floor(iWmapid / 10)
end

local function get_world_map_fields(ctFieldsMeta, ctFieldsWmap, iMapid, iToMapid)
    local iFieldMapid = ctFieldsMeta:get_field_overworld(ctFieldsMeta:get_field_return(iMapid))
    local iToFieldMapid = ctFieldsMeta:get_field_overworld(ctFieldsMeta:get_field_return(iToMapid))

    return get_world_map_section_id(ctFieldsWmap, iFieldMapid), get_world_map_section_id(ctFieldsWmap, iToFieldMapid)
end

local function is_in_same_world_map_node(ctFieldsMeta, ctFieldsWmap, iMapid, iToMapid, bNeighborFile)
    local iRetWmapid, iRetToWmapid = get_world_map_fields(ctFieldsMeta, ctFieldsWmap, iMapid, iToMapid)

    local bNeighborByWmap = iRetWmapid == iRetToWmapid
    local bNeighborById = (iRetWmapid < 0 or iRetToWmapid < 0) and math.floor(iMapid / 100) == math.floor(iToMapid / 100) and calc_word_distance(iMapid % 100, iToMapid % 100) < 3

    return bNeighborByWmap or (bNeighborFile and bNeighborById)
end

local function read_field_distances(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, pNeighborsImgNode)
    for _, pFieldNode in pairs(pNeighborsImgNode:get_children()) do
        local iMapid = pFieldNode:get_name_tonumber()

        for _, pFieldNeighborNode in pairs(pFieldNode:get_children()) do
            local iToMapid = pFieldNeighborNode:get_value()
            if is_in_same_world_map_node(ctFieldsMeta, ctFieldsWmap, iMapid, iToMapid, true) then    -- accept as neighbors if referenced mapid share region (unlink FM rooms)
                ctFieldsDist:add_field_distance(iMapid, iToMapid, 1)
                ctFieldsDist:add_field_distance(iToMapid, iMapid, 1)
            end
        end
    end
end

local function init_field_distances(ctFieldsMeta, ctFieldsWmap, pMapNeighborsNode)
    local ctFieldsDist = CFieldDistanceTable:new()

    local pNeighborsImgNode = pMapNeighborsNode:get_child_by_name("MapNeighbors.img")
    init_field_entries(ctFieldsDist, pNeighborsImgNode)
    read_field_distances(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, pNeighborsImgNode)

    return ctFieldsDist
end

local function fetch_script_name(sScriptPath)
    local iIdx = string.rfind(sScriptPath, "/")
    return (sScriptPath:sub(-iIdx+1))
end

local function load_field_script_file(sFilePath)
    local tScriptMaps = read_plain_table(sFilePath)

    local trgpScriptMapids = {}
    for _, pScriptEntry in ipairs(tScriptMaps) do
        local sScriptName = fetch_script_name(pScriptEntry[1])

        local rgpMapids = {}
        trgpScriptMapids[sScriptName] = rgpMapids

        for i = 2, #pScriptEntry, 1 do
            local iMapId = tonumber(pScriptEntry[i])
            table.insert(rgpMapids, iMapId)
        end
    end

    return trgpScriptMapids
end

local function fetch_valid_area_script(ctFieldsDist, rgiAreas)
    local trgiValidAreas = {}

    if #rgiAreas <= RGraph.REGION_AREAS_SCRIPT_THRESHOLD then
        for _, iMapid in ipairs(rgiAreas) do
            local iRegionid = get_region_id(iMapid)

            local rgiValidAreas = trgiValidAreas[iRegionid]
            if rgiValidAreas == nil then
                rgiValidAreas = {}
                trgiValidAreas[iRegionid] = rgiValidAreas
            end

            if ctFieldsDist:get_field_distances(iMapid) ~= nil then
                table.insert(rgiValidAreas, iMapid)
            end
        end
    end

    return trgiValidAreas
end

local function load_field_scripts(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, sFileName)
    local sDirPath = RPath.RSC_META_PORTALS
    local sFilePath = sDirPath .. "/" .. sFileName

    local trgpScriptAreas = load_field_script_file(sFilePath)
    for _, rgiAreas in pairs(trgpScriptAreas) do
        local rgiValidAreas = fetch_valid_area_script(ctFieldsDist, rgiAreas)
        for _, rgiValidSectionAreas in pairs(rgiValidAreas) do
            for _, iMapid in ipairs(rgiValidSectionAreas) do
                for _, iToMapid in ipairs(rgiValidSectionAreas) do
                    if is_in_same_world_map_node(ctFieldsMeta, ctFieldsWmap, iMapid, iToMapid, false) then
                        ctFieldsDist:add_field_distance(iMapid, iToMapid, 1)
                        ctFieldsDist:add_field_distance(iToMapid, iMapid, 1)
                    end
                end
            end
        end
    end
end

local function clear_redundant_field_links(ctFieldsDist)
    for _, iMapid in ipairs(ctFieldsDist:get_field_entries()) do
        ctFieldsDist:remove_field_distance(iMapid, iMapid)
    end
end

function load_resources_fields(ctFieldsMeta, ctFieldsWmap)
    local sDirPath = RPath.RSC_FIELDS
    local sMapNeighborsPath = sDirPath .. "/MapNeighbors.img.xml"

    local pMapNeighborsNode = SXmlProvider:load_xml(sMapNeighborsPath)

    local ctFieldsDist = init_field_distances(ctFieldsMeta, ctFieldsWmap, pMapNeighborsNode)

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
        if nEntries <= 2 then    -- ignore not-in-overworld areas
            local iSrcid = tonumber(pFieldEntry[1])
            local iDestId = tonumber(pFieldEntry[2])

            ctFieldsMeta:add_field_overworld(iSrcid, iDestId)
        end
    end
end

local function init_field_names(ctFieldsMeta, tsMapName, tsStreetName)
    for iMapid, sMapName in pairs(tsMapName) do
        local sStreetName = tsStreetName[iMapid]
        ctFieldsMeta:set_field_name(iMapid, sStreetName, sMapName)
    end
end

local function load_field_names(ctFieldsMeta)
    local tsMapName, tsStreetName = load_field_string()
    init_field_names(ctFieldsMeta, tsMapName, tsStreetName)
end

function load_meta_resources_fields()
    local sDirPath = RPath.RSC_META_FIELDS
    local sMapOverworldPath = sDirPath .. "/map_overworld.txt"
    local sMapReturnPath = sDirPath .. "/map_return_areas.txt"

    local ctFieldsMeta = CFieldMetaTable:new()
    load_field_overworld_areas(ctFieldsMeta, sMapOverworldPath)
    load_field_return_areas(ctFieldsMeta, sMapReturnPath)
    load_field_names(ctFieldsMeta)

    return ctFieldsMeta
end

function load_script_resources_fields(ctFieldsDist, ctFieldsMeta, ctFieldsWmap)
    load_field_scripts(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, "portal_ex.txt")
    load_field_scripts(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, "map_ex.txt")
    load_field_scripts(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, "npc_ex.txt")
    load_field_scripts(ctFieldsDist, ctFieldsMeta, ctFieldsWmap, "reactor_ex.txt")
end

function clear_redundant_resources_fields(ctFieldsDist)
    clear_redundant_field_links(ctFieldsDist)
end
