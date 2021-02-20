--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.graphic.image")
require("ui.run.build.graphic.media.image")
require("ui.struct.worldmap.element.background")

function load_xml_worldmap_base_img(pXmlBaseImg, tpPathImgs)
    local pImg = fetch_image_from_container(tpPathImgs, "baseImg/0")

    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = load_xml_image(pXmlSpriteNode)

    local pBaseImg = CWmapElemBackground:new()
    pBaseImg:load(pImg, iOx, iOy, iZ, 0, 0)

    return pBaseImg
end
