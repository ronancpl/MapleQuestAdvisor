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
require("ui.run.build.interface.storage.basic.quad")
require("ui.run.build.interface.storage.split")

function load_frame_position_helper()
    local sWmapImgPath = RInterface.WMAP_HELPER

    local tpHelperQuads = load_quad_storage_from_wz_sub(sWmapImgPath, "worldMap")

    local tpWmapHelperQuads = select_animations_from_storage(tpHelperQuads, {"curPos", "lovePos", "npcPos0", "npcPos1", "npcPos2", "npcPos3", "partyPos"})
    local tpWmapHelperImgs = select_images_from_storage(tpHelperQuads, {"mapImage"})

    return tpWmapHelperQuads, tpWmapHelperImgs
end

function load_nodes_position_helper(pXmlWmapHelper)
    local tpWmapNodes = {}

    for _, pXml in pairs(pXmlWmapHelper:get_children()) do

    end

    load_xml_sprite(pXmlNode)

    return tpWmapNodes
end
