--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("composer.field.node.media.image")
require("utils.provider.xml.provider")

function load_frame_worldmap(sWmapName, tpHelperImages)
    local sWmapNodePath = RInterface.WMAP_DIR .. "/" .. sWmapName .. ".img"
    local sWmapImgPath = "images/" .. sWmapNodePath

    local pWmapRegion = ctFieldsWmap:get_region_entry(sWmapName)
    local tpWmapImgs = load_images_from_wz_sub(sWmapImgPath)

    local pUiWmap = load_frame_worldmap_region(pWmapRegion, tpHelperImages, tpWmapImgs)
    return pUiWmap
end
