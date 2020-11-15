--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.containers.fields.field_worldmap_table")
require("router.filters.path")
require("structs.field.worldmap.maplink")
require("structs.field.worldmap.maplist")
require("structs.field.worldmap.worldmap")
require("utils.provider.xml.provider")

local function load_worldmap_node(pWorldmapElementNode)
    local pWmapNode = CWorldmapNode:new()

    pWmapNode:set_title(pWorldmapElementNode:get_child_by_name("title"))
    pWmapNode:set_desc(pWorldmapElementNode:get_child_by_name("desc"))

    local rgiMapnos = {}
    for _, pMapnoNode in ipairs(pWorldmapElementNode:get_child_by_name("mapNo"):get_children()) do
        table.insert(rgiMapnos, pMapnoNode:get_value())
    end
    pWmapNode:set_mapno_list(rgiMapnos)

    return pWmapNode
end

local function load_worldmap_link(pWorldmapLinkNode)
    local pWmapLink = CWorldmapLink:new()

    pWmapLink:set_region(pWorldmapLinkNode:get_child_by_name("linkMap"))

    return pWmapLink
end

local function load_worldmap_body(pWorldmapFileNode)
    local sName = pWorldmapFileNode:get_name()

    local rgpNodes = {}
    for _, pWorldmapElementNode in ipairs(pWorldmapFileNode:get_child_by_name("MapList"):get_children()) do
        local pWmapNode = load_worldmap_node(pWorldmapElementNode)
        table.insert(rgpNodes, pWmapNode)
    end

    local rgpLinks = {}
    for _, pWorldmapLinkNode in ipairs(pWorldmapFileNode:get_child_by_name("MapLink"):get_children()) do
        local pWmapLink = load_worldmap_link(pWorldmapLinkNode)
        table.insert(rgpLinks, pWmapLink)
    end

    return sName, rgpNodes, rgpLinks
end

local function load_worldmap_file(sWmapDirPath, sWmapName)
    local pWorldmapFileNode = SXmlProvider:load_xml(sMapNeighborsPath)

    local sName
    local rgpNodes
    local rgpLinks
    sName, rgpNodes, rgpLinks = load_worldmap_body(pWorldmapFileNode)

    local pWmapRegion = CWorldmapRegion:new()
    pWmapRegion:set_name(sName)
    pWmapRegion:set_nodes(rgpNodes)
    pWmapRegion:set_links(rgpLinks)

    return pWmapRegion
end

local function init_worldmap(sWmapDirPath)
    local ctFieldsWmap = CFieldWorldmapTable:new()

    local rgsWmapsToLoad = {}
    table.insert(rgsWmapsToLoad, "WorldMap")

    while #rgsWmapsToLoad > 0 do
        local sWmapName = table.remove(rgsWmapsToLoad)

        local pWmapRegion = load_worldmap_file(sWmapDirPath, sWmapName)
        ctFieldsWmap:add_region_entry(sWmapName, pWmapRegion)

        for _, pWmapLink in ipairs(pWmapRegion:get_links()) do
            table.insert(rgsWmapsToLoad, pWmapLink:get_region_name())
        end
    end

    return ctFieldsWmap
end

function load_resources_worldmap()
    local sDirPath = RPath.RSC_FIELDS
    local sWmapDirPath = sDirPath .. "/WorldMap"

    local ctFieldsWmap = init_worldmap(sWmapDirPath)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Worldmap
    return ctFieldsWmap
end
