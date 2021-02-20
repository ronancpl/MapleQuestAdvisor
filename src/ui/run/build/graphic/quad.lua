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
require("ui.struct.component.basic.quad")

function load_xml_quad(pXmlSpriteNode, pImg)
    local iDelay = pXmlSpriteNode:get_child_by_name("delay")

    local iX
    local iY
    local iZ
    iX, iY, iZ = load_xml_image(pXmlSpriteNode)

    local pQuad = CBasicQuad:new()
    pQuad:load(pImg, iX, iY, iZ, iDelay)

    return pQuad
end
