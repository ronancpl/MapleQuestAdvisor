--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.run.build.graphic.quad")
require("ui.run.build.interface.storage.split")
require("ui.struct.component.basic.quad")

function load_node_quad(pSpriteNode, pImg)
    local iOx
    local iOy
    iOx, iOy = pSpriteNode:get_spot()

    local iZ = pSpriteNode:get_z()

    local iDelay = pSpriteNode:get_delay()

    local pQuad = CBasicQuad:new()
    pQuad:load(pImg, iOx, iOy, iZ, iDelay)

    return pQuad
end
