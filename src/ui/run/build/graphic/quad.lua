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
require("structs.field.worldmap.basic.sprite")
require("ui.struct.component.basic.quad")

function load_xml_sprite(pXmlNode)
    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = load_xml_image(pXmlNode)

    local iDelay = pXmlNode:get_child_by_name("delay")

    local pSpriteNode = CWmapBasicSprite:new(iOx, iOy, iZ, iDelay)
    return pSpriteNode
end
