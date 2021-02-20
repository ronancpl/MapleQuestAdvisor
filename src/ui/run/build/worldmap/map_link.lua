--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.graphic.media.image")
require("ui.struct.worldmap.element.region")

function load_xml_worldmap_map_link(pXmlMapLink, tpPathImgs, sXmlPath)
    local sTooltip = pXmlMapLink:get_child_by_name("toolTip"):get_value()

    local pXmlLinkNode = pXmlMapLink:get_child_by_name("link")
    local pXmlImgNode = pXmlLinkNode:get_child_by_name("linkImg")
    local sLinkMap = pXmlLinkNode:get_child_by_name("linkMap"):get_value()

    local pImg = fetch_image_from_container(tpPathImgs, sXmlPath)

    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = load_xml_image(pXmlImgNode)

    local pRegionLink = CWmapElemRegionLink:new()
    pRegionLink:load(pImg, iOx, iOy, iZ, 0, 0)
    pRegionLink:set_link_map(sLinkMap)
    pRegionLink:set_tooltip(sTooltip)

    return pRegionLink
end
