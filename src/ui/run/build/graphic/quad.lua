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
require("ui.constant.config")
require("ui.struct.component.basic.quad")
require("ui.struct.worldmap.basic.sprite")

function load_xml_sprite(pXmlNode)
    local iOx
    local iOy
    local iZ
    iOx, iOy, iZ = load_xml_image(pXmlNode)

    local pXmlDelayNode = pXmlNode:get_child_by_name("delay")
    local iDelay = pXmlDelayNode and pXmlDelayNode:get_value() or RWndConfig.QUAD_DELAY_DEF

    local pSpriteNode = CWmapBasicSprite:new({iOx = iOx, iOy = iOy, iZ = iZ, iDelay = iDelay})
    return pSpriteNode
end
