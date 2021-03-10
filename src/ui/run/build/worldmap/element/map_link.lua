--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.path.path")
require("ui.run.build.interface.storage.split")
require("ui.struct.worldmap.element.region")

function load_node_worldmap_map_link(pWmapProp, pMapLinkNode, pDirWmapImgs, sRegionName, iIdx)
    local sTooltip = pMapLinkNode:get_tool_tip()

    local pLinkNode = pMapLinkNode:get_link()
    local pLinkImgNode = pLinkNode:get_link_image()
    local sLinkMap = pLinkNode:get_link_map()

    local sXmlPath = RInterface.WMAP_DIR .. "/" .. sRegionName .. "/MapLink/" .. iIdx .. "/link/linkImg"
    local pImg = find_image_on_storage(pDirWmapImgs, sXmlPath)

    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = pLinkImgNode:get_image()

    local pRegionLink = CWmapElemRegionLink:new()
    pRegionLink:load(pWmapProp, pImg, iOx, iOy, iZ, 0, 0)
    pRegionLink:set_link_map(sLinkMap)
    pRegionLink:set_tooltip(sTooltip)

    return pRegionLink
end
