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
require("utils.provider.xml.provider")

function load_frame_worldmap(sWmapName)
    local sWmapNodePath = RInterface.WMAP_DIR .. "/" .. sWmapName .. ".img"
    local sWmapImgPath = "images/" .. sWmapNodePath

    local pXmlWmapNode = SXmlProvider:load_xml(sWmapNodePath)
    local tpWmapImgs = load_images_from_wz_sub(sWmapImgPath)

    return pXmlWmapNode, tpWmapImgs
end
