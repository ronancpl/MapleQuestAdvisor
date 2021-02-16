--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.load.image")

local function load_worldmap_img_node(pXmlWorldmapNode, sWmapDirPath)
    local pXmlWmapNode = pXmlWorldmapNode

    local rgsPath = split_path(sWmapDirPath)
    for i = 3, #rgsPath, 1 do       -- skips "Map.wz\WorldMap"
        pXmlWmapNode = pXmlWmapNode:get_child_by_name(rgsPath[i])
    end

    return pXmlWmapNode
end

local function load_frame_worldmap_contents(pXmlWorldmapNode, sWmapDirPath)
    local pXmlWmapNode = load_worldmap_img_node(pXmlWorldmapNode, sWmapDirPath)
    local tpWmapImgs = load_images_from_wz_sub(sWmapDirPath)

    return pXmlWmapNode, tpWmapImgs
end

local function build_frame_worldmap_region(pScene, pXmlWmapNode, tpWmapImgs)

    local a = CWmapCanvas:new()



    local pXmlBaseImg = pXmlWmapNode:get_child_by_name("baseImg")

    local sWmapStepOut = pXmlWmapNode:get_child_by_name("info/parentMap"):get_value()

    local pXmlMapLinksNode = pXmlWmapNode:get_child_by_name("MapLink")
    for _, pXmlMapLink in ipairs(pXmlMapLinksNode:get_children()) do
        local pXmlLink = pXmlMapLink:get_child_by_name("link")

        local pXmlImgNode = pXmlLink:get_child_by_name("linkImg")
        local sWmapStepIn = pXmlLink:get_child_by_name("linkMap"):get_value()



    end

end

function load_frame_worldmap_region(sWmapDirPath)
    local pXmlWmapNode
    local tpWmapImgs
    pXmlWmapNode, tpWmapImgs = load_frame_worldmap_contents(sWmapDirPath)

    build_frame_worldmap_region(pXmlWmapNode, tpWmapImgs)
end
