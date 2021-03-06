--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.image")
require("ui.struct.worldmap.component.link.link")
require("ui.struct.worldmap.component.link.link_img")
require("ui.struct.worldmap.component.link.map_link")

local function load_xml_worldmap_comp_tooltip(pXmlWorldmapLink)
    local sTooltip = pXmlWorldmapLink:get_child_by_name("toolTip"):get_value()
    return sTooltip
end

local function load_xml_worldmap_comp_link_region_image(pXmlRegionLink)
    local iOx
    local iOy
    local iZ
    local iOx, iOy, iZ = load_xml_image(pXmlRegionLink:get_child_by_name("linkImg"))

    local pImgLink = CWmapNodeLinkImage:new({iOx = iOx, iOy = iOy, iZ = iZ})
    return pImgLink
end

local function load_xml_worldmap_comp_link_region_map(pXmlRegionLink)
    local sRegionLink = pXmlRegionLink:get_child_by_name("linkMap"):get_value()
    return sRegionLink
end

local function load_xml_worldmap_comp_link(pXmlWorldmapLink)
    local pXmlWorldmapLinkNode = pXmlWorldmapLink:get_child_by_name("link")

    local pImgLink = load_xml_worldmap_comp_link_region_image(pXmlWorldmapLinkNode)
    local sRegionLink = load_xml_worldmap_comp_link_region_map(pXmlWorldmapLinkNode)

    local pNodeLink = CWmapNodeLink:new()
    pNodeLink:set_link_image(pImgLink)
    pNodeLink:set_link_map(sRegionLink)

    return pNodeLink
end

function load_xml_worldmap_link(pXmlWorldmapLink)
    local iNodeid = pXmlWorldmapLink:get_name_tonumber()

    local pNodeLink = load_xml_worldmap_comp_link(pXmlWorldmapLink)
    local sTooltip = load_xml_worldmap_comp_tooltip(pXmlWorldmapLink)

    local pWmapLink = CWmapLink:new()
    pWmapLink:set_link(pNodeLink)
    pWmapLink:set_tool_tip(sTooltip)

    return iNodeid, pWmapLink
end
