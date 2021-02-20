--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.graphic.worldmap")
require("ui.run.build.graphic.media.image")
require("ui.run.build.worldmap.base_img")

function load_frame_worldmap_region(pXmlWmapNode, tpWmapImgs, sXmlPath)
    local pUiWmap = load_interface_worldmap()
    local pWmapProps = pUiWmap:get_properties()

    local pXmlBaseImg = pXmlWmapNode:get_child_by_name("baseImg")
    local pBaseImg = load_xml_worldmap_base_img(pXmlBaseImg, tpWmapImgs)
    pWmapProps:set_base_img(pBaseImg)

    local sWmapStepOut = pXmlWmapNode:get_child_by_name("info/parentMap"):get_value()
    pWmapProps:set_parent_map(sWmapStepOut)

    local pXmlMapLinksNode = pXmlWmapNode:get_child_by_name("MapLink")
    for _, pXmlMapLink in ipairs(pXmlMapLinksNode:get_children()) do
        local pRegionLink = load_xml_worldmap_map_link(pXmlMapLink)
        pWmapProps:load_map_link(pRegionLink)
    end

    local pXmlMapListNode = pXmlWmapNode:get_child_by_name("MapList")
    for _, pXmlMapNode in ipairs(pXmlMapListNode:get_children()) do
        local pFieldList = load_xml_worldmap_map_list(pXmlMapNode)
        pWmapProps:load_map_field(pFieldList)
    end

    return pUiWmap
end
