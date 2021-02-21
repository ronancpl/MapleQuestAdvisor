--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.worldmap.base_img")
require("ui.run.build.worldmap.map_link")
require("ui.run.build.worldmap.map_list")
require("ui.run.load.window.worldmap")

function load_frame_worldmap_region(pWmapRegion, tpWmapImgs)
    local pUiWmap = load_interface_worldmap()
    local pWmapProps = pUiWmap:get_properties()

    local pBaseImgNode = pWmapRegion:get_base_img()
    local pBaseImg = load_node_worldmap_base_img(pBaseImgNode, tpWmapImgs)
    pWmapProps:set_base_img(pBaseImg)

    local sWmapParent = pWmapRegion:get_parent_map()
    pWmapProps:set_parent_map(sWmapParent)

    local tpLinks = pWmapRegion:get_links()
    for _, pPair in ipairs(spairs(tpLinks, function (a, b) return a < b end)) do
        local pMapLink = pPair[2]

        local pRegionLink = load_node_worldmap_map_link(pMapLink, tpWmapImgs)
        pWmapProps:load_map_link(pRegionLink)
    end

    local tpNodes = pWmapRegion:get_nodes()
    for _, pPair in ipairs(spairs(tpNodes, function (a, b) return a < b end)) do
        local pMapNode = pPair[2]

        local pFieldList = load_node_worldmap_map_list(pMapNode, tpWmapImgs)
        pWmapProps:load_map_field(pFieldList)
    end

    return pUiWmap
end
