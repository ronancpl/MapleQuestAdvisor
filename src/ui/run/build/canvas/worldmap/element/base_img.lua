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
require("ui.run.build.interface.storage.split")
require("ui.struct.canvas.worldmap.element.background")

function load_node_worldmap_base_img(pWmapProp, pBaseImgNode, pDirWmapImgs)
    local pImg = find_image_on_storage(pDirWmapImgs, "BaseImg/0")

    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = pBaseImgNode:get_image()

    local pBgrd = CWmapElemBackground:new()
    pBgrd:load(pWmapProp, pImg, iOx, iOy, iZ, 0, 0)

    return pBgrd
end
