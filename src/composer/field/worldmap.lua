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
require("router.filters.constant")
require("router.filters.path")
require("structs.field.worldmap.basic.image")
require("structs.field.worldmap.basic.spot")
require("structs.field.worldmap.basic.sprite")
require("structs.field.worldmap.basic.textbox")
require("structs.field.worldmap.component.region")
require("utils.provider.xml.provider")

local function load_worldmap_base_img(pXmlWorldmapFile)
    local pXmlBaseImg = pXmlWorldmapFile:get_child_by_name("BaseImg/0")

    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = load_xml_image(pXmlBaseImg)

    local pImg = CWmapBasicImage:new(iOx, iOy, iZ)
    return pImg
end

local function load_worldmap_body(pXmlWorldmapFile)
    local sName = pXmlWorldmapFile:get_name()

    local pImgBase = load_worldmap_base_img(pXmlWorldmapFile)

    local sParentName = pXmlWorldmapFile:get_child_by_name("info/parentMap"):get_value()

    local tpNodes = {}
    for _, pWorldmapElementNode in pairs(pXmlWorldmapFile:get_child_by_name("MapList"):get_children()) do
        local iNodeid
        local pWmapNode

        iNodeid, pWmapNode = load_worldmap_node(pWorldmapElementNode)
        tpNodes[iNodeid] = pWmapNode
    end

    local tpLinks = {}
    local pWorldmapFileLinkNode = pXmlWorldmapFile:get_child_by_name("MapLink")
    if pWorldmapFileLinkNode ~= nil then
        for _, pWorldmapLinkNode in pairs(pWorldmapFileLinkNode:get_children()) do
            local iNodeid
            local pWmapLink

            iNodeid, pWmapLink = load_worldmap_link(pWorldmapLinkNode)
            tpLinks[iNodeid] = pWmapLink
        end
    end

    return sName, pImgBase, sParentName, tpLinks, tpNodes
end

local function load_worldmap_file(sWmapSubPath, sWmapName)
    local pXmlWorldmapFile = SXmlProvider:load_xml(sWmapSubPath .. sWmapName .. ".img.xml")

    local sName
    local pImgBase
    local sParentName
    local tpLinks
    local tpNodes
    sName, pImgBase, sParentName, tpLinks, tpNodes = load_worldmap_body(pXmlWorldmapFile:get_child_by_name(sWmapName .. ".img"))

    local pWmapRegion = CWmapNodeRegion:new()
    pWmapRegion:set_name(sName)
    pWmapRegion:set_base_img(pImgBase)
    pWmapRegion:set_parent_map(sParentName)
    pWmapRegion:set_links(tpLinks)
    pWmapRegion:set_nodes(tpNodes)

    return pWmapRegion
end

local function init_worldmap(sWmapSubPath)
    local ctFieldsWmap = CFieldWorldmapTable:new()

    local rgsWmapsToLoad = {}
    table.insert(rgsWmapsToLoad, S_WORLDMAP_BASE)

    while #rgsWmapsToLoad > 0 do
        local sWmapName = table.remove(rgsWmapsToLoad)

        local pWmapRegion = load_worldmap_file(sWmapSubPath, sWmapName)
        ctFieldsWmap:add_region_entry(sWmapName, pWmapRegion)

        for _, pWmapLink in ipairs(pWmapRegion:get_links()) do
            table.insert(rgsWmapsToLoad, pWmapLink:get_region_name())
        end
    end

    return ctFieldsWmap
end

function load_resources_worldmap()
    local sDirPath = RPath.RSC_FIELDS
    local sWmapSubPath = sDirPath .. "/WorldMap/"

    local ctFieldsWmap = init_worldmap(sWmapSubPath)

    SXmlProvider:unload_node(sDirPath)   -- free XMLs nodes: Worldmap
    return ctFieldsWmap
end
