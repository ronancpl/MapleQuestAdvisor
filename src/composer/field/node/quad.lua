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
require("ui.struct.component.basic.quad")

function load_xml_quad(pSpriteNode, pImg)
    local iDelay = pSpriteNode:get_delay()

    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = pSpriteNode:get_image()

    local pQuad = CBasicQuad:new()
    pQuad:load(pImg, iOx, iOy, iZ, iDelay)

    return pQuad
end
