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
require("ui.run.build.interface.storage.basic.image")

function load_frame_worldmap_region(sWmapName, ctFieldsWmap)
    local sWmapImgPath = RInterface.WMAP_DIR .. "/" .. sWmapName .. ".img"

    local pWmapRegion = ctFieldsWmap:get_region_entry(sWmapName)
    local pDirWmapImgs = load_image_storage_from_wz_sub(sWmapImgPath)

    return pWmapRegion, pDirWmapImgs
end
