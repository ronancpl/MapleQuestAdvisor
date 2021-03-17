--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.fields.field_worldmap_table")
require("router.constants.path")
require("router.procedures.constant")
require("structs.field.worldmap.maplink")
require("structs.field.worldmap.maplist")
require("structs.field.worldmap.worldmap")
require("utils.provider.xml.provider")

local function load_worldmap_node(pWorldmapElementNode)
    local pWmapNode = CWorldmapNode:new()

    local iNodeid = pWorldmapElementNode:get_name_tonumber()

    pWmapNode:set_title(pWorldmapElementNode:get_child_by_name("title"))
    pWmapNode:set_desc(pWorldmapElementNode:get_child_by_name("desc"))

    local rgiMapnos = {}
    for _, pMapnoNode in pairs(pWorldmapElementNode:get_child_by_name("mapNo"):get_children()) do
        table.insert(rgiMapnos, pMapnoNode:get_value())
    end
    pWmapNode:set_mapno_list(rgiMapnos)

    return iNodeid, pWmapNode
end

local function load_worldmap_link(pWorldmapLinkNode)
    local pWmapLink = CWorldmapLink:new()

    local iNodeid = pWorldmapLinkNode:get_name_tonumber()

    local sRegionName = pWorldmapLinkNode:get_child_by_name("link"):get_child_by_name("linkMap"):get_value()
    pWmapLink:set_region_name(sRegionName)

    return iNodeid, pWmapLink
end

local function load_worldmap_body(pWorldmapFileNode)
    local sName = pWorldmapFileNode:get_name()

    local tpNodes = {}
    for _, pWorldmapElementNode in pairs(pWorldmapFileNode:get_child_by_name("MapList"):get_children()) do
        local iNodeid
        local pWmapNode

        iNodeid, pWmapNode = load_worldmap_node(pWorldmapElementNode)
        tpNodes[iNodeid] = pWmapNode
    end

    local tpLinks = {}
    local pWorldmapFileLinkNode = pWorldmapFileNode:get_child_by_name("MapLink")
    if pWorldmapFileLinkNode ~= nil then
        for _, pWorldmapLinkNode in pairs(pWorldmapFileLinkNode:get_children()) do
            local iNodeid
            local pWmapLink

            iNodeid, pWmapLink = load_worldmap_link(pWorldmapLinkNode)
            tpLinks[iNodeid] = pWmapLink
        end
    end

    return sName, tpNodes, tpLinks
end

local function load_worldmap_file(sWmapDirPath, sWmapName)
    local pWorldmapFileNode = SXmlProvider:load_xml(sWmapDirPath .. sWmapName .. ".img.xml")

    local sName
    local tpNodes
    local tpLinks
    sName, tpNodes, tpLinks = load_worldmap_body(pWorldmapFileNode:get_child_by_name(sWmapName .. ".img"))

    local pWmapRegion = CWorldmapRegion:new()
    pWmapRegion:set_name(sName)
    pWmapRegion:set_nodes(tpNodes)
    pWmapRegion:set_links(tpLinks)

    pWmapRegion:make_remissive_index_area_region()

    return pWmapRegion
end

local function init_worldmap(sWmapDirPath)
    local ctFieldsWmap = CFieldWorldmapTable:new()

    local rgsWmapsToLoad = {}
    table.insert(rgsWmapsToLoad, S_WORLDMAP_BASE)

    while #rgsWmapsToLoad > 0 do
        local sWmapName = table.remove(rgsWmapsToLoad)

        local pWmapRegion = load_worldmap_file(sWmapDirPath, sWmapName)
        ctFieldsWmap:add_region_entry(sWmapName, pWmapRegion)

        for _, pWmapLink in ipairs(pWmapRegion:get_links()) do
            table.insert(rgsWmapsToLoad, pWmapLink:get_region_name())
        end
    end

    ctFieldsWmap:make_remissive_index_area_region()
    return ctFieldsWmap
end

function load_resources_worldmap()
    local sDirPath = RPath.RSC_FIELDS
    local sWmapDirPath = sDirPath .. "/WorldMap/"

    local ctFieldsWmap = init_worldmap(sWmapDirPath)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Worldmap
    return ctFieldsWmap
end
